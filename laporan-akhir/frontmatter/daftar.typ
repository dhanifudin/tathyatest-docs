#outline(title: [DAFTAR ISI], indent: auto, depth: 3)
#pagebreak(weak: true)

#outline(title: [DAFTAR GAMBAR], target: figure.where(kind: image))
#pagebreak(weak: true)

#outline(title: [DAFTAR TABEL], target: figure.where(kind: table))
#pagebreak(weak: true)

#outline(
  title: [DAFTAR LAMPIRAN],
  target: heading.where(level: 1).after(<mulai-lampiran>),
)
