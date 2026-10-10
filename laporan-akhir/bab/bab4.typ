#import "../template.typ": todo

= HASIL DAN PEMBAHASAN <bab-iv-hasil-dan-pembahasan>

== Analisa Data <analisa-data>

=== Rancangan dan Implementasi Sistem <rancangan-implementasi>

==== Arsitektur Implementasi <arsitektur-implementasi>

Arsitektur TathyaTest yang direalisasikan secara umum konsisten dengan rancangan pada Gambar 3.2 (BAB III), dengan satu perbedaan mendasar pada mesin crawling: rancangan awal mengusulkan Colly (pustaka Go untuk crawling HTML statis), namun selama implementasi ditemukan bahwa pendekatan ini tidak dapat menjangkau aplikasi web modern yang banyak memanfaatkan rendering sisi klien (client-side rendering), termasuk aplikasi single-page application (SPA) berbasis React. Oleh karena itu, mesin crawling direalisasikan ulang menggunakan Playwright (Chromium) yang menjelajahi DOM setelah dirender sepenuhnya oleh browser -- sebuah evolusi rancangan yang konsisten dengan temuan pada tinjauan pustaka (BAB II) mengenai keterbatasan crawler berbasis HTML statis pada aplikasi web modern.

Implementasi terbagi menjadi sebuah paket command-line interface (CLI) berbasis TypeScript (`tt`) dengan lima subperintah utama yang mencerminkan tahapan alur kerja pada Gambar 3.2: `tt init` (wizard konfigurasi interaktif), `tt crawl` (crawling DOM per peran pengguna), `tt generate` (pemetaan elemen menjadi spesifikasi Playwright), `tt run` (eksekusi test case), dan `tt eval` (orkestrasi evaluasi dan perhitungan metrik). Modul-modul inti meliputi: `config.ts` (validasi konfigurasi YAML), `extract/rendered.ts` (crawler Playwright), `login.ts` (deteksi form login otomatis), `rbac.ts` (penyusunan matriks akses per peran), `fieldgen.ts` dan `faker.ts` (pembangkitan varian data uji), `oracle.ts` (penentuan kondisi keberhasilan/kegagalan), `mapper.ts` (pemetaan model elemen menjadi intent test case), `locator.ts` (penentuan locator Playwright), `emit/ts.ts` (penghasil kode spesifikasi), serta `stats.ts` dan `metrics.ts` (analisis statistik dan perhitungan metrik evaluasi).

==== Modul Crawler (Playwright) <modul-crawler>

Modul crawler menggunakan Playwright untuk membuka sesi browser per peran pengguna (misalnya admin dan user), melakukan login satu kali secara terotentikasi, kemudian menjelajahi seluruh URL satu-origin yang dapat dijangkau secara breadth-first dari DOM yang telah dirender sepenuhnya (menunggu kondisi `domcontentloaded` dan `networkidle` agar aplikasi SPA sempat melakukan hidrasi). Deteksi form login dilakukan secara otomatis melalui penilaian (scoring) atribut elemen, misalnya `type="email"` atau `autocomplete="username"` diberi bobot tinggi sebagai penanda field identitas pengguna. Hasil crawling per peran disimpan sebagai berkas crawl-contract berformat JSON yang memuat seluruh form, field, tautan, tombol, dan tabel yang ditemukan. @fig-crawl-pipeline merinci alur ini pada tingkat implementasi, mulai dari peluncuran sesi dan login hingga perulangan dequeue-ekstraksi-enrich-discover sampai antrean URL habis.

#figure(
  image("/supplement/assets/diagrams/crawl-pipeline.svg", width: 92%),
  caption: [Alur Rinci Modul Crawler: Sesi Login per Peran hingga Perulangan Crawling],
) <fig-crawl-pipeline>

