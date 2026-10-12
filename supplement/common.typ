// Shared page/text setup for standalone supplement documents (SPTJB,
// Ringkasan Penelitian & PKM, Pengukuran TKT). These are official forms
// compiled to their own PDFs and then embedded as pages into the laporan
// akhir's lampiran — so they intentionally do NOT use laporan-akhir's BAB/
// Lampiran heading machinery, just plain A4/Times styling for a clean form.
#import "../laporan-akhir/config.typ": laporan

#let todo(msg) = text(fill: red, weight: "bold")[\[TODO: #msg\]]

#let doc(body) = {
  set page(paper: "a4", margin: 2cm)
  set text(font: ("Times New Roman", "Liberation Serif"), size: 11pt, lang: "id", region: "ID")
  set par(leading: 0.65em, justify: true)
  body
}

// Official P3M Polinema letterhead (logo + institutional header + rule),
// matching the kop surat shown in docs/panduan.pdf's own official form
// templates (e.g. Lampiran 8 Surat Pernyataan Keaslian, Lampiran 21 Surat
// Rekomendasi Pusat Riset): sans-serif (Calibri, body text stays Times New
// Roman), a size/weight hierarchy -- "KEMENTERIAN..." largest and regular,
// "POLITEKNIK NEGERI MALANG" smaller and regular, "PUSAT PENELITIAN..." the
// only bold line -- and a larger logo than a typical inline letterhead.
#let letterhead() = {
  grid(
    columns: (2.6cm, 1fr),
    column-gutter: 0.4cm,
    align: horizon,
    image("/images/logo.png", width: 100%),
    align(center)[
      #set text(font: ("Calibri", "Carlito", "Liberation Sans"))
      #text(size: 14pt)[KEMENTERIAN PENDIDIKAN TINGGI, SAINS, DAN TEKNOLOGI] \
      #text(size: 12pt)[POLITEKNIK NEGERI MALANG] \
      #text(size: 12pt, weight: "bold")[PUSAT PENELITIAN DAN PENGABDIAN KEPADA MASYARAKAT] \
      #text(size: 9pt)[Jalan Soekarno Hatta Nomor 9, Jatimulyo, Lowokwaru, Malang 65141] \
      #text(size: 9pt)[Telepon (0341) 404424, 404425, Faksimile (0341) 404420] \
      #text(size: 9pt)[Laman www.polinema.ac.id]
    ],
  )
  v(0.2cm)
  line(length: 100%, stroke: 1.5pt)
  v(0.4cm)
}
