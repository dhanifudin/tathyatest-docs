#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import fletcher.shapes: diamond, pill

= METODE PENELITIAN <bab-iii-metode-penelitian>

== Metode Penelitian <metode-penelitian>

Penelitian ini menggunakan metode Prototyping untuk mengembangkan TathyaTest: Test Case Generator Otomatis. Pendekatan Prototyping dipilih karena sifatnya yang iteratif, memungkinkan pengujian dan perbaikan berkelanjutan berdasarkan umpan balik pengguna @garousi2019greylit. Pada tahap awal, prototipe TathyaTest dibuat dengan fitur dasar yang mengarah pada pengujian CRUD sederhana (Create, Read, Update, Delete) untuk menguji kemampuan dasar sistem dalam menghasilkan test case otomatis, sebelum akhirnya beralih ke aplikasi yang lebih kompleks.

Metode Prototyping memungkinkan pengembangan alat dilakukan secara bertahap, dengan setiap prototipe diuji dan disempurnakan berdasarkan temuan dari pengujian dan umpan balik pengguna. Dalam konteks TathyaTest, prototipe awal difokuskan pada pembuatan test case otomatis yang dapat menguji operasi dasar pada aplikasi CRUD, yang mencakup pengujian fungsionalitas seperti penambahan data, pembacaan data, pembaruan data, dan penghapusan data. Alur lengkap metode prototyping yang digunakan dalam penelitian ini ditunjukkan pada @fig-prototyping-flow.

== Desain Penelitian <desain-penelitian>

Desain penelitian ini adalah eksperimen dengan pendekatan deskriptif-analitik. Penelitian ini bertujuan untuk mengembangkan dan menguji TathyaTest secara bertahap melalui serangkaian iterasi Prototyping. Seperti yang digambarkan pada @fig-prototyping-flow, proses pengembangan dimulai dari pembuatan prototipe awal dengan fitur CRUD sederhana, kemudian dilanjutkan dengan uji coba dan pengumpulan umpan balik pengguna. Jika diperlukan perbaikan, prototipe disempurnakan sebelum dilanjutkan ke tahap berikutnya. Setelah prototipe dasar stabil, pengembangan diperluas untuk mendukung pengujian lintas browser menggunakan Playwright dan dievaluasi pada aplikasi studi kasus yang memiliki arsitektur MVC dan RBAC.

#figure(
  diagram(
    node-stroke: 1pt,
    spacing: (12mm, 8mm),
    node((0, 0), [Mulai], shape: pill, fill: red.lighten(70%)),
    node((0, 1), [Pembuatan Prototipe Awal (CRUD)], fill: blue.lighten(70%)),
    node((0, 2), [Uji Coba dan Umpan Balik], fill: blue.lighten(70%)),
    node((0, 3), [Perlu Perbaikan?], shape: diamond, fill: green.lighten(70%)),
    node((0, 4), [Perbaikan dan Pengembangan Fitur], fill: blue.lighten(70%)),
    node((0, 5), [Pengembangan Fitur Lintas Browser], fill: blue.lighten(70%)),
    node((0, 6), [Pengujian Skala Kecil (CRUD Dasar)], fill: blue.lighten(70%)),
    node((0, 7), [Prototipe Dasar OK?], shape: diamond, fill: green.lighten(70%)),
    node((0, 8), [Pengujian dengan Dataset Internal], fill: blue.lighten(70%)),
    node((0, 9), [Prototipe Memenuhi Syarat?], shape: diamond, fill: green.lighten(70%)),
    node((0, 10), [Selesai], shape: pill, fill: red.lighten(70%)),

    edge((0, 0), (0, 1), "-|>"),
    edge((0, 1), (0, 2), "-|>"),
    edge((0, 2), (0, 3), "-|>"),
    edge((0, 3), (0, 4), "-|>", label: [Ya]),
    edge((0, 3), (1, 3), (1, 5), (0, 5), "-|>", label: [Tidak]),
    edge((0, 4), (0, 5), "-|>"),
    edge((0, 5), (0, 6), "-|>"),
    edge((0, 6), (0, 7), "-|>"),
    edge((0, 7), (0, 8), "-|>", label: [Ya]),
    edge((0, 7), (-1, 7), (-1, 4), (0, 4), "-|>", label: [Tidak]),
    edge((0, 8), (0, 9), "-|>"),
    edge((0, 9), (0, 10), "-|>", label: [Ya]),
    edge((0, 9), (-1, 9), (-1, 1), (0, 1), "-|>", label: [Tidak]),
  ),
  caption: [Alur Metode Prototyping dalam Pengembangan TathyaTest],
) <fig-prototyping-flow>

