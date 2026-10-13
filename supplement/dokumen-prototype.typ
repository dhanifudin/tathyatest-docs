// Dokumen Prototype/ Model/ Kebijakan -- format Lampiran 69 docs/panduan.pdf
// (Template Dokumen Prototipe/ Teknologi Tepat Guna/ Model) untuk luaran IPTEKSB.
#import "common.typ": laporan, doc, letterhead

#show: doc
#set text(size: 10.5pt)
#set par(justify: false)

#letterhead()

#align(center)[#text(size: 16pt, weight: "bold")[Dokumen Prototype/ Model/ Kebijakan]]
#v(0.2cm)

#let lbl(body) = text(weight: "bold", body)
#let cell-h = 1.1cm
#table(
  columns: (5cm, 1fr),
  stroke: 0.5pt,
  inset: 6pt,
  align: left + top,
  lbl[Nama ketua peneliti dan anggota],
  [
    Ketua: #laporan.ketua.nama (NIDN. #laporan.ketua.nidn) \
    Anggota: \
    #for (i, a) in laporan.anggota.enumerate() [#(i + 1). #a.nama (NIDN. #a.nidn) \ ]
  ],
  lbl[Jurusan / Program Studi], [Jurusan Teknologi Informasi / Teknik Informatika, Politeknik Negeri Malang],
  lbl[Judul prototype/ Model/ Kebijakan], [Prototype: #laporan.judul],
  lbl[TKT], [4 (validasi komponen dalam lingkungan laboratorium)],
  lbl[Fungsi],
  [
    TathyaTest menghasilkan dan menjalankan test case pengujian fungsional aplikasi web secara otomatis. Alat ini menelusuri DOM aplikasi yang telah dirender browser (Playwright) untuk setiap peran pengguna, membangun model elemen halaman dan matriks akses RBAC, lalu memetakannya menjadi test case fungsional (autentikasi, form, interaksi, paginasi, kontrol akses) yang dieksekusi lintas browser tanpa penulisan skrip manual.

    Hasil evaluasi pada tiga aplikasi studi kasus: 104, 106, dan 31 test case; cakupan model elemen 95,5% dan 100,0%; akurasi deteksi cacat terkendali 100,0% (Blade) dan 85,7% (Inertia-React); kesepakatan lintas-browser κ = 1,00.
  ],
  lbl[Spesifikasi teknis (untuk prototype)],
  [
    - Antarmuka command-line `tt` berbasis TypeScript/Node.js.
    - Automation testing: Playwright (Chromium, Firefox, WebKit) dengan sesi login per peran.
    - Konfigurasi YAML (`tathya.config.yaml`): URL aplikasi, jalur login, akun per peran.
    - Perintah: `tt init`, `tt crawl`, `tt generate`, `tt run`, `tt report`, `tt eval`, `tt all`.
    - Keluaran: spesifikasi Playwright (`tests/generated/`), laporan HTML dan JSON.
    - Kode sumber: github.com/dhanifudin/tathyatest.
  ],
)

#pagebreak()

#table(
  columns: (5cm, 1fr),
  stroke: 0.5pt,
  inset: 6pt,
  align: left + top,
  [#lbl[Status KI \*] \ (coret yang tidak perlu)],
  [
    #lbl[Judul KI:] #laporan.judul \
    #v(0.2cm)
    Status : #strike[Belum didaftarkan]/#strike[Terdaftar]/#strike[Granted] (dalam proses pendaftaran) \
    Jenis : Hak Cipta/#strike[Paten]/#strike[Paten Sederhana]
  ],
)

#v(0.4cm)
#lbl[Keterangan]
#v(0.1cm)

- *Bagan alat.* Alur kerja TathyaTest ditunjukkan pada gambar berikut.

#figure(
  image("/paper/diagrams/pipeline-overview.svg", width: 95%),
  caption: [Alur kerja TathyaTest dari konfigurasi hingga laporan eksekusi.],
  numbering: none,
)

- *Cara kerja.* Pengguna menyiapkan konfigurasi (URL, jalur login, akun per peran). `tt crawl` login sebagai tiap peran dan menelusuri DOM hasil render menjadi crawl-contract (form, field, tautan, tombol, tabel). `tt generate` menyusun matriks akses RBAC dan memetakan elemen menjadi test case positif, negatif, dan tepi dengan locator berbasis peran/label. `tt run` mengeksekusi test pada tiga browser per peran dan `tt report` menampilkan laporan hasil. `tt eval` menghitung metrik evaluasi (cakupan, deteksi cacat, keandalan, efisiensi).
