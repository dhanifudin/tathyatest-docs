#import "../template.typ": todo

= REALISASI ANGGARAN PENELITIAN <lampiran-a>

#set text(size: 8.5pt)

#table(
  columns: (0.6cm, 2.6cm, 3.6cm, 1.4cm, 1.8cm, 1.8cm, 1.8cm),
  stroke: 0.5pt,
  align: (center, left, left, center, right, right, right),
  table.header([*No*], [*Material*], [*Justifikasi Pemakaian*], [*Kuantitas*], [*Harga Satuan (Rp)*], [*Diusulkan (Rp)*], [*Realisasi (Rp)*]),

  table.cell(colspan: 7, align: left)[*1. BIAYA SEWA ALAT (15%)*],
  [1.1], [Sewa Server untuk Testing], [Server diperlukan untuk deployment aplikasi web yang akan diuji], [8 bulan], [100.000], [800.000], [#todo("Rp")],
  [1.2], [Sewa Cloud Storage], [Penyimpanan dataset dan hasil pengujian], [8 bulan], [43.437], [347.500], [#todo("Rp")],
  table.cell(colspan: 5, align: right)[*Total Biaya Sewa Alat*], table.cell(align: right)[*1.147.500*], table.cell(align: right)[#todo("Rp")],

  table.cell(colspan: 7, align: left)[*2. BIAYA BAHAN (40%)*],
  [2.1], [Lisensi IDE dan Tools], [Lisensi untuk development tools (JetBrains WebStorm)], [4 lisensi], [500.000], [2.000.000], [#todo("Rp")],
  [2.2], [Hardisk Eksternal], [Penyimpanan backup data penelitian dan dokumentasi], [2 unit], [300.000], [600.000], [#todo("Rp")],
  [2.3], [Alat Tulis Kantor (ATK)], [ATK untuk dokumentasi dan administrasi penelitian], [1 paket], [300.000], [300.000], [#todo("Rp")],
  [2.4], [Printout dan Fotocopy], [Cetak dokumen proposal, laporan, dan materi penelitian], [1 paket], [160.000], [160.000], [#todo("Rp")],
  table.cell(colspan: 5, align: right)[*Total Biaya Bahan*], table.cell(align: right)[*3.060.000*], table.cell(align: right)[#todo("Rp")],

  table.cell(colspan: 7, align: left)[*3. BIAYA PERJALANAN (20%)*],
  [3.1], [Transportasi Pengumpulan Data], [Transportasi untuk pengumpulan konfigurasi dan data uji aplikasi studi kasus], [15 kali], [50.000], [750.000], [#todo("Rp")],
  [3.2], [Transportasi Uji Coba], [Transportasi untuk testing dan validasi prototipe], [10 kali], [50.000], [500.000], [#todo("Rp")],
  [3.3], [Transportasi Konsultasi Pakar], [Transportasi untuk konsultasi dengan pakar software testing], [4 kali], [70.000], [280.000], [#todo("Rp")],
  table.cell(colspan: 5, align: right)[*Total Biaya Perjalanan*], table.cell(align: right)[*1.530.000*], table.cell(align: right)[#todo("Rp")],

  table.cell(colspan: 7, align: left)[*4. BIAYA LAIN-LAIN (25%)*],
  [4.1], [Honorarium Pembantu Peneliti], [Honorarium untuk 4 mahasiswa selama 8 bulan], [32 bulan-orang], [25.000], [800.000], [#todo("Rp")],
  [4.2], [Biaya Publikasi Jurnal], [Biaya publikasi artikel pada jurnal ilmiah (JUTI)], [1 artikel], [600.000], [600.000], [#todo("Rp")],
  [4.3], [Biaya Pendaftaran HKI], [Biaya pendaftaran Hak Cipta], [1 HKI], [300.000], [300.000], [#todo("Rp")],
  [4.4], [Dokumentasi], [Dokumentasi kegiatan penelitian (foto, video)], [1 paket], [112.500], [112.500], [#todo("Rp")],
  [4.5], [Komunikasi], [Biaya komunikasi dan koordinasi penelitian], [8 bulan], [12.500], [100.000], [#todo("Rp")],
  table.cell(colspan: 5, align: right)[*Total Biaya Lain-lain*], table.cell(align: right)[*1.912.500*], table.cell(align: right)[#todo("Rp")],

  table.cell(colspan: 5, align: right)[*SUB TOTAL*], table.cell(align: right)[*7.650.000*], table.cell(align: right)[#todo("Rp")],
  table.cell(colspan: 5, align: right)[*PAJAK (15%)*], table.cell(align: right)[*1.350.000*], table.cell(align: right)[#todo("Rp")],
  table.cell(colspan: 5, align: right)[*TOTAL KESELURUHAN*], table.cell(align: right)[*9.000.000*], table.cell(align: right)[#todo("Rp")],
)

#set text(size: 11pt)
#v(0.8cm)

*Catatan Justifikasi:*

+ *Biaya Sewa Alat (15%):* Sewa server dan cloud storage diperlukan untuk deployment dan pengujian aplikasi web secara kontinu selama 8 bulan penelitian. Server digunakan untuk menjalankan aplikasi yang akan diuji, sedangkan cloud storage untuk menyimpan dataset, hasil pengujian, dan backup data penelitian.
+ *Biaya Bahan (40%):* Lisensi IDE WebStorm diperlukan untuk 4 anggota tim peneliti dalam mengembangkan TathyaTest menggunakan TypeScript. Hardisk eksternal untuk backup data penelitian, source code, dataset, dan dokumentasi. ATK dan printout untuk dokumentasi dan administrasi penelitian.
+ *Biaya Perjalanan (20%):* Transportasi diperlukan untuk pengumpulan konfigurasi dan data uji aplikasi studi kasus, uji coba prototipe dengan pengguna, dan konsultasi dengan pakar software testing untuk validasi penelitian.
+ *Biaya Lain-lain (25%):* Honorarium pembantu peneliti untuk 4 mahasiswa yang terlibat dalam implementasi dan testing TathyaTest. Biaya publikasi jurnal (JUTI) dan pendaftaran HKI merupakan luaran wajib penelitian. Dokumentasi dan komunikasi untuk mendukung kelancaran pelaksanaan penelitian.
