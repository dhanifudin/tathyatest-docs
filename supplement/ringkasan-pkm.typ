// Layout reverse-engineered from docs/Template Ringkasan Penelitian&PKM.docx
// via pandoc (docx -> html, preserves table structure) + raw XML inspection
// for shading/font properties pandoc drops: two borderless 2-column tables,
// an orange (#FFC000) title banner, narrow-left/wide-right team+content split.
#import "common.typ": laporan, todo, doc

#show: doc
// This is meant to be a one-page infographic like the original template —
// tighten margins/leading/text size locally (without affecting the other
// supplement documents, which keep common.typ's defaults).
#set page(margin: 1.3cm)
#set text(size: 9.5pt)
#set par(leading: 0.5em)

#let orange = rgb("#FFC000")

#let section-header(body) = align(center)[*#body*]

// ---------- Section 1: judul banner + Peneliti / Ringkasan Eksekutif ----------

#table(
  columns: (36%, 1fr),
  stroke: none,
  inset: 6pt,
  table.cell(colspan: 2, fill: orange, align: center + horizon, inset: 10pt)[
    #text(size: 14pt, weight: "bold")[#laporan.judul]
  ],
  // left: Peneliti
  [
    #section-header[#image("/images/icon-person.png", height: 0.9cm) \ Peneliti]
    #v(0.3cm)
    #for p in (laporan.ketua,) + laporan.anggota [
      *#p.nama* \
      Teknik Informatika \
      Politeknik Negeri Malang \
      #p.email
      #v(0.15cm)
    ]
    *Skema Penelitian/PKM:* \
    #laporan.jenis
  ],
  // right: Ringkasan Eksekutif
  [
    #section-header[Ringkasan Eksekutif]
    #v(0.2cm)
    Pengujian aplikasi web di Jurusan Teknologi Informasi Politeknik Negeri Malang menghadapi tantangan dalam memastikan kualitas aplikasi akademik seperti Kompen, Jayanti, dan Whistleblower. Alat automation testing seperti Selenium, Cypress, dan Playwright masih memerlukan pembuatan test case manual yang menjadi bottleneck. TathyaTest hadir sebagai test case generator otomatis yang melakukan crawling DOM ter-render (Playwright), membangun model elemen dan matriks akses per peran pengguna (RBAC), lalu menghasilkan dan mengeksekusi test case fungsional secara otomatis. Metode Prototyping digunakan secara iteratif hingga evaluasi pada tiga aplikasi studi kasus (Laravel Blade, Laravel Inertia-React, dan SauceDemo sebagai pembanding).

    Hasil evaluasi: cakupan model elemen 95,5--100,0% dan cakupan rute pada tingkat kode sumber 100,0% pada aplikasi Laravel, dengan kesepakatan lintas-browser κ = 1,00 (Blade dan SauceDemo), 104 test case per aplikasi Laravel, estimasi penghematan waktu 23,9--42,6× dibandingkan penulisan manual (Mann-Whitney U, p < 0,001), dan dua cacat nyata ditemukan pada aplikasi studi kasus.

    *Kata kunci:* automation testing, test case generation, web crawling, RBAC, functional testing, Playwright

    *Luaran Penelitian/PKM:*
    #enum(
      [Subhi, D.H., Yunianto, D.R., Rismanto, R., Nurhasan, U. "TathyaTest: a generator for functional, regression, and functional-availability testing of web applications." Jurnal Teknologi Informasi dan Ilmu Komputer (JUTI). (Manuskrip selesai, #todo("belum disubmit"))],
      [Prototipe TathyaTest: Test Case Generator Otomatis, TKT 4 (purwarupa)],
      [Hak Cipta untuk prototipe TathyaTest (status #todo("terdaftar/granted, nomor pencatatan"))],
    )
  ],
)

#v(0.5cm)

// ---------- Section 2: Latar Belakang + Metode / Hasil dan Manfaat ----------

#table(
  columns: (1fr, 1fr),
  stroke: none,
  inset: 6pt,
  column-gutter: 0.6cm,
  [
    #section-header[Latar Belakang]
    #v(0.2cm)
    Aplikasi-aplikasi berbasis web di Jurusan Teknologi Informasi seperti Kompen, Jayanti, dan Whistleblower digunakan oleh mahasiswa, dosen, dan staf untuk kegiatan yang krusial, sehingga perlu diuji secara berkala agar selalu berfungsi dengan baik. Automation testing menawarkan penghematan waktu dan pengurangan kesalahan manusia, namun tantangan terbesar adalah mengotomatisasi pembuatan test case yang relevan dengan fungsionalitas aplikasi yang diuji. TathyaTest dikembangkan untuk mengatasi masalah ini dengan menghasilkan test case otomatis berdasarkan crawling aplikasi dan elemen-elemen pada halaman web.

    #section-header[Metode]
    #v(0.2cm)
    Penelitian ini menggunakan metode Prototyping untuk mengembangkan TathyaTest. Pendekatan ini dipilih karena sifatnya yang iteratif, memungkinkan pengujian dan perbaikan berkelanjutan berdasarkan umpan balik pengguna. Prototipe awal difokuskan pada pengujian CRUD sederhana, kemudian diperluas untuk mendukung pengujian lintas browser menggunakan Playwright dan dievaluasi pada aplikasi studi kasus berarsitektur MVC dan RBAC.
  ],
  [
    #section-header[Hasil Dan Manfaat]
    #v(0.2cm)
    Evaluasi menunjukkan cakupan model elemen 95,5--100,0% dan cakupan rute pada tingkat kode sumber 100,0% pada aplikasi Laravel, kesepakatan lintas-browser κ = 1,00, serta estimasi penghematan waktu 23,9--42,6× dibandingkan penulisan test case manual. Pelaksanaan pengujian turut menemukan dua cacat nyata pada aplikasi studi kasus. TathyaTest bermanfaat untuk mempercepat dan memperluas cakupan pengujian fungsional aplikasi berbasis web, termasuk aplikasi internal Jurusan Teknologi Informasi pada tahap penelitian lanjutan.

    #v(0.2cm)
    #box(width: 100%, height: 2.1cm, stroke: 0.5pt + gray, inset: 6pt)[
      #align(center + horizon)[#todo("sisipkan diagram arsitektur TathyaTest")]
    ]
    Gambar 1. Arsitektur TathyaTest.

    #v(0.2cm)
    #box(width: 100%, height: 2.1cm, stroke: 0.5pt + gray, inset: 6pt)[
      #align(center + horizon)[#todo("sisipkan grafik hasil pengujian")]
    ]
    Gambar 2. Hasil Pengujian TathyaTest.
  ],
)
