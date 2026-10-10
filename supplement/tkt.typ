// Checklist content and scoring scale reverse-engineered from the official
// fillable form docs/pengukuran-tkt.zip -> "5. PENGUKURAN TKT SOFTWARE.xlsx"
// (sheet "PENGUKURAN TKT SOFTWARE"), not just its printed text: inspected
// cell merges, the data-validation dropdown source ($O$5:$O$10 = 0, 0.2,
// 0.4, 0.6, 0.8, 1), and the "Nilai Rata-rata" (average) row per level.
#import "common.typ": laporan, todo, doc, letterhead

#show: doc

#letterhead()

#align(center)[
  #text(size: 13pt, weight: "bold")[RINGKASAN HASIL] \
  #text(size: 13pt, weight: "bold")[PENGUKURAN TINGKAT KESIAPTERAPAN TEKNOLOGI (TKT)]
]

#v(0.6cm)

#table(
  columns: (4.2cm, 0.4cm, 1fr),
  stroke: none,
  row-gutter: 5pt,
  [Nama/Judul Teknologi], [:], [#laporan.judul],
  [Bidang Teknologi], [:], [Software (Perangkat Lunak)],
  [Pimpinan Program/Kegiatan], [:], [#laporan.ketua.nama],
  [Lembaga/Unit Pelaksana], [:], [Jurusan Teknologi Informasi, Politeknik Negeri Malang],
  [Alamat/Kontak], [:], [#laporan.ketua.alamat],
  [Email], [:], [#laporan.ketua.email],
  [Tanggal Pengukuran TKT], [:], [#todo("tanggal pengukuran")],
  [Level TKT yang Dicapai], [:], [#todo("level TKT akhir yang benar-benar tercapai") (dari 9 level, target awal TKT 4)],
  [% Komplit Indikator], [:], [#todo("persentase, set point 0,8")],
)

#v(1cm)

#line(length: 100%)

#v(0.3cm)

#text(weight: "bold")[Petunjuk Pengisian]

Tabel berikut memuat indikator resmi Tingkat Kesiapterapan Teknologi (TKT) bidang perangkat lunak (software), level 1 s.d. 9, sebagaimana diatur dalam borang resmi P3M Polinema. Beri skor pada kolom "Skor" untuk setiap indikator sesuai tingkat pemenuhannya: 0 / 0,2 / 0,4 / 0,6 / 0,8 / 1 (0 = belum terpenuhi sama sekali, 1 = terpenuhi penuh). "Nilai Rata-rata" tiap level dihitung dari rata-rata skor seluruh indikator pada level tersebut. TKT yang dicapai adalah level tertinggi yang Nilai Rata-ratanya mencapai set point (0,8).

#pagebreak()

#let tkt-level(level, indicators) = {
  align(center)[#text(size: 12pt, weight: "bold")[TKT #level]]
  v(0.1cm)
  table(
    columns: (0.6cm, 1fr, 2.4cm),
    stroke: 0.5pt,
    align: left + horizon,
    table.header([*No*], [*Indikator*], [*Skor*]),
    ..indicators
      .enumerate()
      .map(((i, ind)) => ([#(i + 1)], [#ind], [#todo("skor")]))
      .flatten(),
    table.cell(colspan: 2, align: center)[*Nilai Rata-rata*], [#todo("avg")],
  )
  v(0.5cm)
}

#tkt-level(
  1,
  (
    "Merupakan tingkat terendah dari kesiapan teknologi perangkat lunak",
    "Merupakan ranah baru dalam perangkat lunak yang sedang didalami oleh komunitas riset dasar",
    "Mencakup juga pengembangan dari penggunaan tingkat dasar, sifat dasar dari arsitektur perangkat lunak, formulasi matematika, dan algoritma umum",
  ),
)

#tkt-level(
  2,
  (
    "Setelah prinsip dasar teramati, berlanjut pada pembuatan aplikasi yang bersifat praktis",
    "Aplikasi bersifat spekulatif, dan terdapat kemungkinan tidak memiliki bukti atau analisis rinci untuk mendukung asumsi yang ada/dilakukan",
    "Contoh-contoh dibatasi pada studi analitik dengan menggunakan data sintetis (buatan)",
  ),
)

#tkt-level(
  3,
  (
    "Terdapat inisiasi proses penelitian dan pengembangan yang dilakukan secara aktif",
    "Kelayakan ilmiah ditunjukkan melalui studi analitik dan laboratorium",
    "Mencakup juga pengembangan dari lingkungan fungsi terbatas untuk memvalidasi sifat kritis dan prediksi analitis menggunakan: (1) komponen perangkat lunak yang tidak terintegrasi dan (2) sebagian data yang mewakili",
  ),
)

#tkt-level(
  4,
  (
    "Komponen dasar dari perangkat lunak dasar terintegrasi bekerja secara bersama-sama",
    "Relatif primitif bila sisi efisiensi dan kehandalan (robustness) dibandingkan dengan sistem/produk akhirnya",
    "Pengembangan arsitektur dimulai dengan cakupan isu-isu terkait interoperabilitas, kehandalan, kemudahan pemeliharaan, kemampuan peningkatan, skalabilitas, dan keamanan",
    "Terdapat usaha penyesuaian dengan elemen (teknologi) terkini",
    "Prototipe yang ada dikembangkan untuk menunjukkan aspek yang berbeda pada sistem/produk akhirnya",
  ),
)

#tkt-level(
  5,
  (
    "Merupakan tingkatan dimana teknologi perangkat lunak yang dikembangkan siap untuk diintegrasikan dengan sistem eksisting",
    "Implementasi prototipe yang sesuai/patuh dengan lingkungan/antarmuka dari target",
    "Dilakukan eksperimen terhadap permasalahan yang sesungguhnya (real)",
    "Melakukan simulasi terhadap antarmuka dari sistem eksisting",
    "Arsitektur perangkat lunak sistem selesai",
    "Algoritma berjalan pada (multi) prosesor di lingkungan operasional dengan karakteristik yang sesuai ekspektasi",
  ),
)

#tkt-level(
  6,
  (
    "Merupakan tingkatan dimana kelayakan rekayasa dari teknologi perangkat lunak ditunjukkan",
    "Mencakup juga implementasi prototipe laboratorium dengan permasalahan realistik skala penuh, dimana teknologi perangkat lunak terintegrasi secara parsial dengan perangkat keras/lunak dari sistem eksisting",
  ),
)

#tkt-level(
  7,
  (
    "Merupakan tingkatan dimana kelayakan program dari teknologi perangkat lunak ditunjukkan",
    "Mencakup juga implementasi prototipe lingkungan operasional, dimana fungsi risiko teknis yang bersifat kritikal tersedia untuk ditunjukkan dan diuji dalam kondisi teknologi perangkat lunak tersebut terintegrasi secara baik dengan perangkat keras/lunak dari sistem operasional",
  ),
)

#tkt-level(
  8,
  (
    "Merupakan tingkatan dimana teknologi perangkat lunak terintegrasi sepenuhnya dengan perangkat keras dan lunak dari sistem operasional",
    "Dokumentasi pengembangan perangkat lunak lengkap",
    "Semua fungsi diuji baik dalam skenario simulasi maupun operasional",
  ),
)

#tkt-level(
  9,
  (
    "Merupakan tingkatan dimana teknologi perangkat lunak tersebut siap untuk dikembangkan maupun dipakai secara berulang (rapid development/re-use)",
    "Perangkat lunak berbasis teknologi yang sepenuhnya terintegrasi dengan perangkat keras/lunak dari sistem operasional",
    "Semua dokumentasi perangkat lunak telah diverifikasi",
    "Memiliki pengalaman sukses dari sisi operasional",
    "Terdapat dukungan berkelanjutan terhadap rekayasa perangkat lunak",
    "Sistem bersifat aktual (benar-benar ada dan dipergunakan)",
  ),
)

#v(0.5cm)

#text(style: "italic")[TKT yang dicapai adalah level TKT tertinggi yang Nilai Rata-ratanya mencapai set point (0,8).]
