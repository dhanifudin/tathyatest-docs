#import "../template.typ": fit-page

= PENGUKURAN TKT <lampiran-h>

Target penelitian ini adalah TKT 4 (validasi komponen dalam lingkungan laboratorium) dan hasil pengukuran (self-assessment) menunjukkan TKT 4 tercapai. Ringkasan hasil pengukuran TKT bidang perangkat lunak (software) ditunjukkan berikut.

// Ringkasan Hasil (sheet RINGKASAN) adalah halaman terakhir borang.
#let tkt = json("/build/tkt-software.json")

#fit-page("/build/tkt-software.pdf", tkt.pages)
