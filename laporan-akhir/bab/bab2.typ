= TINJAUAN PUSTAKA <bab-ii-tinjauan-pustaka>

== Penelitian Terdahulu <penelitian-terdahulu>

Pengujian perangkat lunak, khususnya untuk aplikasi berbasis web, merupakan tahapan krusial dalam menjamin kualitas dan keandalan sistem. Automation testing memungkinkan pengujian dilakukan secara berulang tanpa intervensi manusia, sehingga terbukti meningkatkan efisiensi dan menekan risiko kesalahan; penelitian menunjukkan beragam pendekatan, mulai dari crawling-based testing hingga model-based testing, telah dikembangkan untuk meningkatkan efektivitas pengujian aplikasi web @wang2023.

Test case generation otomatis menjadi salah satu pendekatan yang banyak diadopsi, memungkinkan alat pengujian menyusun langkah pengujian secara otomatis berdasarkan elemen-elemen aplikasi sehingga memperluas cakupan pengujian dan mengidentifikasi skenario yang berpotensi terlewat pada pengujian manual @setiani2019. Pemeliharaan test case turut menjadi perhatian penelitian terkini, misalnya melalui pendekatan visual web test repair berbasis computer vision untuk memperbaiki test case yang rusak akibat perubahan antarmuka @stocco2018.

Pada aspek ekstraksi, penggunaan selektor CSS dan XPath terbukti efektif untuk mengambil elemen-elemen penting dari aplikasi berbasis web. Tren terkini dalam web data extraction menunjukkan pergeseran dari metode manual menuju metode otomatis dan intelligent extraction berbasis machine learning, yang meningkatkan akurasi dan adaptabilitas sistem ekstraksi @patnaik2021 -- sebuah arah yang relevan dengan kebutuhan TathyaTest untuk menghasilkan test case yang lebih efisien dan menyeluruh.

Secara keseluruhan, kajian terdahulu menunjukkan bahwa perangkat seperti Selenium, Cypress, dan Playwright efektif dalam meningkatkan efisiensi dan efektivitas pengujian perangkat lunak, sedangkan test case generation otomatis dan ekstraksi elemen HTML menjadi dua pilar teknis yang saling melengkapi. TathyaTest memposisikan diri pada persimpangan kedua pilar tersebut, mengintegrasikan crawling DOM ter-render dan ekstraksi elemen HTML untuk menghasilkan test case otomatis yang memperluas cakupan pengujian secara menyeluruh.

Dari sisi penjaminan mutu, generator test perlu dievaluasi sebagai bagian dari proses pengujian dinamis. Standar ISO/IEC/IEEE 29119 mendefinisikan proses dan teknik pengujian, termasuk teknik berbasis spesifikasi yang relevan untuk menguji perilaku fungsional dari sudut pandang pengguna @iso29119. Masalah oracle tetap menjadi rujukan utama: test yang dihasilkan hanya bernilai bila memiliki mekanisme penilaian hasil yang dapat dipercaya @barr2015oracle. Karena itu evaluasi TathyaTest tidak berhenti pada jumlah test case, tetapi menilai apakah test merepresentasikan fungsi penting, memiliki oracle yang dapat dieksekusi, dan mendukung regresi berulang.

Penelitian tentang regresi web menekankan keseimbangan antara otomasi dan kemudahan pemeliharaan. Abadeh mengusulkan kerangka evolusioner untuk auto-regression testing aplikasi web @abadeh2021webregression, sedangkan studi kematangan test automation menunjukkan bahwa keberhasilan otomasi dipengaruhi oleh kualitas skrip, stabilitas test, dan lingkungan eksekusi @wang2022maturity. Analisis empiris terhadap flaky test pada UI juga menunjukkan bahwa locator dan penantian elemen merupakan sumber ketidakstabilan yang penting @romano2021uiflaky. Temuan ini mendasari pemilihan indikator kualitas artefak pada penelitian ini, yaitu densitas asersi, rasio locator rapuh, dan flake rate.

Dalam kelompok perkakas pembangkit uji berbasis GUI, TathyaTest paling dekat dengan kategori crawler-based generation. Crawljax mengeksplorasi aplikasi Ajax melalui analisis dinamis perubahan state antarmuka dan membangun state-flow graph @mesbah2012crawljax, sedangkan TESTAR menghasilkan aksi uji scriptless dari GUI saat eksekusi tanpa artefak test yang dipelihara @vos2015testar. @tab-banding-perkakas membandingkan kapabilitas yang relevan.

