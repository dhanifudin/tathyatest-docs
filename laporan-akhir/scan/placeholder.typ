// Halaman pengganti untuk lampiran yang memerlukan scan hardcopy.
// Dibuat otomatis oleh `make scan-placeholders` hanya jika file scan belum ada;
// timpa dengan file scan asli (PDF) bernama sama.
#set page(paper: "a4", margin: 2cm)
#set text(font: ("Times New Roman", "Liberation Serif"), size: 12pt, lang: "id")
#let label = sys.inputs.at("label", default: "dokumen")
#let img = sys.inputs.at("image", default: none)
#if img != none {
  align(center, image(img, width: 100%))
} else {
  v(1fr)
  align(center, text(fill: red, weight: "bold")[
    \[SCAN BELUM TERSEDIA\] \
    #label
  ])
  v(0.5em)
  align(center)[Salin file scan (PDF) ke `laporan-akhir/scan/` dengan nama yang sama, menimpa file ini.]
  v(1fr)
}
