// Layout reverse-engineered from docs/Template Ringkasan Penelitian&PKM.docx
// via pandoc (docx -> html, preserves table structure) + raw XML inspection
// for shading/font properties pandoc drops: two borderless 2-column tables,
// an orange (#FFC000) title banner, narrow-left/wide-right team+content split.
#import "common.typ": laporan, doc

#show: doc
// Two pages like the original template: page 1 = judul, Peneliti, Ringkasan
// Eksekutif, Luaran; page 2 = Latar Belakang, Metode, Hasil Dan Manfaat.
#set text(size: 10.5pt)
#set par(leading: 0.6em)

#let orange = rgb("#FFC000")
#let blue = rgb("#5b9bd5")

// Rounded light-blue "pill" section header, as in the official template.
#let pill(body) = box(
  width: 100%,
  radius: 1em,
  inset: (y: 6pt, x: 8pt),
  fill: gradient.linear(rgb("#eaf2fa"), rgb("#bdd7ee"), angle: 90deg),
  stroke: 0.75pt + blue,
  align(center + horizon, text(weight: "bold", body)),
)

#let banner = block(
  width: 100%,
  fill: orange,
  inset: 12pt,
  align(center + horizon, text(size: 14pt, weight: "bold")[#laporan.judul]),
)

#let bar(label, v, color) = (
  [#set text(size: 9pt); #label],
  box(width: v * 1%, height: 0.45cm, fill: color),
  [#set text(size: 9pt); #str(v).replace(".", ",")%],
)

// ---------- Halaman 1 ----------

#banner
#v(0.5cm)

#grid(
  columns: (36%, 1fr),
  column-gutter: 0.8cm,
  [
    #pill[#box(image("/images/icon-person.png", height: 0.6cm), baseline: 25%) #h(0.2cm) Peneliti]
    #v(0.4cm)
    #set par(justify: false, leading: 0.5em)
    #for p in (laporan.ketua,) + laporan.anggota [
      *#p.nama* \
      Jurusan Teknologi Informasi \
      Politeknik Negeri Malang \
      #p.email
      #v(0.3cm)
    ]
    *Skema Penelitian/PKM:* \
    #laporan.jenis
  ],
  [
    #pill[Ringkasan Eksekutif]
    #v(0.3cm)
    Pengujian aplikasi web di Jurusan Teknologi Informasi Politeknik Negeri Malang menghadapi tantangan dalam memastikan kualitas aplikasi akademik seperti Kompen, Jayanti, dan Whistleblower. Alat automation testing seperti Selenium, Cypress, dan Playwright masih memerlukan pembuatan test case manual yang menjadi bottleneck. TathyaTest hadir sebagai test case generator otomatis yang melakukan crawling DOM ter-render (Playwright), membangun model elemen dan matriks akses per peran pengguna (RBAC), lalu menghasilkan dan mengeksekusi test case fungsional secara otomatis. Metode Prototyping digunakan secara iteratif hingga evaluasi pada tiga aplikasi studi kasus (Laravel Blade, Laravel Inertia-React, dan SauceDemo sebagai pembanding).

    Hasil evaluasi: TathyaTest menghasilkan 104, 106, dan 31 test case untuk ketiga aplikasi. Cakupan model elemen mencapai 95,5% pada Blade dan 100,0% pada Inertia-React, dengan hasil identik di Chrome, Firefox, dan WebKit (κ = 1,00). Dari 14 cacat yang diinjeksi, 100,0% terdeteksi pada Blade dan 85,7% pada Inertia-React (baseline manual 21,4%). Pembuatan test case 30,0--32,7× lebih cepat dibanding penulisan manual (p < 0,001), dan dua cacat nyata ditemukan pada aplikasi studi kasus.

    *Kata kunci:* automation testing, test case generation, web crawling, RBAC, functional testing, Playwright

    #v(0.3cm)
    #pill[Luaran Penelitian/PKM]
    #v(0.3cm)
    #enum(
      [Subhi, D.H., Yunianto, D.R., Rismanto, R., Nurhasan, U. "TathyaTest: a generator for functional, regression, and functional-availability testing of web applications." Jurnal Teknologi Informasi dan Ilmu Komputer (JUTI) (telah disubmit).],
      [Prototipe TathyaTest: Test Case Generator Otomatis, TKT 4 (purwarupa)],
      [Hak Cipta untuk prototipe TathyaTest (dalam proses pendaftaran)],
    )
  ],
)

#pagebreak()

// ---------- Halaman 2 ----------

#grid(
  columns: (1fr, 1fr),
  column-gutter: 0.8cm,
  [
    #pill[Latar Belakang]
    #v(0.3cm)
    Aplikasi-aplikasi berbasis web di Jurusan Teknologi Informasi seperti Kompen, Jayanti, dan Whistleblower digunakan oleh mahasiswa, dosen, dan staf untuk kegiatan yang krusial, sehingga perlu diuji secara berkala agar selalu berfungsi dengan baik. Pemantauan ketersediaan server saja tidak memastikan bahwa fungsi inti seperti login, kontrol akses berbasis peran, validasi input, dan operasi CRUD berjalan benar.

    Automation testing menawarkan penghematan waktu dan pengurangan kesalahan manusia, namun tantangan terbesar adalah mengotomatisasi pembuatan test case yang relevan dengan fungsionalitas aplikasi yang diuji. TathyaTest dikembangkan untuk mengatasi masalah ini dengan menghasilkan test case otomatis berdasarkan crawling aplikasi dan elemen-elemen pada halaman web.

    #v(0.4cm)
    #pill[Metode]
    #v(0.3cm)
    Penelitian ini menggunakan metode Prototyping untuk mengembangkan TathyaTest. Pendekatan ini dipilih karena sifatnya yang iteratif, memungkinkan pengujian dan perbaikan berkelanjutan berdasarkan umpan balik pengguna.

    Prototipe awal difokuskan pada pengujian CRUD sederhana, kemudian diperluas untuk mendukung crawling DOM ter-render dan matriks akses per peran, serta pengujian lintas browser (Chrome, Firefox, dan WebKit) menggunakan Playwright. Evaluasi dilakukan pada tiga aplikasi studi kasus: aplikasi Laravel Blade, aplikasi Laravel Inertia-React yang berarsitektur MVC dan RBAC, serta SauceDemo sebagai pembanding eksternal.
  ],
  [
    #pill[Hasil Dan Manfaat]
    #v(0.3cm)
    Evaluasi menunjukkan cakupan model elemen 95,5--100,0%, hasil identik lintas browser (κ = 1,00), deteksi cacat 85,7--100,0% (baseline manual 21,4%), serta pembuatan test case 30,0--32,7× lebih cepat dibanding penulisan manual. Pengujian turut menemukan dua cacat nyata pada aplikasi studi kasus. TathyaTest bermanfaat untuk mempercepat dan memperluas cakupan pengujian fungsional aplikasi berbasis web, termasuk aplikasi internal Jurusan Teknologi Informasi pada tahap penelitian lanjutan.

    #v(0.3cm)
    #align(center, image("/paper/diagrams/pipeline-overview.svg", width: 100%))
    #align(center)[Gambar 1. Arsitektur TathyaTest.]

    #v(0.5cm)
    #grid(
      columns: (2.8cm, 1fr, 1.2cm),
      row-gutter: 8pt,
      align: left + horizon,
      ..bar("Blade", 100.0, blue),
      ..bar("Inertia-React", 85.7, blue),
      ..bar("Baseline manual", 21.4, gray),
    )
    #align(center)[Gambar 2. Akurasi deteksi cacat.]
  ],
)
