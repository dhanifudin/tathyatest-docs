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

Ekstraksi elemen dilakukan langsung pada konteks browser menggunakan skrip evaluasi DOM (`page.evaluate()`) yang dijalankan oleh Playwright, bukan melalui pustaka parser HTML statis seperti Goquery yang diusulkan pada rancangan awal. Pendekatan ini mengidentifikasi form (termasuk klasifikasi operasi CRUD), field input berikut batasan validasinya (required, minlength, maxlength, pattern, dan sejenisnya), tautan, tombol (termasuk elemen dengan peran ARIA seperti `role="button"`), dan tabel. Sebuah proses tambahan menggunakan `ariaSnapshot()` meningkatkan kualitas locator yang lemah (berbasis CSS atau nama elemen) menjadi locator berbasis peran (role locator) yang lebih tahan terhadap perubahan struktur halaman.

Klasifikasi operasi CRUD pada awalnya hanya mengenali atribut method tersembunyi `_method` khas Laravel (PUT/PATCH untuk update, DELETE untuk delete). Implementasi kemudian digeneralisasi menjadi deteksi berbasis urutan prioritas yang tidak terikat pada satu framework tertentu -- mencakup juga pola method-spoofing pada Rails/Symfony/Spring, verb Turbo/HTMX, serta heuristik kata kunci pada path aksi dan teks tombol submit -- sehingga TathyaTest dapat digunakan pada aplikasi berbasis framework web lain di luar Laravel tanpa perubahan pada logika inti generator.

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

Oracle (penentu hasil uji) memvalidasi kemunculan elemen galat yang sesuai (misalnya `.invalid-feedback` atau `[role=alert]`) tanpa bergantung pada kecocokan teks pesan kesalahan secara persis, agar lebih tahan terhadap perubahan redaksi pesan. Kode test case yang dihasilkan menggunakan judul deskriptif yang mencerminkan skenario pengujian (misalnya `admin · /todos/create · form "Create" → POST /todos · title menolak nilai kosong`), berbagi satu modul pendukung (`support/tathya.ts`) untuk fungsi login dan fixture per peran/aplikasi, serta disusun dalam tahapan (`test.step`) dan ditandai dengan tag tingkat (`@tier`), kategori (`@category`), dan peran (`@role`) agar lebih mudah dibaca dan dipelihara dibandingkan kode hasil generate pada implementasi awal.

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
    table.cell(align: left)[Laravel Blade], [46], [24], [34], [*104*],
    table.cell(align: left)[Laravel Inertia-React], [46], [24], [34], [*104*],
    table.cell(align: left)[SauceDemo], [18], [4], [9], [*31*],
  ),
  caption: [Jumlah Test Case yang Dihasilkan per Aplikasi dan Tingkat],
) <tab-jumlah-test>

==== Lingkungan Pengujian <lingkungan-pengujian>

Pengujian dilakukan pada tiga aplikasi studi kasus: (1) aplikasi Laravel berbasis Blade (server-rendered), (2) aplikasi Laravel berbasis Inertia-React (SPA), keduanya merupakan aplikasi todo-list dengan kontrol akses berbasis peran (admin dan user) yang dikembangkan sendiri sebagai subjek uji terinstrumentasi (dilengkapi endpoint pengukuran cakupan kode), serta (3) SauceDemo, sebuah aplikasi e-commerce eksternal yang digunakan sebagai pembanding (baseline) untuk menilai generalisasi di luar aplikasi yang dikembangkan sendiri oleh tim peneliti. Pengujian dijalankan pada tiga mesin peramban (Chromium, Firefox, WebKit) sebanyak lima repetisi untuk setiap aplikasi, menggunakan seed faker tetap (42) agar hasil dapat direproduksi.

=== Hasil Pengujian <hasil-pengujian>

@tab-cakupan menunjukkan hasil pengukuran cakupan model (persentase elemen yang berhasil dipetakan dari hasil crawling, terhadap total elemen yang diamati) dan cakupan kode sumber aplikasi (diukur hanya pada kedua aplikasi Laravel, karena SauceDemo merupakan aplikasi eksternal yang tidak dapat diinstrumentasi). Kedua aplikasi Laravel mencatat angka yang identik pada seluruh metrik cakupan, karena keduanya berbagi struktur fitur, peran, dan rute yang sama dan diuji dengan metodologi yang sama persis.

