= PENDAHULUAN <bab-i-pendahuluan>

== Latar Belakang <latar-belakang>

Aplikasi berbasis web merupakan infrastruktur inti penyelenggaraan kegiatan akademik dan administrasi di perguruan tinggi, mencakup sistem manajemen akademik, pengelolaan keuangan, hingga pelaporan data. Di Jurusan Teknologi Informasi, aplikasi seperti Kompen, Jayanti, dan Whistleblower digunakan secara rutin oleh mahasiswa, dosen, dan staf untuk kegiatan yang krusial, sehingga menjadi motivasi awal penelitian ini. Tantangan yang melatarbelakangi penelitian ini, bagaimanapun, berlaku umum bagi setiap aplikasi web dengan kontrol akses berbasis peran (role-based access control/RBAC) @sandhu1996rbac: memastikan aplikasi tersebut berfungsi dengan baik dan senantiasa tersedia tanpa gangguan, tanpa bergantung pada pengujian manual yang memakan waktu.

Gangguan ketersediaan maupun kesalahan fungsionalitas dapat menurunkan kualitas layanan dan pengalaman pengguna. Pemantauan ketersediaan server secara konvensional, misalnya melalui status HTTP 200, tidak dapat memastikan bahwa fungsi inti aplikasi -- proses login, penegakan RBAC, validasi input, maupun operasi CRUD -- berjalan sebagaimana mestinya; sebuah aplikasi dapat "tersedia" secara jaringan namun gagal secara fungsional. Oleh karena itu, aplikasi berbasis web di Jurusan Teknologi Informasi perlu diuji secara fungsional dan berkala agar senantiasa berfungsi sesuai harapan.

Automation testing merupakan salah satu pendekatan paling efektif untuk menjaga kualitas perangkat lunak, menawarkan penghematan waktu, pengurangan kesalahan manusia, dan kemampuan pengujian berulang tanpa menambah biaya secara berarti @solige2025automation. Studi pemetaan sistematik menunjukkan bahwa automated testing untuk aplikasi web terus berkembang dengan beragam pendekatan dan teknik @wang2023. Meskipun demikian, perangkat automation testing seperti Selenium, Cypress, dan Playwright tetap menghadapi tantangan mendasar: pembuatan test case yang relevan dengan fungsionalitas aplikasi masih sebagian besar bergantung pada definisi skenario secara manual, yang menambah beban dan waktu pengujian. Rendahnya software testability pada banyak aplikasi web turut memperberat tantangan ini @garousi2019testability, sementara sejumlah penelitian menekankan bahwa otomatisasi test case generation dapat secara signifikan mengurangi upaya manual dan memperluas cakupan pengujian @leotta2021 @romano2022. Kesenjangan inilah yang mendasari kebutuhan terhadap solusi test case generation otomatis yang efisien dan menyeluruh.

Penelitian ini mengusulkan TathyaTest sebagai solusi atas kesenjangan tersebut. TathyaTest menghasilkan test case otomatis dengan melakukan crawling pada DOM (Document Object Model) aplikasi yang telah dirender oleh browser menggunakan Playwright, sehingga mampu menjangkau aplikasi modern berbasis single-page application (SPA) sekalipun. Dari hasil crawling tersebut, TathyaTest membangun model elemen dan matriks akses per peran pengguna (RBAC) secara otomatis, lalu memetakannya menjadi test case fungsional yang relevan dan kontekstual untuk pengujian yang lebih cepat dan komprehensif. Pendekatan ini konsisten dengan kajian literatur mengenai test case generation yang terbukti mempercepat identifikasi bug dan memperluas cakupan pengujian @setiani2019 @sahoo2021, serta sejalan dengan bukti empiris bahwa automation testing skala industri -- seperti penerapan search-based software engineering pada Sapienz di Facebook -- memberikan nilai praktis yang signifikan dalam lingkungan produksi @alshahwan2018.

Dengan TathyaTest, proses pengujian aplikasi berbasis web dapat dilakukan secara lebih efisien, mengurangi ketergantungan pada pengujian manual yang memakan waktu dan sering kali tidak lengkap, khususnya pada aplikasi yang digunakan mahasiswa dan dosen di Jurusan Teknologi Informasi. Penelitian ini diharapkan memberikan kontribusi bagi peningkatan kualitas aplikasi berbasis web di perguruan tinggi sekaligus menjadi fondasi pengembangan alat pengujian perangkat lunak otomatis selanjutnya.

== Rumusan Masalah <rumusan-masalah>

+ Sejauh mana test suite yang dihasilkan TathyaTest dari observasi DOM ter-render secara terotentikasi mencakup permukaan fungsional aplikasi berbasis web -- baik pada tingkat model elemen (form, field, navigasi, matriks RBAC) maupun pada tingkat kode sumber aplikasi (system under test, SUT)?
+ Bagaimana kualitas intrinsik, keandalan, dan efisiensi test suite yang dihasilkan TathyaTest dibandingkan dengan test suite tulisan manual dan test suite publik independen?

