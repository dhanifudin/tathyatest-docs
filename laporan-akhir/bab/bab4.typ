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
    table.cell(align: left)[Laravel Inertia-React], [48], [24], [34], [*106*],
    table.cell(align: left)[SauceDemo], [18], [4], [9], [*31*],
  ),
  caption: [Jumlah Test Case yang Dihasilkan per Aplikasi dan Tingkat],
) <tab-jumlah-test>

==== Lingkungan Pengujian <lingkungan-pengujian>

Pengujian dilakukan pada tiga aplikasi studi kasus: (1) aplikasi Laravel berbasis Blade (server-rendered), (2) aplikasi Laravel berbasis Inertia-React (SPA), keduanya merupakan aplikasi todo-list dengan kontrol akses berbasis peran (admin dan user) yang dikembangkan sendiri sebagai subjek uji terinstrumentasi (dilengkapi endpoint pengukuran cakupan kode), serta (3) SauceDemo, sebuah aplikasi e-commerce eksternal yang digunakan sebagai pembanding (baseline) untuk menilai generalisasi di luar aplikasi yang dikembangkan sendiri oleh tim peneliti. Pengujian dijalankan pada tiga mesin peramban (Chromium, Firefox, WebKit) sebanyak lima repetisi untuk setiap aplikasi, menggunakan seed faker tetap (42) agar hasil dapat direproduksi.

=== Hasil Pengujian <hasil-pengujian>

@tab-cakupan menunjukkan hasil pengukuran cakupan model (persentase elemen yang berhasil dipetakan dari hasil crawling, terhadap total elemen yang diamati) dan cakupan kode sumber aplikasi (diukur hanya pada kedua aplikasi Laravel, karena SauceDemo merupakan aplikasi eksternal yang tidak dapat diinstrumentasi). Kedua aplikasi Laravel berbagi struktur fitur, peran, dan rute yang sama, namun kedua stack merender antarmukanya secara berbeda -- Inertia-React mengekspos lebih banyak navigasi pada DOM yang telah dirender dibandingkan Blade yang dirender di server -- sehingga cakupan model dan cakupan rute pada tingkat kode sumber antara keduanya tidak lagi identik pada evaluasi ini.

#figure(
  table(
    columns: (1fr, 2.1cm, 2.4cm, 2cm, 1.8cm),
    stroke: 0.5pt,
    align: center + horizon,
    table.header([*Aplikasi*], [*Cakupan Model*], [*Baris Kode*], [*Fungsi*], [*Rute*]),
    table.cell(align: left)[Laravel Blade], [95,5% (42/44)], [36,1% (90/249)], [91,4% (32/35)], [100,0% (8/8)],
    table.cell(align: left)[Laravel Inertia-React], [100,0% (46/46)], [36,1% (97/269)], [86,1% (31/36)], [87,5% (7/8)],
    table.cell(align: left)[SauceDemo], [100,0% (20/20)], [--], [--], [--],
  ),
  caption: [Cakupan Model Elemen dan Cakupan Kode Sumber per Aplikasi],
) <tab-cakupan>

Cakupan model pada @tab-cakupan merangkum elemen, form, field, dan matriks RBAC; dirinci lebih lanjut, cakupan rute pada tingkat model mencapai 100,0% (6/6) pada kedua aplikasi Laravel, sedangkan cakupan navigasi tercatat 89,5% (17/19) pada Blade dan 100,0% (21/21) pada Inertia-React -- pada Blade, dua skenario navigasi dari 19 yang diamati tidak menghasilkan test case, sebuah celah yang belum ditelusuri lebih lanjut penyebabnya, sementara Inertia-React mencapai cakupan navigasi penuh karena sifat SPA-nya mengekspos lebih banyak rute navigasi langsung pada DOM. Cakupan rute pada @tab-cakupan sendiri mengacu pada tingkat kode sumber (SUT), yaitu persentase rute aplikasi yang benar-benar dijangkau saat eksekusi, bukan cakupan rute pada tingkat model; selisihnya pada Inertia-React (87,5%, 7/8) dijelaskan lebih lanjut bersama hasil deteksi cacat di bawah.

