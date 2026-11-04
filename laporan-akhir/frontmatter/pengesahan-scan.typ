// Halaman Pengesahan: pindaian lembar pengesahan bertanda tangan
// (docs/Lembar Pengesahan Penelitian.jpg), menggantikan frontmatter/pengesahan.typ.
// Heading tersembunyi agar halaman ini tetap tercantum di Daftar Isi.
#[
  #show heading: none
  #heading(level: 1, numbering: none, outlined: true)[HALAMAN PENGESAHAN]
]

#block(
  width: 100%,
  height: 1fr,
  image("/docs/Lembar Pengesahan Penelitian.jpg", width: 100%, height: 100%, fit: "contain"),
)