== Batasan Masalah <batasan-masalah>

Untuk memfokuskan penelitian dan memastikan hasil yang optimal, batasan masalah dalam penelitian ini meliputi:

+ Penelitian ini terbatas pada aplikasi berbasis web dengan arsitektur MVC (Model-View-Controller).
+ Pengujian difokuskan pada fungsionalitas aplikasi yang mencakup operasi CRUD (Create, Read, Update, Delete), autentikasi pengguna, dan akses modul.
+ Fitur halaman login tidak menerapkan mekanisme CAPTCHA atau autentikasi multi-faktor (MFA) yang dapat menghambat proses otomatisasi pengujian.
+ Evaluasi dilakukan pada aplikasi studi kasus dengan arsitektur MVC dan RBAC (aplikasi Laravel berbasis Blade dan aplikasi Laravel berbasis Inertia-React) serta satu aplikasi eksternal (SauceDemo) sebagai pembanding (baseline); perluasan pengujian pada aplikasi internal Jurusan Teknologi Informasi (Kompen, Jayanti, Whistleblower) direncanakan sebagai tahap penelitian lanjutan.
+ TathyaTest hanya menghasilkan test case untuk pengujian fungsional berbasis UI (User Interface) dan tidak mencakup pengujian non-fungsional seperti performance testing, security testing, atau load testing.
+ Pengujian dilakukan pada browser modern (Chrome, Firefox, dan WebKit) menggunakan Playwright sebagai automation testing framework.
+ Penelitian ini tidak mencakup pengujian untuk aplikasi mobile native atau aplikasi desktop.

== Tujuan Penelitian <tujuan-penelitian>

+ Mengukur cakupan permukaan fungsional aplikasi berbasis web yang dicapai oleh test suite hasil generate TathyaTest, pada tingkat model elemen hasil crawling DOM ter-render maupun pada tingkat kode sumber aplikasi (SUT).
+ Mengevaluasi kualitas intrinsik (densitas asersi, ketahanan locator), keandalan (flake rate, kesepakatan lintas-browser), dan efisiensi (waktu eksekusi, penghematan waktu) test suite yang dihasilkan TathyaTest dibandingkan dengan baseline manual dan test suite publik independen.

== Manfaat Penelitian <manfaat-penelitian>

+ Meningkatkan efisiensi pengujian perangkat lunak melalui otomatisasi pembuatan test case yang mengurangi ketergantungan pada pengujian manual.
+ Meningkatkan cakupan pengujian dengan memastikan lebih banyak skenario diuji, termasuk yang mungkin terlewat dalam pengujian manual.
+ Memberikan kontribusi pada pengembangan alat pengujian perangkat lunak otomatis di lingkungan perguruan tinggi yang dapat diadaptasi untuk aplikasi berbasis web lainnya.
+ Meningkatkan kualitas aplikasi berbasis web yang digunakan dalam kegiatan akademik dan administrasi di perguruan tinggi.

== Luaran Penelitian <luaran-penelitian>

Pada @tab-luaran-penelitian disajikan luaran dari penelitian ini. Luaran tersebut dibagi menjadi dua kategori, yaitu luaran wajib dan luaran tambahan. Luaran wajib mencakup produk IPTEKSB berupa prototipe TathyaTest dan artikel ilmiah yang disusun untuk Jurnal Teknologi Informasi dan Ilmu Komputer (JUTI). Sedangkan luaran tambahan berupa Kekayaan Intelektual (KI) dalam bentuk Hak Cipta untuk prototipe TathyaTest.

#import "../template.typ": todo

#figure(
  table(
    columns: (0.6cm, 1fr, 3.6cm),
    stroke: 0.5pt,
    align: left + horizon,
    table.header([*No*], [*Jenis Luaran*], [*Indikator Capaian*]),
    table.cell(colspan: 3, align: left)[*Luaran Wajib*],
    [1], [IPTEKSB berupa _prototipe_ atau rancangan model atau teknologi tepat guna atau naskah kebijakan], [Ada -- prototipe TathyaTest telah selesai dibangun dan dievaluasi],
    [2], [Artikel pada jurnal ilmiah (JUTI)], [Manuskrip selesai disusun, #todo("belum disubmit -- perbarui status submission")],
    table.cell(colspan: 3, align: left)[*Luaran Tambahan*],
    [3], [Kekayaan Intelektual (KI) berupa Hak Cipta], [#todo("status akhir pendaftaran")],
  ),
  caption: [Luaran Penelitian],
) <tab-luaran-penelitian>