=== Hasil Deteksi Cacat <hasil-deteksi-cacat>

Kemampuan deteksi cacat diukur melalui injeksi 18 cacat terkendali pada kedua aplikasi Laravel -- 14 cacat dapat-dideteksi yang tersebar pada lima kelas cacat, ditambah 4 cacat kendali negatif -- mengacu pada Persamaan 3.2 (BAB III). @tab-deteksi-cacat merangkum hasil deteksi per kelas cacat.

#figure(
  table(
    columns: (1.6fr, 1.3cm, 1.3cm),
    stroke: 0.5pt,
    align: center + horizon,
    table.header([*Metrik*], [*Blade*], [*Inertia*]),
    table.cell(align: left)[Cacat validasi terdeteksi], [66,7% (6/9)], [66,7% (6/9)],
    table.cell(align: left)[Cacat otorisasi terdeteksi], [100,0% (2/2)], [100,0% (2/2)],
    table.cell(align: left)[Cacat CRUD terdeteksi], [75,0% (3/4)], [50,0% (2/4)],
    table.cell(align: left)[Cacat paginasi terdeteksi], [100,0% (1/1)], [100,0% (1/1)],
    table.cell(align: left)[Cacat autentikasi terdeteksi], [100,0% (2/2)], [50,0% (1/2)],
    table.cell(align: left)[*Tingkat akurasi (cacat dapat-dideteksi)*], [*100,0% (14/14)*], [*85,7% (12/14)*],
    table.cell(align: left)[Tingkat deteksi seluruh katalog (termasuk kendali)], [77,8% (14/18)], [66,7% (12/18)],
    table.cell(align: left)[Cacat kendali negatif selamat], [4/4], [4/4],
    table.cell(align: left)[Akurasi lokalisasi cacat], [100,0%], [100,0%],
    table.cell(align: left)[Baseline manual (cacat dapat-dideteksi)], [21,4% (3/14)], [21,4% (3/14)],
  ),
  caption: [Hasil Deteksi Cacat per Kelas, Katalog Cacat Terkendali],
) <tab-deteksi-cacat>

Tingkat akurasi -- persentase cacat dapat-dideteksi yang berhasil terdeteksi -- mencapai 100,0% (14/14) pada Blade dan 85,7% (12/14) pada Inertia-React, keduanya memenuhi target minimal 85% pada Persamaan 3.2. Seluruh 4 cacat kendali negatif selamat pada kedua aplikasi tanpa terdeteksi, mengonfirmasi bahwa katalog cacat tidak menghasilkan false positive dan test suite yang dihasilkan tidak over-sensitif terhadap perubahan yang tidak relevan. Dua cacat yang luput dari deteksi pada Inertia-React (`crud-delete-noop` dan `auth-logout-noop`) berasal dari kelas CRUD dan autentikasi, dan keduanya bersumber dari akar masalah yang sama: pada aplikasi SPA ini, logout merupakan kontrol berbasis skrip (script-driven), bukan form HTML yang dapat dijelajahi, sehingga perubahan status yang disembunyikan di baliknya tidak teramati oleh oracle berbasis DOM yang digunakan TathyaTest. Keterbatasan yang sama menjelaskan mengapa cakupan rute pada tingkat kode sumber (SUT) Inertia-React tercatat 87,5% (7/8), lebih rendah dibandingkan Blade yang mencapai 100,0% (8/8), karena rute logout pada Inertia-React tidak pernah dijangkau oleh crawler. Baseline manual hanya mendeteksi 21,4% (3/14) cacat dapat-dideteksi pada kedua aplikasi, jauh di bawah capaian TathyaTest, mengindikasikan bahwa cakupan skenario yang terbatas pada test suite tulisan manual turut membatasi kemampuan deteksi cacatnya.

@tab-kualitas menunjukkan hasil pengukuran kualitas intrinsik test suite yang dihasilkan TathyaTest dibandingkan dengan baseline (test suite manual untuk kedua aplikasi Laravel; gabungan tiga test suite publik independen untuk SauceDemo).