Tahap awal penelitian fokus pada pembuatan prototipe TathyaTest yang dapat menghasilkan test case otomatis untuk aplikasi berbasis web dengan operasi CRUD sederhana. CRUD adalah fungsi dasar yang sering digunakan dalam aplikasi web, yang mencakup Create (menambahkan data baru), Read (membaca atau mengambil data), Update (memperbarui data yang ada), dan Delete (menghapus data). Prototipe awal TathyaTest diuji dengan aplikasi CRUD sederhana (misalnya, sistem manajemen data atau aplikasi form input) yang mencakup operasi-operasi ini untuk memvalidasi bahwa TathyaTest dapat menghasilkan test case otomatis yang menguji skenario-skenario dasar aplikasi berbasis web.

Setelah prototipe awal dikembangkan, uji coba dilakukan dengan aplikasi berbasis web sederhana yang hanya mencakup operasi CRUD. Pengguna seperti tim QA atau pengembang aplikasi memberikan umpan balik mengenai fungsionalitas, kegunaan, dan efektivitas TathyaTest dalam menghasilkan test case otomatis. Pendekatan iteratif ini sejalan dengan praktik terbaik dalam pengembangan alat pengujian @shah2021. Umpan balik ini digunakan untuk menyempurnakan alat. Berdasarkan hasil uji coba dan umpan balik pengguna, TathyaTest disempurnakan untuk mendukung pengujian aplikasi yang lebih kompleks dengan fitur tambahan seperti pengujian untuk form dinamis dan modul interaktif.

Setelah pengujian CRUD sederhana selesai, TathyaTest diperluas untuk mendukung pengujian lintas browser menggunakan Playwright. Playwright digunakan untuk mengeksekusi test case otomatis yang dihasilkan oleh TathyaTest, yang memungkinkan pengujian aplikasi berbasis web di berbagai platform (Chrome, Firefox, dan WebKit). Setelah memastikan bahwa prototipe dasar dapat menangani operasi CRUD dengan baik, TathyaTest diuji dengan aplikasi studi kasus yang lebih kompleks dan memiliki kontrol akses berbasis peran (RBAC), yaitu aplikasi Laravel berbasis Blade dan aplikasi Laravel berbasis Inertia-React, serta aplikasi eksternal SauceDemo sebagai pembanding. Ketiga aplikasi ini digunakan untuk menguji kemampuan TathyaTest dalam menghasilkan test case otomatis yang mencakup fungsionalitas aplikasi yang lebih kompleks.

== Metode Pengumpulan Data <metode-pengumpulan-data>

Data yang digunakan dalam penelitian ini berasal dari dua sumber utama. Pertama, dataset CRUD sederhana yang digunakan untuk pengujian awal, yang mencakup data aplikasi berbasis web dengan operasi CRUD dasar. Data ini digunakan untuk menguji kemampuan awal TathyaTest dalam menghasilkan test case otomatis untuk pengujian fungsi-fungsi dasar aplikasi berbasis web. Kedua, dataset dari aplikasi studi kasus (Laravel Blade, Laravel Inertia-React, dan SauceDemo) digunakan setelah prototipe awal disempurnakan. Dataset ini menyediakan konfigurasi peran pengguna dan kredensial pengujian yang diuji untuk memvalidasi pengujian otomatis yang dilakukan oleh TathyaTest.

Dataset aplikasi studi kasus mencakup konfigurasi peran pengguna (role-based access control), data pengguna dummy yang aman untuk pengujian dan dihasilkan secara acak menggunakan pustaka faker dengan seed tetap agar dapat direproduksi, serta berbagai skenario penggunaan yang umum terjadi pada setiap aplikasi. Dataset ini digunakan untuk memastikan bahwa test case yang dihasilkan oleh TathyaTest relevan dengan konteks penggunaan sebenarnya dan dapat mendeteksi potensi error atau bug yang mungkin terjadi dalam operasional aplikasi.

== Arsitektur dan Alur Kerja TathyaTest <arsitektur-tathyatest>

Pengembangan TathyaTest mengikuti pendekatan Prototyping dengan alur kerja yang sistematis. @fig-tathyatest-flow menunjukkan arsitektur lengkap dan alur proses TathyaTest dari input domain aplikasi hingga menghasilkan test case yang dapat dieksekusi.