Kendala utama yang ditemui adalah penjelajahan aplikasi SPA (Inertia-React) yang memerlukan waktu hidrasi JavaScript lebih lama dibandingkan aplikasi server-rendered (Blade), serta kebutuhan untuk menunggu navigasi berbasis client-side routing yang tidak selalu memicu event `load` konvensional pada browser.

==== Ekstraksi Elemen HTML <modul-ekstraksi>

Ekstraksi elemen dilakukan langsung pada konteks browser menggunakan skrip evaluasi DOM (`page.evaluate()`) yang dijalankan oleh Playwright, bukan melalui pustaka parser HTML statis seperti Goquery yang diusulkan pada rancangan awal. Pendekatan ini mengidentifikasi form (termasuk klasifikasi operasi CRUD berdasarkan atribut method tersembunyi `_method` pada aplikasi Laravel: PUT/PATCH untuk update, DELETE untuk delete), field input berikut batasan validasinya (required, minlength, maxlength, pattern, dan sejenisnya), tautan, tombol (termasuk elemen dengan peran ARIA seperti `role="button"`), dan tabel. Sebuah proses tambahan menggunakan `ariaSnapshot()` meningkatkan kualitas locator yang lemah (berbasis CSS atau nama elemen) menjadi locator berbasis peran (role locator) yang lebih tahan terhadap perubahan struktur halaman.

==== Generator Test Case <modul-generator>

Modul generator memetakan model elemen, matriks akses RBAC, dan dataset ke dalam intent test case melalui lima kategori: autentikasi (`auth`), form (`forms`), interaksi (`interactions`), paginasi (`pagination`), dan kontrol akses (`rbac`). Untuk setiap field, modul `fieldgen.ts` menghasilkan varian uji bertingkat: varian positif (`valid`, diisi data acak sesuai batasan), varian negatif (`required-empty`, `pattern-fail`, `minlength-minus-one`, dan sejenisnya), serta varian tepi/edge (`maxlength-exact`, `unicode`, `whitespace`, `optional-omitted`), sebagaimana dirangkum pada @fig-constraint-variants. Data acak dibangkitkan menggunakan pustaka faker dengan seed tetap (42) agar hasil pengujian dapat direproduksi.

#figure(
  image("/supplement/assets/diagrams/constraint-variants.svg", width: 62%),
  caption: [Pemetaan Batasan Field (HTML Constraint) menjadi Varian Test Case Positif/Negatif/Tepi],
) <fig-constraint-variants>

Locator pada kode yang dihasilkan mengikuti urutan prioritas sebagaimana ditunjukkan pada @fig-locator-chain: data-testid, locator berbasis peran (`getByRole`), label (`getByLabel`), placeholder, id yang stabil, atribut nama, hingga fallback berbasis CSS -- locator berbasis posisi (nth-child) secara eksplisit dihindari karena rentan terhadap perubahan tata letak halaman.

#figure(
  image("/supplement/assets/diagrams/locator-chain.svg", width: 55%),
  caption: [Rantai Prioritas Locator: Kecocokan Pertama yang Digunakan],
) <fig-locator-chain>

Oracle (penentu hasil uji) memvalidasi kemunculan elemen galat yang sesuai (misalnya `.invalid-feedback` atau `[role=alert]`) tanpa bergantung pada kecocokan teks pesan kesalahan secara persis, agar lebih tahan terhadap perubahan redaksi pesan.

==== Eksekusi dengan Playwright <modul-eksekusi>

Eksekusi test case dikonfigurasi dengan tiga proyek browser per peran pengguna (Chromium, Firefox, dan WebKit), masing-masing menggunakan sesi login (`storageState`) yang disiapkan satu kali pada tahap global setup agar tidak perlu login berulang pada setiap test case. Konfigurasi menjalankan test secara sekuensial (satu worker) dengan batas waktu 60 detik per test, perekaman trace otomatis pada percobaan ulang pertama, serta pelaporan dalam format daftar (list) dan HTML.

=== Pengujian <pengujian>

==== Skenario Pengujian <skenario-pengujian>

