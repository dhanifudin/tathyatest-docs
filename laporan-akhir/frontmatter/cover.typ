#import "../config.typ": laporan

#align(right)[
  #box(stroke: 0.5pt, inset: 6pt, width: 30%, align(center)[#text(size: 9pt, laporan.jenis)])
]

#v(-0.3cm)

#align(center)[
  #text(size: 13pt, weight: "bold")[LAPORAN PENELITIAN]

  #v(0.4cm)
  #text(size: 13pt, weight: "bold")[TENTANG]

  #v(0.4cm)
  #set par(justify: false)
  #text(size: 14pt, weight: "bold")[#upper(laporan.judul)]

  #v(0.8cm)
  #text(size: 11pt)[Penelitian ini dibiayai dengan Dana DIPA Politeknik Negeri Malang]

  #v(0.2cm)
  #text(size: 11pt)[Nomor: SP DIPA-#laporan.dipa-nomor]

  #v(1cm)
  #text(size: 11pt, weight: "bold")[Oleh:]

  #v(0.4cm)
  *#laporan.ketua.nama* \
  NIDN: #laporan.ketua.nidn

  #v(0.3cm)
  #for a in laporan.anggota [
    *#a.nama* \
    NIDN: #a.nidn
    #v(0.3cm)
  ]

  #v(1fr)

  #image("/images/logo.png", width: 22%)

  #v(0.4cm)
  #text(size: 13pt, weight: "bold")[POLITEKNIK NEGERI MALANG]

  #v(0.2cm)
  #text(size: 13pt, weight: "bold")[#upper(laporan.bulan-tahun-laporan)]
]