#figure(
  diagram(
    node-stroke: 1pt,
    spacing: (14mm, 8mm),
    node((0, 0), [Input Domain / URL], shape: pill, fill: red.lighten(70%)),
    node((0, 1), [Crawling DOM Ter-render], fill: blue.lighten(70%)),
    node((0, 2), [Ekstraksi Elemen HTML], fill: blue.lighten(70%)),
    node((0, 3), [Konfigurasi Peran & Dataset (YAML, Faker)], shape: fletcher.shapes.trapezium, fill: yellow.lighten(70%)),
    node((0, 4), [Pemetaan Elemen ke Test Case], fill: blue.lighten(70%)),
    node((0, 5), [Generate Test Case], fill: blue.lighten(70%)),
    node((0, 6), [Valid?], shape: diamond, fill: green.lighten(70%)),
    node((0, 7), [Eksekusi dengan Playwright], fill: blue.lighten(70%)),
    node((0, 8), [Hasil Pengujian (Pass/Fail)], shape: fletcher.shapes.trapezium, fill: yellow.lighten(70%)),
    node((0, 9), [Selesai], shape: pill, fill: red.lighten(70%)),

    node((1, 1), align(left, text(size: 8.5pt)[Playwright (Chromium): \ crawling per peran pengguna]), stroke: none),
    node((1, 2), align(left, text(size: 8.5pt)[Ekstraksi via page.evaluate() \ pada konteks browser]), stroke: none),
    node((1, 7), align(left, text(size: 8.5pt)[Cross-browser testing: \ Chrome, Firefox, WebKit]), stroke: none),

    edge((0, 0), (0, 1), "-|>"),
    edge((0, 1), (0, 2), "-|>"),
    edge((0, 2), (0, 3), "-|>"),
    edge((0, 3), (0, 4), "-|>"),
    edge((0, 4), (0, 5), "-|>"),
    edge((0, 5), (0, 6), "-|>"),
    edge((0, 6), (0, 7), "-|>", label: [Ya]),
    edge((0, 6), (1, 6), (1, 4), (0, 4), "-|>", label: [Tidak]),
    edge((0, 7), (0, 8), "-|>"),
    edge((0, 8), (0, 9), "-|>"),

    edge((0, 1), (1, 1), "..", stroke: gray + 0.6pt),
    edge((0, 2), (1, 2), "..", stroke: gray + 0.6pt),
    edge((0, 7), (1, 7), "..", stroke: gray + 0.6pt),
  ),
  caption: [Alur Proses TathyaTest dari Input Domain hingga Test Case],
) <fig-tathyatest-flow>

Proses dimulai dengan input domain atau URL aplikasi web yang akan diuji beserta konfigurasi peran pengguna dan kredensial login. TathyaTest kemudian melakukan crawling menggunakan Playwright (Chromium): untuk setiap peran pengguna, sistem melakukan login secara terotentikasi satu kali, lalu menjelajahi (breadth-first) seluruh URL satu-origin yang dapat dijangkau dari DOM yang telah ter-render sepenuhnya, termasuk aplikasi dengan rendering sisi klien (SPA) @mishra2020. Setelah crawling selesai, TathyaTest melakukan ekstraksi elemen HTML langsung pada konteks browser menggunakan skrip evaluasi DOM (`page.evaluate()`), yang mengidentifikasi form (beserta klasifikasi operasi CRUD dari atribut method tersembunyi), field input berikut batasan validasinya, tautan, tombol, dan tabel. Pendekatan ini mengikuti tren modern dalam web data extraction yang memanfaatkan tools dan teknik otomatis untuk ekstraksi data web yang lebih efisien @patnaik2021. Rincian alur modul crawler dan generator pada tingkat implementasi disajikan pada BAB IV (@fig-crawl-pipeline, @fig-locator-chain, @fig-constraint-variants).

Konfigurasi peran dan dataset yang telah disiapkan sebelumnya kemudian diintegrasikan ke dalam proses pemetaan elemen. Dataset ini berisi informasi seperti kredensial pengguna untuk testing serta data acak (dibangkitkan dengan pustaka faker menggunakan seed tetap agar dapat direproduksi) untuk operasi CRUD. Dengan memanfaatkan dataset ini, TathyaTest dapat memetakan elemen-elemen HTML yang telah diekstraksi ke dalam test case yang relevan dan kontekstual. Misalnya, form login dipetakan dengan kredensial pengguna dari dataset, sedangkan form input data dipetakan dengan data acak yang sesuai dengan batasan validasi masing-masing field.

Proses generate test case menghasilkan kode pengujian dalam format yang dapat dieksekusi oleh Playwright. Setiap test case mencakup langkah-langkah pengujian seperti navigasi ke halaman tertentu, pengisian form, klik tombol, dan verifikasi hasil. Sebelum dieksekusi, test case melalui proses validasi untuk memastikan bahwa struktur kode benar dan tidak ada error sintaks. Jika validasi gagal, sistem kembali ke tahap pemetaan untuk memperbaiki test case yang bermasalah.

