#import "../config.typ": laporan
#import "../template.typ": todo

= SURAT REKOMENDASI PUSAT RISET <lampiran-j>

#todo("Lampirkan Surat Rekomendasi Pusat Riset jika tim peneliti tergabung dalam suatu Pusat Riset Polinema (jika ada). Jika tidak, lampiran ini dapat dihapus.")

#grid(
  columns: (2cm, 1fr),
  column-gutter: 0.4cm,
  align: horizon,
  image("/images/logo.png", width: 100%),
  align(center)[
    #text(weight: "bold")[KEMENTERIAN PENDIDIKAN TINGGI, SAINS, DAN TEKNOLOGI] \
    #text(weight: "bold")[POLITEKNIK NEGERI MALANG] \
    #text(weight: "bold")[PUSAT PENELITIAN DAN PENGABDIAN KEPADA MASYARAKAT] \
    #text(size: 9pt)[Jalan Soekarno Hatta Nomor 9, Jatimulyo, Lowokwaru, Malang 65141] \
    #text(size: 9pt)[Telepon (0341) 404424, 404425, Faksimile (0341) 404420] \
    #text(size: 9pt)[Laman www.polinema.ac.id]
  ],
)

#v(0.2cm)
#line(length: 100%, stroke: 1pt)
#v(0.2cm)

#align(center)[#text(weight: "bold")[SURAT REKOMENDASI PUSAT RISET]]

#v(0.4cm)

Berdasarkan pengajuan proposal penelitian berikut

#table(
  columns: (0.4cm, 3.5cm, 0.3cm, 1fr),
  stroke: none,
  row-gutter: 4pt,
  [], [Judul], [:], [#laporan.judul],
  [], [Ketua Peneliti], [:], [#laporan.ketua.nama],
  [], [Skema penelitian], [:], [#laporan.jenis],
)

#v(0.4cm)

*Dengan ini kami menyatakan bahwa proposal dengan judul diatas sesuai dengan Peta jalan penelitian pada*

#table(
  columns: (0.4cm, 3.5cm, 0.3cm, 1fr),
  stroke: none,
  row-gutter: 4pt,
  [], [Nama Pusat Riset], [:], [#todo("nama pusat riset")],
  [], [Topik Riset], [:], [#todo("topik riset")],
)

#v(0.4cm)

Sebagai pertimbangan untuk evaluasi proposal penelitian, kami lampirkan peta jalan penelitian pusat riset dan peta jalan penelitian pengusul. Demikian surat rekomendasi ini dibuat sebagai bahan pertimbangan untuk pengajuan proposal penelitian dengan pendanaan DIPA Polinema.

#v(1cm)

Malang, #todo("tanggal")

Ketua Pusat Riset #todo("nama pusat riset")

#v(1.5cm)

#todo("nama")

NIDN. #todo("NIDN")