#figure(
  table(
    columns: (1.5fr, 1.2fr, 1.2fr, 1.5fr),
    stroke: 0.5pt,
    align: left + horizon,
    table.header([*Kapabilitas*], [*Crawljax*], [*TESTAR*], [*TathyaTest*]),
    [Sumber model], [Graf transisi state UI], [Eksplorasi GUI saat eksekusi], [DOM terotentikasi per peran],
    [Multi-peran / RBAC], [Tidak], [Tidak], [Ya (matriks akses)],
    [Tier negatif/tepi dari constraint], [Tidak], [Tidak], [Ya],
    [Oracle], [Invarian umum halaman], [Hanya crash atau hang], [Status validasi form dan indikator error DOM],
    [Artefak yang dipelihara], [Model hasil crawl], [Tidak ada], [Spesifikasi Playwright dan manifes],
    [Data uji], [Manual atau plugin], [Aksi acak], [Faker saat runtime (seedable)],
  ),
  caption: [Perbandingan Kapabilitas dengan Perkakas Pembangkit Uji GUI],
) <tab-banding-perkakas>

Posisi penelitian ini terletak pada integrasi pipeline, bukan klaim bahwa satu teknik baru menyelesaikan seluruh masalah pembangkitan test. TathyaTest menggabungkan observasi UI, crawling per peran, pembangkitan variasi data, dan penulisan spesifikasi Playwright dalam satu alur. Efektivitasnya dievaluasi secara empiris pada tiga subjek; generalisasi yang lebih luas memerlukan replikasi lanjutan.

== Kajian Teori <kajian-teori>

Bagian ini menguraikan landasan teori yang mendasari penelitian ini, mencakup pengujian perangkat lunak otomatis, teknik pendukung, serta perangkat yang digunakan, masing-masing dijelaskan dalam kaitannya dengan penerapannya pada TathyaTest.

=== Pengujian Perangkat Lunak <pengujian-perangkat-lunak>

Pengujian perangkat lunak adalah proses yang bertujuan memastikan perangkat lunak berfungsi sesuai spesifikasi yang ditetapkan dan bebas dari kesalahan, baik dalam kondisi operasional normal maupun saat terjadi lonjakan beban pengguna. Software testability -- kemampuan perangkat lunak untuk mendukung pengujiannya sendiri -- menjadi faktor penentu efektivitas proses pengujian @garousi2019testability.

Pada aplikasi berbasis web, pengujian bertujuan memastikan aplikasi dapat beroperasi dengan baik di berbagai platform dan perangkat. Di Jurusan Teknologi Informasi, aplikasi semacam ini banyak digunakan untuk pengelolaan data akademik dan administrasi, sehingga kualitas pengujian menjadi determinan penting bagi fungsionalitas aplikasi secara maksimal. Pengujian yang menyeluruh turut diperlukan untuk mendeteksi kegagalan pada proses CRUD (Create, Read, Update, Delete), autentikasi pengguna, dan akses modul @wang2023.

=== Automation Testing <automation-testing>

Automation testing memungkinkan pengujian perangkat lunak dilakukan tanpa intervensi manusia. Pendekatan ini menawarkan peningkatan efisiensi dan kualitas, namun turut menghadirkan tantangan yang perlu dikelola, seperti kompleksitas implementasi, overhead pemeliharaan, dan integrasi dengan proses pengembangan @solige2025automation. Keunggulan utamanya terletak pada penghematan waktu melalui pengujian berulang tanpa menambah beban kerja, sekaligus mengurangi kesalahan manusia yang umum terjadi pada pengujian manual.

Penelitian ini menerapkan automation testing untuk mengotomatisasi pengujian aplikasi berbasis web yang digunakan mahasiswa dan dosen, menggunakan Playwright yang menurut analisis komparatif terkini unggul dalam waktu eksekusi dan penggunaan resource dibandingkan Cypress dan Selenium @mon2025. Automation testing turut memungkinkan pengujian berskala besar dengan cakupan lebih luas tanpa sumber daya tambahan, yang relevan bagi pengujian aplikasi berbasis web yang kompleks @shah2021.

=== Crawling URL <crawling-url>