#figure(
  table(
    columns: (1fr, 2.1cm, 2.4cm, 2cm, 1.8cm),
    stroke: 0.5pt,
    align: center + horizon,
    table.header([*Aplikasi*], [*Cakupan Model*], [*Baris Kode*], [*Fungsi*], [*Rute*]),
    table.cell(align: left)[Laravel Blade], [95,5% (42/44)], [23,6% (104/441)], [71,9% (41/57)], [100,0% (8/8)],
    table.cell(align: left)[Laravel Inertia-React], [95,5% (42/44)], [23,6% (104/441)], [71,9% (41/57)], [100,0% (8/8)],
    table.cell(align: left)[SauceDemo], [100,0% (20/20)], [--], [--], [--],
  ),
  caption: [Cakupan Model Elemen dan Cakupan Kode Sumber per Aplikasi],
) <tab-cakupan>

Cakupan model pada @tab-cakupan merangkum elemen, form, field, dan matriks RBAC; dirinci lebih lanjut, cakupan rute pada tingkat model mencapai 100,0% (6/6) dan cakupan navigasi 89,5% (17/19) pada kedua aplikasi Laravel -- dua skenario navigasi dari 19 yang diamati tidak menghasilkan test case, sebuah celah yang belum ditelusuri lebih lanjut penyebabnya. Cakupan rute pada @tab-cakupan sendiri mengacu pada tingkat kode sumber (SUT), yaitu persentase rute aplikasi yang benar-benar dijangkau saat eksekusi, bukan cakupan rute pada tingkat model.

@tab-kualitas menunjukkan hasil pengukuran kualitas intrinsik test suite yang dihasilkan TathyaTest dibandingkan dengan baseline (test suite manual untuk kedua aplikasi Laravel; gabungan tiga test suite publik independen untuk SauceDemo).

#figure(
  table(
    columns: (1fr, 2.6cm, 2.6cm, 2.2cm),
    stroke: 0.5pt,
    align: center + horizon,
    table.header([*Aplikasi*], [*Densitas Asersi \ (Generate/Baseline)*], [*Rasio Locator Rapuh \ (Generate/Baseline)*], [*Ketahanan Locator*]),
    table.cell(align: left)[Laravel Blade], [1,20 / 1,00], [4,7% / 0,0%], [72,4%],
    table.cell(align: left)[Laravel Inertia-React], [1,20 / 1,00], [4,7% / 0,0%], [72,4%],
    table.cell(align: left)[SauceDemo], [1,16 / 1,34], [0,0% / 62,5%], [85,7%],
  ),
  caption: [Kualitas Intrinsik Test Suite: Densitas Asersi, Rasio Locator Rapuh, dan Ketahanan Locator],
) <tab-kualitas>

Menariknya, pada kedua aplikasi Laravel rasio locator rapuh test suite hasil generate (4,7%) justru lebih tinggi daripada baseline manual (0,0%) -- baseline manual yang ditulis khusus untuk kedua aplikasi ini secara konsisten memakai locator bernama (`name`) yang stabil, sementara TathyaTest sesekali jatuh ke fallback locator berbasis CSS saat elemen tidak memiliki atribut semantik yang memadai. Pola sebaliknya justru terlihat pada SauceDemo: rasio locator rapuh test suite hasil generate TathyaTest tercatat 0,0%, jauh lebih rendah dibandingkan 62,5% pada gabungan tiga test suite publik independen yang digunakan sebagai pembanding -- menunjukkan bahwa keunggulan locator TathyaTest paling terasa ketika dibandingkan dengan test suite yang ditulis oleh pihak ketiga tanpa akses pada aturan prioritas locator yang sama.

@tab-keandalan menunjukkan hasil pengukuran keandalan dan efisiensi eksekusi.

