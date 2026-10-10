#import "config.typ": laporan

// ---------- Heading numbering ----------

// Level 1 -> "BAB I" / "BAB II" (roman, matching panduan.pdf's own sistematika
// template); deeper levels -> "1.1" / "1.1.1".
#let heading-num(..n) = {
  let nums = n.pos()
  if nums.len() == 1 {
    [BAB #numbering("I", nums.at(0))]
  } else {
    numbering("1.1", ..nums)
  }
}

// Used inside the Lampiran section: level 1 -> "LAMPIRAN A" / "LAMPIRAN B"
#let lampiran-num(..n) = {
  let nums = n.pos()
  if nums.len() == 1 {
    [LAMPIRAN #numbering("A", nums.at(0))]
  } else {
    none
  }
}

// Switch heading numbering + reset the chapter counter at the Lampiran boundary.
#let lampiran-rules(body) = {
  counter(heading).update(0)
  set heading(numbering: lampiran-num)
  body
}

// ---------- Small helpers ----------

#let todo(msg) = text(fill: red, weight: "bold")[\[TODO: #msg\]]

// Signature block used in Halaman Pengesahan / Biodata.
#let ttd-block(role, nama, nip: none, ttd: none, gap: 1cm, id-label: "NIP.") = align(center)[
  #role
  #v(gap)
  #if ttd != none [
    #image(ttd, width: 3cm)
    #v(-0.3cm)
  ]
  *#nama*
  #if nip != none [ \ #id-label #nip ]
]

// A filled Gantt-chart cell for jadwal tables.
#let g() = table.cell(fill: rgb("#cfe2ff"))[]

// ---------- Main document rule ----------

#let laporan-akhir(body) = {
  set document(title: laporan.judul, author: laporan.ketua.nama)
  set page(paper: "a4", margin: 1in, numbering: none)
  set text(font: ("Times New Roman", "Liberation Serif"), size: 12pt, lang: "id", region: "ID")
  set par(leading: 1em, spacing: 1.2em, justify: true, first-line-indent: (amount: 1.25cm, all: true))

  // Inline citations render in English ("et al.") matching SIM P2M / the
  // original biblatex config, even though surrounding prose stays Indonesian
  // (scoping the lang override to just the citation avoids mis-hyphenating
  // Indonesian paragraph text with English hyphenation rules).
  show cite: set text(lang: "en")

  set heading(numbering: heading-num)

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(math.equation).update(0)
    set align(center)
    set par(first-line-indent: 0pt)
    block(above: 20pt, below: 20pt)[
      #set text(size: 14pt, weight: "bold")
      #if it.numbering != none {
        counter(heading).display(it.numbering)
        linebreak()
      }
      #upper(it.body)
    ]
  }

  show heading.where(level: 2): it => {
    set text(size: 12pt, weight: "bold")
    set par(first-line-indent: 0pt)
    block(above: 14pt, below: 8pt, it)
  }

  show heading.where(level: 3): it => {
    set text(size: 12pt, weight: "bold", style: "italic")
    set par(first-line-indent: 0pt)
    block(above: 12pt, below: 6pt, it)
  }

  show heading.where(level: 4): it => {
    set text(size: 11pt, weight: "bold", style: "italic")
    set par(first-line-indent: 0pt)
    block(above: 10pt, below: 4pt, it)
  }

  // Gambar X.Y / Tabel X.Y — numbered by current chapter (BAB) + sequence within it.
  set figure(numbering: n => numbering("1.1", counter(heading).get().at(0, default: 0), n))
  show figure.where(kind: image): set figure(supplement: [Gambar])
  show figure.where(kind: table): set figure(supplement: [Tabel])
  show figure.where(kind: table): set figure.caption(position: top)

  set math.equation(numbering: n => [(#numbering(
    "1.1",
    counter(heading).get().at(0, default: 0),
    n,
  ))])

  body
}
