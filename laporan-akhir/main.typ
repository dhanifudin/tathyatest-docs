#import "template.typ": laporan-akhir, lampiran-rules

#show: laporan-akhir

// ---------- Front matter: penomoran romawi, dimulai dari halaman sampul ----------
#set page(numbering: "i")
#counter(page).update(1)

#include "frontmatter/cover.typ"
#pagebreak()

#include "frontmatter/pengesahan.typ"
#pagebreak()

#include "frontmatter/identitas.typ"
#pagebreak()

#include "frontmatter/abstrak.typ"
#pagebreak()

#include "frontmatter/abstract.typ"
#pagebreak()

#include "frontmatter/kata-pengantar.typ"
#pagebreak()

#include "frontmatter/daftar.typ"

// ---------- BAB I - V: penomoran arabic, reset chapter counter ----------
#set page(numbering: "1")
#counter(page).update(1)
#counter(heading).update(0)

#include "bab/bab1.typ"
#include "bab/bab2.typ"
#include "bab/bab3.typ"
#include "bab/bab4.typ"
#include "bab/bab5.typ"

// Reference list entries render in English, matching SIM P2M / the original
// biblatex `language=english` config (all cited works are English-language).
#[
  #set text(lang: "en")
  #bibliography("/references.bib", title: [DAFTAR PUSTAKA], style: "apa")
]

// ---------- Lampiran ----------
#metadata("lampiran") <mulai-lampiran>
#show: lampiran-rules

#include "lampiran/b-susunan-tim.typ"
#include "lampiran/c-biodata.typ"
#include "lampiran/d-pernyataan-keaslian.typ"
#include "lampiran/e-ringkasan-penelitian.typ"
#include "lampiran/f-sptjb.typ"
#include "lampiran/g-artikel-bukti-luaran.typ"
#include "lampiran/h-tkt.typ"
#include "lampiran/i-kerjasama-mitra.typ"
#include "lampiran/j-rekomendasi-pusat-riset.typ"
#include "lampiran/k-prototype.typ"