TathyaTest dievaluasi dengan menjalankan `tt eval` sebanyak lima repetisi (_n_ = 5) pada masing-masing dari tiga browser, menggunakan seed faker tetap untuk menjamin reproduktibilitas. Jumlah test case yang dihasilkan beserta distribusinya menurut tingkat (tier) ditunjukkan pada @tab-jumlah-test.

#figure(
  table(
    columns: (1fr, 1.6cm, 1.6cm, 2cm, 1.4cm),
    stroke: 0.5pt,
    align: center + horizon,
    table.header([*Aplikasi*], [*Positif*], [*Negatif*], [*Tepi (Edge)*], [*Total*]),
    table.cell(align: left)[Laravel Blade], [46], [23], [34], [*103*],
    table.cell(align: left)[Laravel Inertia-React], [46], [23], [34], [*103*],
    table.cell(align: left)[SauceDemo], [18], [4], [9], [*31*],
  ),
  caption: [Jumlah Test Case yang Dihasilkan per Aplikasi dan Tingkat],
) <tab-jumlah-test>

==== Lingkungan Pengujian <lingkungan-pengujian>

Pengujian dilakukan pada tiga aplikasi studi kasus: (1) aplikasi Laravel berbasis Blade (server-rendered), (2) aplikasi Laravel berbasis Inertia-React (SPA), keduanya merupakan aplikasi todo-list dengan kontrol akses berbasis peran (admin dan user) yang dikembangkan sendiri sebagai subjek uji terinstrumentasi (dilengkapi endpoint pengukuran cakupan kode dan injeksi cacat terkendali), serta (3) SauceDemo, sebuah aplikasi e-commerce eksternal yang digunakan sebagai pembanding (baseline) untuk menilai generalisasi di luar aplikasi yang dikembangkan sendiri oleh tim peneliti. Pengujian dijalankan pada tiga mesin peramban (Chromium, Firefox, WebKit) sebanyak lima repetisi untuk setiap aplikasi.

=== Hasil Pengujian <hasil-pengujian>

@tab-cakupan menunjukkan hasil pengukuran cakupan model (persentase elemen, rute, form, field, navigasi, dan matriks RBAC yang berhasil dipetakan dari hasil crawling) dan cakupan kode sumber aplikasi (diukur hanya pada kedua aplikasi Laravel, karena SauceDemo merupakan aplikasi eksternal yang tidak dapat diinstrumentasi).

#figure(
  table(
    columns: (1fr, 2.1cm, 2.4cm, 2cm, 1.8cm),
    stroke: 0.5pt,
    align: center + horizon,
    table.header([*Aplikasi*], [*Cakupan Model*], [*Baris Kode*], [*Fungsi*], [*Rute*]),
    table.cell(align: left)[Laravel Blade], [100,0% (44/44)], [21,6% (92/426)], [69,6% (39/56)], [87,5% (7/8)],
    table.cell(align: left)[Laravel Inertia-React], [100,0% (46/46)], [23,3% (104/446)], [68,4% (39/57)], [87,5% (7/8)],
    table.cell(align: left)[SauceDemo], [100,0% (20/20)], [--], [--], [--],
  ),
  caption: [Cakupan Model Elemen dan Cakupan Kode Sumber per Aplikasi],
) <tab-cakupan>

@tab-deteksi-keandalan menunjukkan hasil pengukuran deteksi cacat (mutation testing dengan sembilan cacat terkendali yang disuntikkan pada lima kategori: validasi, otorisasi, CRUD, paginasi, dan autentikasi) serta keandalan dan efisiensi eksekusi.