Crawling URL adalah teknik untuk menjelajahi halaman aplikasi berbasis web secara otomatis dan mengumpulkan informasi penting dari tiap halaman @mishra2020. Pada aplikasi web modern yang memanfaatkan rendering sisi klien (client-side rendering), seperti single-page application (SPA), struktur DOM yang sesungguhnya baru terbentuk setelah JavaScript dieksekusi oleh browser, sehingga crawler yang hanya membaca HTML mentah dari respons server tidak dapat menjangkau elemen-elemen tersebut @mesbah2012crawljax. Pendekatan crawling berbasis rendering browser (browser-rendered crawling) karenanya diperlukan untuk menjelajahi DOM yang telah ter-render sepenuhnya, termasuk elemen yang dimuat secara dinamis.

Melalui crawling berbasis rendering browser, TathyaTest menavigasi aplikasi web secara otentik -- mengikuti alur navigasi sebagaimana pengguna sesungguhnya -- untuk mengumpulkan data yang diperlukan bagi pembuatan test case otomatis @leotta2021. Proses ini turut memungkinkan crawling ter-otentikasi per peran pengguna (role-based crawling), sehingga elemen dan rute yang hanya dapat diakses oleh peran tertentu dapat terdeteksi tanpa pengaturan manual yang memakan waktu.

=== Ekstraksi Elemen HTML <ekstraksi-elemen-html>

Setelah crawling, tahap berikutnya adalah mengekstrak elemen-elemen HTML yang ditemukan pada setiap halaman. Perkembangan teknik web data extraction, termasuk pendekatan berbasis machine learning, menjadikan proses ekstraksi data dari halaman web lebih efisien dan adaptif @patnaik2021. Dalam penelitian ini, ekstraksi dilakukan langsung pada konteks browser (browser context) menggunakan skrip evaluasi DOM yang dijalankan oleh Playwright, sehingga elemen yang dihasilkan secara dinamis oleh JavaScript turut terjangkau -- berbeda dengan pustaka parser HTML statis yang hanya membaca markup mentah dari respons server.

Ekstraksi elemen HTML memungkinkan TathyaTest mengidentifikasi elemen yang dapat diuji, seperti elemen interaktif untuk input data maupun navigasi pengguna @romano2022, sebagai dasar pembuatan test case otomatis bagi masing-masing elemen. Proses ini memastikan cakupan pengujian mencakup seluruh elemen aplikasi, baik yang tampak maupun yang tersembunyi.

=== Playwright <playwright>

Playwright adalah alat pengujian otomatis berbasis JavaScript yang dirancang untuk pengujian aplikasi web end-to-end. Studi komparatif terkini menunjukkan bahwa Playwright unggul dalam performa dibandingkan Cypress dan Selenium, khususnya pada waktu eksekusi, penggunaan CPU, dan konsumsi RAM @mon2025. Keunggulan lainnya adalah kemampuan cross-browser testing yang memungkinkan pengujian dilakukan secara konsisten pada Chrome, Firefox, dan WebKit.

Penelitian ini memanfaatkan Playwright pada dua tahap: sebagai mesin crawling untuk menjelajahi DOM ter-render aplikasi secara terotentikasi per peran pengguna, dan untuk mengeksekusi test case otomatis yang dihasilkan TathyaTest, mengadopsi pendekatan pada @sahoo2021. Kemampuan Playwright mengontrol browser secara langsung memungkinkan interaksi dengan elemen aplikasi dan verifikasi fungsionalitasnya secara menyeluruh dengan akurasi tinggi.

=== Black-Box Testing dan Teknik Desain Test Case <black-box-testing>

Black-box testing menguji perilaku aplikasi dari sudut pandang pengguna tanpa merujuk struktur kode internal. Teknik desain test case yang lazim pada pendekatan ini adalah equivalence partitioning, yang membagi domain input menjadi kelas yang diperkirakan diperlakukan sama oleh aplikasi, dan boundary value analysis, yang menguji nilai di sekitar batas kelas karena kesalahan cenderung terjadi di sana @iso29119. Kedua teknik ini menjadi dasar pembagian test case TathyaTest ke dalam tiga tingkat: positif (nilai valid), negatif (nilai yang harus ditolak, misalnya kolom wajib kosong atau format salah), dan tepi (nilai pada batas panjang atau rentang).

Karena TathyaTest hanya mengamati DOM, pengujian yang dihasilkan bersifat black-box tingkat antarmuka. Konsekuensinya, aturan bisnis yang tidak termanifestasi pada DOM tidak terjangkau; hal ini dibahas sebagai keterbatasan pada BAB IV.

=== Strategi Locator dan Ketahanan Test <strategi-locator>