#figure(
  table(
    columns: (1fr, 2.6cm, 2.6cm, 2.2cm),
    stroke: 0.5pt,
    align: center + horizon,
    table.header([*Aplikasi*], [*Densitas Asersi \ (Generate/Baseline)*], [*Rasio Locator Rapuh \ (Generate/Baseline)*], [*Ketahanan Locator*]),
    table.cell(align: left)[Laravel Blade], [1,20 / 1,00], [4,7% / 0,0%], [72,4%],
    table.cell(align: left)[Laravel Inertia-React], [1,22 / 1,00], [2,3% / 0,0%], [74,4%],
    table.cell(align: left)[SauceDemo], [1,16 / 1,34], [0,0% / 62,5%], [85,7%],
  ),
  caption: [Kualitas Intrinsik Test Suite: Densitas Asersi, Rasio Locator Rapuh, dan Ketahanan Locator],
) <tab-kualitas>

Menariknya, pada kedua aplikasi Laravel rasio locator rapuh test suite hasil generate (4,7% pada Blade, 2,3% pada Inertia-React) justru lebih tinggi daripada baseline manual (0,0% pada keduanya) -- baseline manual yang ditulis khusus untuk kedua aplikasi ini secara konsisten memakai locator bernama (`name`) yang stabil, sementara TathyaTest sesekali jatuh ke fallback locator berbasis CSS saat elemen tidak memiliki atribut semantik yang memadai, dengan proporsi fallback yang sedikit lebih rendah pada Inertia-React karena struktur DOM React menyediakan lebih banyak atribut semantik yang dapat dikenali locator. Pola sebaliknya justru terlihat pada SauceDemo: rasio locator rapuh test suite hasil generate TathyaTest tercatat 0,0%, jauh lebih rendah dibandingkan 62,5% pada gabungan tiga test suite publik independen yang digunakan sebagai pembanding -- menunjukkan bahwa keunggulan locator TathyaTest paling terasa ketika dibandingkan dengan test suite yang ditulis oleh pihak ketiga tanpa akses pada aturan prioritas locator yang sama.

@tab-keandalan menunjukkan hasil pengukuran keandalan dan efisiensi eksekusi.

#figure(
  table(
    columns: (0.9fr, 1.5cm, 1.5cm, 1.2cm, 2.3cm, 2.3cm),
    stroke: 0.5pt,
    align: center + horizon,
    table.header([*Aplikasi*], [*Flake Rate*], [*Pass Rate*], [κ], [*Waktu Eksekusi*], [*Penghematan Waktu*]),
    table.cell(align: left)[Laravel Blade], [0,0%], [100,0%], [1,00], [919 s ± 13 s], [32,7×],
    table.cell(align: left)[Laravel Inertia-React], [0,0%], [100,0%], [1,00], [948 s ± 14 s], [32,3×],
    table.cell(align: left)[SauceDemo], [0,0%], [96,2%], [1,00], [291 s ± 23 s], [30,0×],
  ),
  caption: [Keandalan dan Efisiensi Eksekusi per Aplikasi],
) <tab-keandalan>

