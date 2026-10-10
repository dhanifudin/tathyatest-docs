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
// matching the header used across the panduan.pdf's official form templates
// (Surat Pernyataan Keaslian, Surat Rekomendasi Pusat Riset, SPTJB, etc.).
#let letterhead() = {
  grid(
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
  v(0.2cm)
  line(length: 100%, stroke: 1pt)
  v(0.4cm)
}
