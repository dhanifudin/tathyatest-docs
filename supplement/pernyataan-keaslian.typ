// Surat Pernyataan Keaslian laporan akhir: dicetak, ditandatangani (dengan meterai),
// lalu dipindai ke laporan-akhir/scan/d-pernyataan-keaslian.pdf (Lampiran C).
// Kata-kata mengikuti surat pernyataan keaslian proposal (images/surat-pernyataan-keaslian.png).
#import "common.typ": laporan, doc, letterhead

#show: doc

#letterhead()

#align(center)[
  #underline[#text(size: 13pt, weight: "bold")[SURAT PERNYATAAN KEASLIAN LAPORAN AKHIR]]
]

#v(0.5cm)

Yang bertanda tangan di bawah ini:

#table(
  columns: (4.3cm, 0.4cm, 1fr),
  stroke: none,
  inset: (left: 0pt, rest: 5pt),
  row-gutter: 6pt,
  [Nama], [:], [#laporan.ketua.nama],
  [NIP/NIDN/NIDK], [:], [#laporan.ketua.nip],
  [Pangkat/Golongan], [:], [III/B],
  [Jabatan Fungsional], [:], [#laporan.ketua.jabatan],
)

#v(0.2cm)

Dengan ini menyatakan bahwa Penelitian saya dengan judul: *"#laporan.judul"* yang dilaksanakan dalam skema #laporan.jenis untuk tahun anggaran 2026 *bersifat original dan belum dibiayai oleh Lembaga/sumber dana lain*, serta laporan akhir ini disusun berdasarkan hasil penelitian tersebut.

Bilamana di kemudian hari ditemukan ketidaksesuaian dengan pernyataan ini, maka saya bersedia dituntut dan diproses sesuai dengan ketentuan yang berlaku dan mengembalikan seluruh biaya penugasan yang diterima ke Kas Negara.

Demikian pernyataan ini dibuat dengan sesungguhnya dan dengan sebenar-benarnya.

#v(1cm)

#align(right)[
  #box[#align(left)[
    Malang, 12 Oktober 2026

    Yang Menyatakan,

    #v(0.2cm)
    #box(width: 2.6cm, height: 1.8cm, stroke: (paint: luma(200), dash: "dashed"), align(center + horizon, text(size: 7pt, fill: luma(150))[Meterai \ Rp 10.000]))
    #v(0.2cm)

    #laporan.ketua.nama \
    NIP. #laporan.ketua.nip
  ]]
]