Locator adalah ekspresi yang digunakan test untuk menemukan elemen pada halaman. Locator yang bergantung pada struktur DOM atau kelas CSS mudah rusak ketika tampilan berubah, sedangkan locator yang bertumpu pada atribut semantik, seperti peran ARIA, label, atau atribut `name`, lebih stabil. Ketidakstabilan locator termasuk penyebab utama flaky test pada pengujian UI @romano2021uiflaky, dan pemeliharaan test yang rusak akibat perubahan antarmuka menjadi biaya besar pada automation testing @stocco2018.

TathyaTest menerapkan rantai prioritas locator: atribut semantik terlebih dahulu, kemudian atribut identitas elemen, dan selector CSS hanya sebagai cadangan terakhir. Locator yang jatuh ke cadangan CSS dihitung sebagai locator rapuh, dan proporsinya dilaporkan sebagai rasio locator rapuh.

=== Role-Based Access Control (RBAC) <rbac-teori>

RBAC menempatkan peran sebagai perantara antara pengguna dan hak akses (permission), sehingga pengelolaan hak tidak melekat langsung pada individu @ferraiolo1992rbac @sandhu1996rbac. Pada aplikasi web, RBAC tampak sebagai perbedaan menu, rute, dan aksi yang tersedia bagi tiap peran. Pengujian RBAC karenanya harus mengamati aplikasi dari beberapa peran dan membandingkan hasilnya: rute yang terlihat bagi admin tetapi tidak bagi user menjadi kandidat uji bahwa user memang tidak dapat mengaksesnya.

Prinsip ini mendasari crawling per peran pada TathyaTest. Matriks akses diturunkan dari selisih hasil crawl antarperan, sehingga tester tidak perlu mendeklarasikan seluruh permission secara manual.

=== Metrik Kualitas Test Suite <metrik-kualitas>

Kualitas test suite dinilai melalui beberapa kelompok metrik. _Cakupan_ menunjukkan seberapa besar permukaan aplikasi yang dijangkau, baik terhadap model elemen maupun terhadap kode sumber. _Kemampuan deteksi cacat_ diukur melalui injeksi cacat terkendali, mengikuti gagasan mutation testing @jia2011mutation, yaitu menyuntikkan perubahan kecil dan memeriksa apakah test gagal. _Densitas asersi_ adalah rerata jumlah asersi per test case, sedangkan _rasio locator rapuh_ adalah proporsi locator yang bertumpu pada selector CSS cadangan. _Flake rate_ adalah proporsi test yang hasilnya berubah pada eksekusi ulang tanpa perubahan aplikasi.

Kesepakatan hasil antarbrowser diukur dengan Fleiss' kappa (κ) @fleiss1971kappa, di mana κ = 1 berarti kesepakatan penuh. Perbedaan durasi eksekusi diuji dengan uji Mann-Whitney U @mann1947whitney, uji nonparametrik yang tidak mensyaratkan distribusi normal.

=== Kerangka Konsep <kerangka-konsep>

Kajian di atas dirangkum dalam kerangka konsep berikut. Crawling berbasis rendering browser menghasilkan model DOM per peran; model tersebut diturunkan menjadi test case bertingkat (positif, negatif, tepi) melalui teknik desain black-box; test dieksekusi pada tiga mesin browser dengan Playwright; dan kualitas hasilnya dinilai dengan metrik cakupan, deteksi cacat, kualitas intrinsik, keandalan, dan efisiensi. Setiap tahap kerangka ini memiliki padanan pada rancangan metode di BAB III dan pada hasil evaluasi di BAB IV.

== Roadmap Penelitian <roadmap-penelitian>

Pengembangan penelitian TathyaTest dirancang secara berkelanjutan selama lima tahun untuk memperkuat kontribusi keilmuan di bidang pengujian perangkat lunak otomatis, khususnya pada aplikasi berbasis web. Roadmap ini menggambarkan arah riset strategis yang saling berkelanjutan dan berjenjang sebagai berikut:

// Container is top-anchored; a larger lead-in `v()` for earlier steps pushes
// that box further down, producing an ascending staircase left-to-right.
#let roadmap-step(year, title, sub, fill, step, text-color: black) = box(width: 100%, height: 5.8cm)[
  #v((4 - step) * 0.9cm)
  #align(center)[
    #block(
      width: 92%,
      inset: 8pt,
      radius: 5pt,
      stroke: 1.2pt,
      fill: fill,
    )[
      #set text(fill: text-color)
      #align(center)[
        #text(size: 13pt, weight: "bold")[#year] \
        #text(size: 10.5pt, weight: "bold")[#title] \
        #text(size: 8.5pt)[#sub]
      ]
    ]
  ]
]