Setelah validasi berhasil, test case dieksekusi menggunakan Playwright yang mendukung pengujian lintas browser pada Chrome, Firefox, dan WebKit. Pemilihan Playwright didasarkan pada hasil analisis komparatif yang menunjukkan keunggulan tool ini dalam efisiensi eksekusi dan penggunaan resource sistem @mon2025. Hasil pengujian dicatat dan dikategorikan sebagai Pass (berhasil) atau Fail (gagal) dengan detail error jika terjadi kegagalan. Hasil pengujian ini kemudian digunakan untuk analisis lebih lanjut dan perbaikan aplikasi yang diuji.

== Teknik Analisis Data <teknik-analisis-data>

Analisis data dalam penelitian ini difokuskan pada pendekatan kuantitatif untuk mengukur efektivitas dan kinerja TathyaTest secara objektif. Beberapa metrik kinerja utama yang digunakan adalah sebagai berikut.

*Cakupan Pengujian (Test Coverage)*

Cakupan pengujian diukur dengan menghitung persentase elemen aplikasi yang berhasil diuji oleh TathyaTest dibandingkan dengan total elemen yang ada pada aplikasi @romano2022. Formula yang digunakan adalah:

$ "Test Coverage" = ("Jumlah Elemen Teruji") / ("Total Elemen Aplikasi") times 100% $ <eq-test-coverage>

Elemen yang dihitung mencakup form input, tombol, link, tabel, dan komponen interaktif lainnya. Target minimal test coverage yang diharapkan adalah 80% untuk memastikan pengujian yang komprehensif.

*Tingkat Akurasi (Accuracy Rate)*

Tingkat akurasi mengukur kemampuan TathyaTest dalam mendeteksi bug atau error yang ada pada aplikasi, dihitung dari persentase test case yang berhasil mendeteksi bug dibandingkan dengan total test case yang dijalankan:

$ "Accuracy Rate" = ("Test Case yang Mendeteksi Bug") / ("Total Test Case") times 100% $ <eq-accuracy-rate>

Target akurasi minimal adalah 85% untuk memastikan reliabilitas TathyaTest dalam identifikasi masalah.

*Jumlah dan Kategori Bug*

Analisis dilakukan terhadap jumlah bug yang terdeteksi dan kategorinya (functional bug, UI bug, validation error, dll.). Data ini dikategorikan berdasarkan tingkat severity (critical, major, minor) untuk memahami distribusi jenis masalah yang ditemukan oleh TathyaTest.

*Analisis Statistik*

Semua data kuantitatif dianalisis menggunakan statistik deskriptif (mean, median, standar deviasi) dan disajikan dalam bentuk tabel dan grafik untuk memudahkan interpretasi hasil penelitian. Visualisasi data mencakup diagram batang untuk distribusi kategori bug, grafik persentase untuk test coverage, dan tabel komparasi untuk accuracy rate di berbagai jenis aplikasi yang diuji.

== Validitas dan Keandalan <validitas-dan-keandalan>

Untuk memastikan validitas dan keandalan hasil penelitian, beberapa langkah berikut diambil. Pertama, pengujian ulang (retest) dilakukan dengan menjalankan test case otomatis yang sama beberapa kali untuk memastikan bahwa TathyaTest menghasilkan hasil yang konsisten dan dapat diandalkan. Konsistensi hasil ini penting untuk memvalidasi bahwa alat tidak menghasilkan false positive atau false negative secara acak.

Kedua, validasi ahli (expert validation) dilakukan dengan meminta pakar di bidang software testing dan quality assurance untuk mengevaluasi test case yang dihasilkan oleh TathyaTest. Pakar menilai relevansi test case, kelengkapan skenario pengujian, dan kualitas kode test yang dihasilkan @wang2023. Umpan balik dari pakar ini digunakan untuk meningkatkan kualitas TathyaTest.

Ketiga, pengujian cross-validation dilakukan dengan menguji TathyaTest pada berbagai jenis aplikasi web dengan kompleksitas yang berbeda. Aplikasi yang diuji mencakup aplikasi CRUD sederhana hingga aplikasi studi kasus yang lebih kompleks dengan RBAC (Laravel Blade, Laravel Inertia-React) serta satu aplikasi eksternal (SauceDemo) yang berbeda tumpukan teknologi untuk menguji generalisasi di luar aplikasi yang dikembangkan sendiri oleh tim peneliti. Pendekatan ini memastikan bahwa hasil penelitian dapat digeneralisasi dan TathyaTest dapat bekerja dengan baik pada berbagai konteks aplikasi.

Keempat, triangulasi data dilakukan dengan menggunakan multiple data sources untuk memvalidasi temuan penelitian. Data dari pengujian pada berbagai aplikasi, dan hasil pengujian ulang dibandingkan dan dianalisis untuk memastikan validitas hasil penelitian. Dengan pendekatan multi-metode ini, penelitian menghasilkan kesimpulan yang lebih robust dan dapat dipercaya.