#figure(
  table(
    columns: (0.9fr, 1.5cm, 1.5cm, 1.2cm, 2.3cm, 2.3cm),
    stroke: 0.5pt,
    align: center + horizon,
    table.header([*Aplikasi*], [*Flake Rate*], [*Pass Rate*], [κ], [*Waktu Eksekusi*], [*Penghematan Waktu*]),
    table.cell(align: left)[Laravel Blade], [0,5%], [99,8%], [1,00], [1188 s ± 206 s], [25,5×],
    table.cell(align: left)[Laravel Inertia-React], [0,2%], [99,9%], [−0,00], [1272 s ± 60 s], [23,9×],
    table.cell(align: left)[SauceDemo], [0,0%], [96,2%], [1,00], [213 s ± 10 s], [42,6×],
  ),
  caption: [Keandalan dan Efisiensi Eksekusi per Aplikasi],
) <tab-keandalan>

Kesepakatan hasil pengujian antar-browser (diukur dengan Fleiss' kappa) mencapai κ = 1,00 pada Blade dan SauceDemo, menunjukkan hasil yang sangat konsisten lintas Chromium, Firefox, dan WebKit. Pada Inertia-React, κ = −0,00, sebuah nilai yang secara teknis mendekati nol namun merupakan artefak dari "paradoks prevalensi" pada statistik kappa ketika hampir seluruh percobaan bernilai sama (pass, dengan pass rate 99,9%), bukan indikasi ketidakkonsistenan yang substantif. Pengujian statistik Mann-Whitney U terhadap durasi eksekusi test case yang dihasilkan dibandingkan baseline manual menunjukkan perbedaan yang signifikan secara statistik pada ketiga aplikasi (p < 0,001).

*Cacat nyata yang ditemukan.* Selain angka cakupan dan kualitas di atas, pelaksanaan pengujian turut menyingkap dua cacat nyata pada aplikasi studi kasus, menunjukkan bahwa test case yang dihasilkan mampu menemukan masalah yang sungguh-sungguh ada. Pertama, komponen paginator bawaan Laravel (Tailwind) meng-escape tanda panah pada nama aksesibel tautannya ("Next &amp;raquo;"), sehingga label yang tampak berbeda dengan nama aksesibelnya; penjaga visibilitas runtime pada test case yang dihasilkan mengungkap bahwa crawling sebelumnya diam-diam melewatkan skenario "halaman berikutnya" akibat ketidaksesuaian ini. Kedua, deklarasi `Route::resource('todos')` pada kedua aplikasi Laravel ternyata menyertakan rute `show` (`GET /todos/{id}`) tanpa aksi controller di baliknya, sehingga rute tersebut mengembalikan HTTP 500; cacat ini ditemukan melalui pemeriksaan rute tersirat (inferred-route check) pada generator, dan telah diperbaiki dengan mengecualikan rute `show` pada kedua aplikasi -- perbaikan inilah yang turut menaikkan cakupan rute pada @tab-cakupan dari 87,5% menjadi 100,0%.

#todo("Tambahkan tangkapan layar (screenshot) contoh eksekusi Playwright dan contoh kode test case yang dihasilkan, jika diperlukan untuk pelengkap laporan.")

== Pembahasan <pembahasan>

Dibandingkan dengan target yang ditetapkan pada BAB III (Persamaan 3.1: minimal 80% test coverage), hasil evaluasi menunjukkan capaian yang perlu dimaknai secara berlapis karena terdapat dua jenis "cakupan" yang berbeda maknanya. *Cakupan model* -- persentase elemen, rute, form, field, navigasi, dan matriks RBAC yang berhasil diidentifikasi dan dipetakan oleh TathyaTest dari hasil crawling -- mencapai 95,5% (elemen) hingga 100,0% (rute, form, field, matriks RBAC) pada ketiga aplikasi, melampaui target 80%, dengan satu celah pada cakupan navigasi (89,5%, 17 dari 19 skenario) yang belum ditelusuri lebih lanjut penyebabnya. Namun demikian, cakupan ini mengukur kelengkapan terhadap model yang dibangun TathyaTest sendiri ("completeness by construction"), bukan cakupan baris kode sumber aplikasi secara keseluruhan. *Cakupan baris kode* (line coverage) yang diukur langsung dari instrumentasi PCOV pada aplikasi Laravel tercatat jauh lebih rendah, yaitu 23,6% pada kedua aplikasi. Hal ini merupakan konsekuensi wajar dari desain TathyaTest yang berfokus pada pengujian fungsional berbasis antarmuka pengguna (UI-level black-box testing) dan hanya menjangkau elemen yang tampak pada DOM -- logika di balik antarmuka yang tidak termanifestasi sebagai elemen DOM yang dapat berinteraksi, seperti validasi kustom pada sisi server, tidak dapat terdeteksi melalui pendekatan ini. Sebagai indikator yang lebih relevan dengan tujuan pengujian fungsional, cakupan rute pada tingkat kode sumber (SUT) tercatat 100,0% (8/8) pada kedua aplikasi Laravel -- naik dari 87,5% pada evaluasi sebelumnya, setelah cacat rute `show` yang tidak memiliki aksi controller (dibahas di atas) diperbaiki.

Rancangan awal penelitian ini (BAB III, Persamaan 3.2) merencanakan pengukuran accuracy rate melalui injeksi cacat sintetis (mutation testing) dengan katalog cacat buatan sendiri. Selama pelaksanaan, pendekatan ini dipertimbangkan ulang: katalog cacat yang disusun sendiri oleh tim peneliti berisiko menghadirkan efek plafon (ceiling effect, karena test case yang dihasilkan memang dirancang untuk menguji kelas skenario yang sama dengan kelas cacat yang disuntikkan) serta bias katalog, sehingga skor mutasi yang tinggi tidak selalu mencerminkan kemampuan deteksi cacat yang sesungguhnya pada kondisi nyata. Sebagai gantinya, validitas kemampuan TathyaTest dalam menemukan penyimpangan fungsional dibuktikan melalui penemuan dua cacat nyata pada aplikasi studi kasus (dibahas di atas) -- cacat yang ditemukan di luar katalog buatan apa pun, sehingga menjadi bukti yang lebih kredibel atas kemampuan validasi fungsional TathyaTest dibandingkan skor mutasi terhadap cacat buatan sendiri. Pengukuran deteksi cacat secara sistematis melalui mutation testing yang lebih representatif tetap menjadi arah pengembangan lanjutan (lihat BAB V).

Dari sisi efisiensi, waktu eksekusi penuh test suite yang dihasilkan (1188 detik untuk Blade, 1272 detik untuk Inertia-React, 213 detik untuk SauceDemo) menghasilkan estimasi penghematan waktu sekitar 23,9--42,6 kali dibandingkan estimasi biaya penulisan test case secara manual, dengan signifikansi statistik yang kuat (Mann-Whitney U, p < 0,001 pada ketiga aplikasi). Rasio locator rapuh yang jauh lebih rendah pada test case hasil generate TathyaTest dibandingkan test suite publik pembanding (0,0% berbanding 62,5% pada SauceDemo) turut mengindikasikan bahwa test case yang dihasilkan secara otomatis berpotensi lebih tahan terhadap perubahan kecil pada antarmuka aplikasi dibandingkan test suite pihak ketiga yang ditulis tanpa strategi locator yang konsisten.

Beberapa keterbatasan perlu dicatat: evaluasi hanya mencakup elemen yang tampak pada DOM (tidak menjangkau logika tersembunyi seperti aturan validasi kustom pada FormRequest Laravel), cakupan kode menggunakan proksi cabang (branch-proxy) alih-alih instrumentasi cabang penuh, evaluasi deteksi cacat secara sistematis (mutation testing) belum dilakukan pada penelitian ini (lihat pembahasan di atas serta BAB V), dan baseline manual pembanding berjumlah relatif kecil (5 test case per aplikasi Laravel). Evaluasi juga belum mencakup aplikasi internal Jurusan Teknologi Informasi (Kompen, Jayanti, Whistleblower) yang menjadi motivasi awal penelitian ini -- perluasan evaluasi pada aplikasi tersebut direncanakan sebagai tahap penelitian lanjutan (lihat BAB V).

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