#figure(
  grid(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr),
    column-gutter: 4pt,
    roadmap-step("2025", "Pondasi Arsitektur", "Clean Architecture", rgb("#c8e6ff"), 0),
    roadmap-step("2026", "TathyaTest", "Pengujian Fungsional", rgb("#96c8ff"), 1),
    roadmap-step("2027", "Pengujian", "Non-Fungsional", rgb("#64aaff"), 2),
    roadmap-step("2028", "AI Integration", "Test Prioritization", rgb("#328cff"), 3),
    roadmap-step("2029", "Adaptive", [Generation & CI/CD], rgb("#006edc"), 4, text-color: white),
  ),
  caption: [Roadmap Penelitian TathyaTest 2025-2029],
) <fig-roadmap>

*2025 -- Pondasi Arsitektur: Clean Architecture sebagai Landasan Pengujian*

Pada tahun pertama, penelitian telah difokuskan pada pengembangan arsitektur perangkat lunak yang bersih dan terstruktur sebagai landasan untuk sistem pengujian ke depan. Penelitian tentang implementasi Clean Architecture pada aplikasi web telah dipublikasikan dan menjadi pondasi penting untuk membangun sistem pengujian yang efektif @rifai2025clean. Arsitektur yang terstruktur dengan baik memungkinkan identifikasi komponen dan alur pengujian yang lebih jelas, yang menjadi dasar pengembangan TathyaTest.

*2026 -- Implementasi TathyaTest untuk Pengujian Fungsional*

Pada tahun kedua, penelitian ini berfokus pada implementasi TathyaTest sebagai alat test case generator otomatis untuk pengujian fungsional aplikasi berbasis web. Dengan memanfaatkan pondasi Clean Architecture dari tahun sebelumnya, TathyaTest dikembangkan untuk mengidentifikasi elemen-elemen aplikasi dan menghasilkan test case otomatis menggunakan crawling DOM ter-render dan ekstraksi elemen berbasis Playwright. Pengujian fungsional mencakup operasi CRUD, autentikasi pengguna, dan akses modul berbasis peran (RBAC), dengan integrasi Playwright untuk cross-browser testing pada Chrome, Firefox, dan WebKit.

*2027 -- Pengujian Non-Fungsional untuk TathyaTest*

Pada tahun ketiga, fokus penelitian akan berkembang dari pengujian fungsional ke pengujian non-fungsional. TathyaTest akan diperluas untuk dapat menghasilkan test case yang menguji aspek non-fungsional aplikasi, termasuk performance testing untuk mengukur kinerja dan response time, security testing untuk mengidentifikasi kerentanan keamanan, dan load testing untuk mengevaluasi kemampuan aplikasi menangani beban pengguna yang tinggi. Penelitian ini akan mengeksplorasi teknik-teknik otomatis untuk menghasilkan test case non-fungsional yang relevan berdasarkan karakteristik aplikasi.

*2028 -- Integrasi AI untuk Test Case Prioritization dan Risk Analysis*

Pada tahun keempat, penelitian akan mengintegrasikan kecerdasan buatan (AI) dalam TathyaTest untuk test case prioritization dan risk analysis. Teknik machine learning akan digunakan untuk menganalisis historical test data dan code changes, kemudian memprioritaskan test case berdasarkan tingkat risiko dan probabilitas bug. Penelitian ini akan mengeksplorasi algoritma classification dan regression untuk memprediksi area aplikasi yang rawan bug, sehingga dapat mengoptimalkan urutan eksekusi test case dan mengurangi waktu pengujian dengan tetap mempertahankan cakupan yang efektif.

*2029 -- Adaptive Test Generation dan Integrasi CI/CD*

Pada tahun kelima, penelitian akan mengembangkan adaptive test generation yang dapat belajar dari hasil pengujian sebelumnya dan menyesuaikan strategi pengujian secara otomatis. Machine learning akan digunakan untuk mengidentifikasi pola kegagalan pengujian dan secara dinamis menghasilkan test case baru untuk area yang belum tercakup. Penelitian ini juga akan mengintegrasikan TathyaTest dengan sistem CI/CD (Continuous Integration/Continuous Deployment) untuk memungkinkan pengujian otomatis berkelanjutan yang cerdas dalam siklus pengembangan perangkat lunak, dengan kemampuan self-healing test yang dapat memperbaiki test case yang rusak akibat perubahan aplikasi.