#figure(
  table(
    columns: (1fr, 2.1cm, 1.8cm, 1.6cm, 2.3cm, 1.8cm),
    stroke: 0.5pt,
    align: center + horizon,
    table.header([*Aplikasi*], [*Skor Mutasi*], [*Flake Rate*], [*Pass Rate*], [*Waktu Eksekusi*], [*Penghematan Waktu*]),
    table.cell(align: left)[Laravel Blade], [100,0% (9/9)], [0,2%], [98,9%], [976 s ± 78 s], [30,6×],
    table.cell(align: left)[Laravel Inertia-React], [100,0% (9/9)], [0,0%], [100,0%], [1015 s ± 25 s], [29,4×],
    table.cell(align: left)[SauceDemo], [--], [5,4%], [98,7%], [311 s ± 58 s], [29,4×],
  ),
  caption: [Deteksi Cacat (Mutation Score), Keandalan, dan Efisiensi Eksekusi per Aplikasi],
) <tab-deteksi-keandalan>

Akurasi lokalisasi cacat (kemampuan test case yang gagal untuk menunjuk tepat pada kategori cacat yang disuntikkan) tercatat 100,0% pada kedua aplikasi Laravel. Kesepakatan hasil pengujian antar-browser (diukur dengan Fleiss' kappa) mencapai κ = 1,00 pada Blade dan Inertia-React, menunjukkan hasil yang sangat konsisten lintas Chromium, Firefox, dan WebKit; pada SauceDemo, κ = −0,01, sebuah nilai yang secara teknis rendah namun merupakan artefak dari "paradoks prevalensi" pada statistik kappa ketika hampir seluruh percobaan bernilai sama (pass), bukan indikasi ketidakkonsistenan yang substantif.

Dari sisi kualitas test suite, rasio locator rapuh (brittle-locator, yaitu locator berbasis CSS atau posisi yang mudah rusak oleh perubahan tata letak) pada test case yang dihasilkan TathyaTest tercatat 2,3--4,7%, dengan ketahanan locator (locator robustness) 68,0--74,3%. Sebagai pembanding, test suite publik eksternal untuk SauceDemo yang digunakan sebagai baseline memiliki rasio locator rapuh sebesar 62,5% -- jauh lebih tinggi dibandingkan 4,0% pada test case yang dihasilkan TathyaTest untuk aplikasi yang sama. Pengujian statistik Mann-Whitney U terhadap durasi eksekusi test case yang dihasilkan dibandingkan baseline manual menunjukkan perbedaan yang signifikan secara statistik pada ketiga aplikasi (p < 0,001).

#todo("Tambahkan tangkapan layar (screenshot) contoh eksekusi Playwright dan contoh kode test case yang dihasilkan, jika diperlukan untuk pelengkap laporan.")

== Pembahasan <pembahasan>

Dibandingkan dengan target yang ditetapkan pada BAB III (Persamaan 3.1 dan 3.2: minimal 80% test coverage dan 85% accuracy rate), hasil evaluasi menunjukkan capaian yang perlu dimaknai secara berlapis karena terdapat dua jenis "cakupan" yang berbeda maknanya. *Cakupan model* -- persentase elemen, rute, form, field, navigasi, dan matriks RBAC yang berhasil diidentifikasi dan dipetakan oleh TathyaTest dari hasil crawling -- mencapai 100,0% pada ketiga aplikasi, jauh melampaui target 80%. Namun demikian, cakupan ini mengukur kelengkapan terhadap model yang dibangun TathyaTest sendiri ("completeness by construction"), bukan cakupan baris kode sumber aplikasi secara keseluruhan. *Cakupan baris kode* (line coverage) yang diukur langsung dari instrumentasi PCOV pada aplikasi Laravel tercatat jauh lebih rendah, yaitu 21,6% (Blade) dan 23,3% (Inertia-React). Hal ini merupakan konsekuensi wajar dari desain TathyaTest yang berfokus pada pengujian fungsional berbasis antarmuka pengguna (UI-level black-box testing) dan hanya menjangkau elemen yang tampak pada DOM -- logika di balik antarmuka yang tidak termanifestasi sebagai elemen DOM yang dapat berinteraksi, seperti validasi kustom pada sisi server, tidak dapat terdeteksi melalui pendekatan ini. Sebagai indikator yang lebih relevan dengan tujuan pengujian fungsional, cakupan rute (route coverage) tercatat 87,5% pada kedua aplikasi Laravel.

Untuk metrik akurasi, skor mutasi (mutation score) -- persentase cacat buatan (mutant) yang berhasil terdeteksi oleh test case yang dihasilkan -- digunakan sebagai proksi accuracy rate yang didefinisikan pada Persamaan 3.2, karena secara langsung mengukur kemampuan test case mendeteksi penyimpangan fungsional. Skor mutasi sebesar 100,0% (9 dari 9 cacat terdeteksi) pada kedua aplikasi Laravel melampaui target 85% yang ditetapkan, dengan akurasi lokalisasi cacat turut mencapai 100,0%. Temuan ini mengonfirmasi jawaban atas rumusan masalah ketiga (BAB I): TathyaTest mampu memvalidasi ekspektasi fungsional aplikasi -- termasuk login, penyimpanan data, dan kontrol akses modul berbasis peran -- dengan tingkat keandalan yang tinggi pada kedua kategori cacat fungsional dan cacat otorisasi.

Dari sisi efisiensi, waktu eksekusi penuh test suite yang dihasilkan (976 detik untuk Blade, 1015 detik untuk Inertia-React) menghasilkan estimasi penghematan waktu sekitar 29--31 kali dibandingkan estimasi biaya penulisan test case secara manual, dengan signifikansi statistik yang kuat (Mann-Whitney U, p < 0,001 pada ketiga aplikasi). Rasio locator rapuh yang jauh lebih rendah pada test case hasil generate TathyaTest dibandingkan test suite publik pembanding (4,0% berbanding 62,5% pada SauceDemo) juga mengindikasikan bahwa test case yang dihasilkan secara otomatis tidak hanya lebih cepat dibuat, tetapi juga berpotensi lebih tahan terhadap perubahan kecil pada antarmuka aplikasi dibandingkan sebagian test suite tulisan manual.

Beberapa keterbatasan perlu dicatat: evaluasi hanya mencakup elemen yang tampak pada DOM (tidak menjangkau logika tersembunyi seperti aturan validasi kustom pada FormRequest Laravel), cakupan kode menggunakan proksi cabang (branch-proxy) alih-alih instrumentasi cabang penuh, katalog cacat yang diujikan terbatas pada sembilan cacat dalam lima kategori, dan baseline manual pembanding berjumlah relatif kecil (5 test case per aplikasi Laravel). Evaluasi juga belum mencakup aplikasi internal Jurusan Teknologi Informasi (Kompen, Jayanti, Whistleblower) yang menjadi motivasi awal penelitian ini -- perluasan evaluasi pada aplikasi tersebut direncanakan sebagai tahap penelitian lanjutan (lihat BAB V).

== Luaran yang Dicapai <luaran-yang-dicapai>

Status capaian luaran penelitian terhadap target yang ditetapkan pada @tab-luaran-penelitian (BAB I) ditunjukkan pada @tab-luaran-dicapai berikut.

#figure(
  table(
    columns: (0.6cm, 1fr, 3.4cm),
    stroke: 0.5pt,
    align: left + horizon,
    table.header([*No*], [*Jenis Luaran*], [*Status Capaian*]),
    table.cell(colspan: 3, align: left)[*Luaran Wajib*],
    [1], [IPTEKSB berupa _prototipe_ TathyaTest], [Tercapai -- prototipe selesai dibangun dan dievaluasi pada 3 aplikasi studi kasus],
    [2], [Artikel pada jurnal ilmiah (JUTI)], [Manuskrip selesai disusun, #todo("belum disubmit -- perbarui setelah submission")],
    table.cell(colspan: 3, align: left)[*Luaran Tambahan*],
    [3], [Kekayaan Intelektual (KI) berupa Hak Cipta], [#todo("status akhir pendaftaran")],
  ),
  caption: [Status Capaian Luaran Penelitian],
) <tab-luaran-dicapai>
