#import "../config.typ": laporan
#import "../template.typ": todo

#heading(level: 1, numbering: none, outlined: true)[IDENTITAS DAN URAIAN UMUM PENELITIAN]

#set text(size: 11pt)

#let a0 = laporan.anggota.at(0)
#let a1 = laporan.anggota.at(1)
#let a2 = laporan.anggota.at(2)
#let m0 = laporan.mahasiswa.at(0)
#let m1 = laporan.mahasiswa.at(1)
#let m2 = laporan.mahasiswa.at(2)
#let m3 = laporan.mahasiswa.at(3)

#enum(
  spacing: 0.4cm,
  [Judul Penelitian: #laporan.judul],

  [
    Tim Peneliti:

    #v(0.1cm)
    #set text(size: 9pt)
    #table(
      columns: (0.6cm, 3.2cm, 2cm, 3.2cm, 2.6cm, 1.6cm),
      stroke: 0.5pt,
      align: left + horizon,
      table.header([*No*], [*Nama*], [*Jabatan*], [*Bidang Keahlian*], [*Jurusan*], [*Alokasi Waktu*]),
      [1], [#laporan.ketua.nama \ NIDN: #laporan.ketua.nidn], [Ketua], [#laporan.ketua.keahlian], [Teknik Informatika], [12],
      [2], [#a0.nama \ NIDN: #a0.nidn], [Anggota 1], [#a0.keahlian], [Teknik Informatika], [10],
      [3], [#a1.nama \ NIDN: #a1.nidn], [Anggota 2], [#a1.keahlian], [Teknik Informatika], [10],
      [4], [#a2.nama \ NIDN: #a2.nidn], [Anggota 3], [#a2.keahlian], [Teknik Informatika], [10],
      [5], [#m0.nama \ NIM: #m0.nim], [Pembantu pelaksana], [Teknik Informatika], [Teknik Informatika], [8],
      [6], [#m1.nama \ NIM: #m1.nim], [Pembantu pelaksana], [Teknik Informatika], [Teknik Informatika], [8],
      [7], [#m2.nama \ NIM: #m2.nim], [Pembantu pelaksana], [Teknik Informatika], [Teknik Informatika], [8],
      [8], [#m3.nama \ NIM: #m3.nim], [Pembantu pelaksana], [Teknik Informatika], [Teknik Informatika], [8],
    )
  ],

  [Obyek Penelitian: Aplikasi berbasis web dengan arsitektur MVC dan kontrol akses berbasis peran (RBAC) sebagai studi kasus evaluasi — aplikasi Laravel Blade dan Laravel Inertia-React, serta aplikasi eksternal SauceDemo sebagai pembanding (baseline).],

  [Masa Pelaksanaan: #laporan.waktu.mulai -- #laporan.waktu.sampai],

  [Biaya: Rp #laporan.biaya,-],

  [Lokasi Penelitian: #laporan.lokasi],

  [
    TKT awal: 2 (bukti konsep fungsi dan/atau karakteristik penting secara analitis dan eksperimental telah dihasilkan) \
    TKT akhir yang dihasilkan: 4 (validasi komponen dalam lingkungan laboratorium — prototipe TathyaTest telah diuji dan dievaluasi secara menyeluruh terhadap tiga aplikasi studi kasus dengan cakupan model hingga 100% dan tingkat akurasi deteksi cacat hingga 100% pada katalog cacat terkendali, serta terbukti menemukan dua cacat nyata pada aplikasi studi kasus, namun belum divalidasi pada lingkungan operasional aplikasi internal JTI)
  ],

  [Grup Riset: #todo("nama grup riset Polinema yang menaungi penelitian ini, jika ada")],

  [Instansi Lain yang Terlibat: Tidak ada],

  [Temuan yang Ditargetkan: Metode otomatis test case generation untuk aplikasi web berbasis crawling DOM ter-render (Playwright) dan pemetaan elemen-ke-test-case, diwujudkan dalam bentuk prototipe TathyaTest yang mampu menghasilkan dan mengeksekusi test case fungsional secara otomatis lintas peran pengguna (RBAC) dan lintas browser.],

  [Kontribusi Mendasar pada Suatu Bidang Ilmu: Penelitian ini memberikan kontribusi pada bidang Software Testing dan Quality Assurance melalui pengembangan metode otomatis untuk test case generation berbasis crawling DOM ter-render dan pemetaan elemen-ke-test-case lintas peran pengguna. TathyaTest mengotomatisasi proses ini untuk menghasilkan test case fungsional yang relevan dan kontekstual, terbukti memenuhi target akurasi deteksi cacat melalui injeksi cacat terkendali (hingga 100% pada katalog cacat dapat-dideteksi), serta menemukan cacat nyata pada aplikasi studi kasus di luar skenario yang telah diketahui sebelumnya.],

  [Jurnal Ilmiah yang Menjadi Sasaran: Jurnal Teknologi Informasi dan Ilmu Komputer (JUTI). Naskah telah selesai disusun (manuskrip lengkap), #todo("status: belum disubmit — perbarui setelah submission")],

  [Rencana Luaran HKI, Buku, Purwarupa, atau Luaran Lainnya: Prototipe TathyaTest (purwarupa TKT 4) dan Hak Cipta untuk prototipe TathyaTest. #todo("nomor pencatatan dan status Hak Cipta, tahun perolehan/penyelesaian")],
)
