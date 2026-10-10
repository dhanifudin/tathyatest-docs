#import "common.typ": laporan, todo, doc, letterhead

#show: doc

#letterhead()

#align(center)[
  #text(size: 13pt, weight: "bold")[SURAT PERNYATAAN TANGGUNG JAWAB BELANJA]
]

#v(0.8cm)

Yang bertanda tangan di bawah ini:

#table(
  columns: (2.2cm, 0.4cm, 1fr),
  stroke: none,
  row-gutter: 6pt,
  [Nama], [:], [#laporan.ketua.nama],
  [Alamat], [:], [#laporan.ketua.alamat],
  [Skema Penelitian/PKM], [:], [#laporan.jenis],
)

#v(0.5cm)

Berdasarkan Surat Perjanjian/Kontrak Nomor #todo("nomor surat perjanjian/kontrak") mendapatkan Anggaran Penelitian sebesar Rp. #laporan.biaya,-, dengan judul "#laporan.judul".

#v(0.3cm)

Dengan ini menyatakan bahwa:

#enum(
  [
    Biaya kegiatan penelitian/PKM di bawah ini meliputi:

    #v(0.3cm)

    #table(
      columns: (1fr, 10fr, 2fr),
      stroke: 1pt,
      align: (left + horizon, left + horizon, center + horizon),
      [No], [Uraian], [Jumlah],
      [01], [*Bahan*], [#todo("Rp")],
      [02], [*Pengumpulan Data*], [#todo("Rp")],
      [03], [*Analisis Data (Termasuk Sewa Peralatan)*], [#todo("Rp")],
      [04], [*Pelaporan, Luaran Wajib dan Luaran Tambahan*], [#todo("Rp")],
      [], align(center)[*Jumlah*], [#todo("Rp")],
    )
  ],
  [Jumlah uang tersebut pada angka 1, benar-benar dikeluarkan untuk pelaksanaan kegiatan penelitian/PKM dimaksud.],
)

#v(0.5cm)

Demikian surat pernyataan ini dibuat dengan sebenarnya.

#v(1cm)

#align(right)[
  Malang, #todo("tanggal")

  Ketua,

  #v(2cm)

  #text(style: "italic")[(materai Rp 10.000)]

  #v(0.3cm)

  #laporan.ketua.nama \
  NIDN. #laporan.ketua.nidn
]