Kesepakatan hasil pengujian antar-browser (diukur dengan Fleiss' kappa) mencapai κ = 1,00 pada ketiga aplikasi, menunjukkan hasil yang sangat konsisten lintas Chromium, Firefox, dan WebKit pada setiap repetisi, dengan flake rate 0,0% pada ketiganya. Pengujian statistik Mann-Whitney U terhadap durasi eksekusi test case yang dihasilkan dibandingkan baseline manual menunjukkan perbedaan yang signifikan secara statistik pada ketiga aplikasi (p < 0,001).

*Cacat nyata yang ditemukan.* Selain angka cakupan dan kualitas di atas, pelaksanaan pengujian turut menyingkap dua cacat nyata pada aplikasi studi kasus, menunjukkan bahwa test case yang dihasilkan mampu menemukan masalah yang sungguh-sungguh ada. Pertama, komponen paginator bawaan Laravel (Tailwind) meng-escape tanda panah pada nama aksesibel tautannya ("Next &amp;raquo;"), sehingga label yang tampak berbeda dengan nama aksesibelnya; penjaga visibilitas runtime pada test case yang dihasilkan mengungkap bahwa crawling sebelumnya diam-diam melewatkan skenario "halaman berikutnya" akibat ketidaksesuaian ini. Kedua, deklarasi `Route::resource('todos')` pada kedua aplikasi Laravel ternyata menyertakan rute `show` (`GET /todos/{id}`) tanpa aksi controller di baliknya, sehingga rute tersebut mengembalikan HTTP 500; cacat ini ditemukan melalui pemeriksaan rute tersirat (inferred-route check) pada generator, dan telah diperbaiki dengan mengecualikan rute `show` pada kedua aplikasi -- perbaikan inilah yang menaikkan cakupan rute Blade pada @tab-cakupan dari 87,5% menjadi 100,0%. Pada Inertia-React, cakupan rute tetap tercatat 87,5% setelah perbaikan ini, karena rute logout yang berbasis skrip pada stack tersebut tidak pernah dijangkau oleh crawler, sebagaimana dibahas lebih lanjut pada hasil deteksi cacat berikut.

Contoh eksekusi Playwright dan tampilan laporan hasil pengujian ditunjukkan pada Lampiran H.

== Pembahasan <pembahasan>

Dibandingkan dengan target yang ditetapkan pada BAB III (Persamaan 3.1: minimal 80% test coverage), hasil evaluasi menunjukkan capaian yang perlu dimaknai secara berlapis karena terdapat dua jenis "cakupan" yang berbeda maknanya. *Cakupan model* -- persentase elemen, rute, form, field, navigasi, dan matriks RBAC yang berhasil diidentifikasi dan dipetakan oleh TathyaTest dari hasil crawling -- mencapai 95,5% (elemen) pada Blade dan 100,0% (elemen) pada Inertia-React, serta 100,0% pada rute, form, field, dan matriks RBAC di kedua aplikasi, melampaui target 80% pada ketiga aplikasi. Satu celah tersisa pada cakupan navigasi Blade (89,5%, 17 dari 19 skenario, belum ditelusuri lebih lanjut penyebabnya), sementara Inertia-React mencapai cakupan navigasi penuh (100,0%, 21/21) -- perbedaan yang konsisten dengan sifat SPA yang mengekspos lebih banyak skenario navigasi pada DOM yang telah dirender dibandingkan aplikasi server-rendered. Namun demikian, cakupan ini mengukur kelengkapan terhadap model yang dibangun TathyaTest sendiri ("completeness by construction"), bukan cakupan baris kode sumber aplikasi secara keseluruhan. *Cakupan baris kode* (line coverage) yang diukur langsung dari instrumentasi PCOV pada aplikasi Laravel tercatat jauh lebih rendah, yaitu 36,1% pada Blade (90/249 baris) dan 36,1% pada Inertia-React (97/269 baris) -- proporsi yang sama meski jumlah baris kode berbeda, karena kedua aplikasi berbagi struktur fitur yang identik. Hal ini merupakan konsekuensi wajar dari desain TathyaTest yang berfokus pada pengujian fungsional berbasis antarmuka pengguna (UI-level black-box testing) dan hanya menjangkau elemen yang tampak pada DOM -- logika di balik antarmuka yang tidak termanifestasi sebagai elemen DOM yang dapat berinteraksi, seperti validasi kustom pada sisi server, tidak dapat terdeteksi melalui pendekatan ini. Sebagai indikator yang lebih relevan dengan tujuan pengujian fungsional, cakupan rute pada tingkat kode sumber (SUT) tercatat 100,0% (8/8) pada Blade -- naik dari 87,5% pada evaluasi sebelumnya, setelah cacat rute `show` yang tidak memiliki aksi controller (dibahas di atas) diperbaiki -- namun tetap 87,5% (7/8) pada Inertia-React, karena rute logout yang berbasis skrip pada stack ini tidak pernah dijangkau oleh crawler.

Terhadap target akurasi pada BAB III (Persamaan 3.2: minimal 85%, dihitung dari proporsi cacat dapat-dideteksi yang berhasil terdeteksi), hasil evaluasi menunjukkan TathyaTest memenuhi target pada kedua aplikasi Laravel: 100,0% (14/14) pada Blade dan 85,7% (12/14) pada Inertia-React. Seluruh 4 cacat kendali negatif pada katalog selamat tanpa terdeteksi pada kedua aplikasi, mengonfirmasi bahwa katalog cacat yang disusun tim peneliti tidak menghasilkan false positive dan test suite yang dihasilkan tidak over-sensitif terhadap perubahan yang tidak relevan -- sebuah pemeriksaan validitas yang secara langsung mengurangi risiko efek plafon (ceiling effect) dan bias katalog yang melekat pada katalog cacat buatan sendiri. Dua cacat yang luput dari deteksi pada Inertia-React bersumber dari keterbatasan oracle berbasis DOM terhadap kontrol berbasis skrip pada aplikasi SPA, sebagaimana dibahas pada bagian hasil pengujian di atas. Baseline manual hanya mendeteksi 21,4% (3/14) cacat dapat-dideteksi pada kedua aplikasi, jauh di bawah target maupun capaian TathyaTest, mengindikasikan bahwa cakupan skenario yang terbatas pada test suite tulisan manual turut membatasi kemampuan deteksi cacatnya.

Dari sisi efisiensi, waktu eksekusi penuh test suite yang dihasilkan (919 detik untuk Blade, 948 detik untuk Inertia-React, 291 detik untuk SauceDemo) menghasilkan estimasi penghematan waktu sekitar 30,0--32,7 kali dibandingkan estimasi biaya penulisan test case secara manual, dengan signifikansi statistik yang kuat (Mann-Whitney U, p < 0,001 pada ketiga aplikasi). Rasio locator rapuh yang jauh lebih rendah pada test case hasil generate TathyaTest dibandingkan test suite publik pembanding (0,0% berbanding 62,5% pada SauceDemo) turut mengindikasikan bahwa test case yang dihasilkan secara otomatis berpotensi lebih tahan terhadap perubahan kecil pada antarmuka aplikasi dibandingkan test suite pihak ketiga yang ditulis tanpa strategi locator yang konsisten.

Beberapa keterbatasan perlu dicatat: evaluasi hanya mencakup elemen yang tampak pada DOM (tidak menjangkau logika tersembunyi seperti aturan validasi kustom pada FormRequest Laravel, termasuk kontrol berbasis skrip pada aplikasi SPA sebagaimana terlihat pada dua cacat yang luput terdeteksi di Inertia-React), cakupan kode menggunakan proksi cabang (branch-proxy) alih-alih instrumentasi cabang penuh, katalog cacat untuk pengukuran accuracy rate disusun sendiri oleh tim peneliti alih-alih dihasilkan oleh perangkat mutation testing otomatis sehingga cakupan kelas cacatnya terbatas pada lima kelas yang teridentifikasi dari permukaan fungsional (meskipun telah diseimbangkan dengan cacat kendali negatif), dan baseline manual pembanding berjumlah relatif kecil (5 test case per aplikasi Laravel). Evaluasi juga belum mencakup aplikasi internal Jurusan Teknologi Informasi (Kompen, Jayanti, Whistleblower) yang menjadi motivasi awal penelitian ini -- perluasan evaluasi pada aplikasi tersebut direncanakan sebagai tahap penelitian lanjutan (lihat BAB V).

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
    [2], [Artikel pada jurnal ilmiah (JUTI)], [Manuskrip telah disubmit (13 Oktober 2026)],
    table.cell(colspan: 3, align: left)[*Luaran Tambahan*],
    [3], [Kekayaan Intelektual (KI) berupa Hak Cipta], [Dalam proses pendaftaran],
  ),
  caption: [Status Capaian Luaran Penelitian],
) <tab-luaran-dicapai>
