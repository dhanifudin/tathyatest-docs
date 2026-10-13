#import "common.typ": laporan, todo, doc, letterhead

#show: doc

#letterhead()

#align(center)[
  #underline[#text(size: 13pt, weight: "bold")[SURAT PERNYATAAN TANGGUNG JAWAB BELANJA]]
]

#v(0.3cm)

Yang bertanda tangan di bawah ini:

#table(
  columns: (4.3cm, 0.4cm, 1fr),
  stroke: none,
  inset: (left: 0pt, rest: 5pt),
  row-gutter: 6pt,
  [Nama], [:], [#laporan.ketua.nama],
  [Alamat], [:], [#laporan.ketua.alamat],
  [Skema Penelitian#strike[/PKM]], [:], [#laporan.jenis],
)

#v(0.15cm)

Berdasarkan Surat Perjanjian/Kontrak Nomor SP DIPA-#laporan.dipa-nomor mendapatkan Anggaran Penelitian sebesar Rp. #laporan.biaya,-, dengan judul "#laporan.judul".

#v(0.2cm)

Dengan ini menyatakan bahwa:

#enum(
  [
    Biaya kegiatan penelitian#strike[/PKM] di bawah ini meliputi:

    #v(0.2cm)

    #table(
      columns: (1fr, 10fr, 2fr),
      stroke: 1pt,
      align: (center + horizon, left + horizon, left + horizon),
      [No], align(center)[Uraian], align(center)[Jumlah],
      [01], [*Bahan*], [4.410.000],
      [02], [*Pengumpulan Data*], [1.530.000],
      [03], [*Analisis Data (Termasuk Sewa Peralatan)*], [1.947.500],
      [04], [*Pelaporan, Luaran Wajib dan Luaran Tambahan*], [1.112.500],
      [], align(center)[*Jumlah*], [9.000.000],
    )
  ],
  [Jumlah uang tersebut pada angka 1, benar-benar dikeluarkan untuk pelaksanaan kegiatan penelitian#strike[/PKM] dimaksud.],
)

#v(0.15cm)

Demikian surat pernyataan ini dibuat dengan sebenarnya.

#v(0.4cm)

#align(right)[
  #box[#align(left)[
    Malang, 12- 10- 2026

    Ketua,

    #v(2.2cm)

    #laporan.ketua.nama \
    NIDN. #laporan.ketua.nidn
  ]]
]
