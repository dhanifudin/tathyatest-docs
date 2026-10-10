#import "../config.typ": laporan

= PERSONALIA PENELITIAN <lampiran-b>

#set text(size: 8pt)

#let a0 = laporan.anggota.at(0)
#let a1 = laporan.anggota.at(1)
#let a2 = laporan.anggota.at(2)
#let m0 = laporan.mahasiswa.at(0)
#let m1 = laporan.mahasiswa.at(1)
#let m2 = laporan.mahasiswa.at(2)
#let m3 = laporan.mahasiswa.at(3)

#table(
  columns: (0.5cm, 2.6cm, 2cm, 2cm, 2.4cm, 1fr, 1.4cm),
  stroke: 0.5pt,
  align: left + horizon,
  table.header(
    [*No*], [*Nama Lengkap*], [*NIP/NIDN/NIM*], [*Kedudukan/Jabatan*], [*Rumpun Ilmu*],
    [*Tanggung Jawab Kerja*], [*Alokasi Waktu (jam/minggu)*],
  ),
  [1], [#laporan.ketua.nama], [NIDN: #laporan.ketua.nidn], [Ketua / #laporan.ketua.jabatan], [Rekayasa Perangkat Lunak],
  list(
    [Koordinasi tim penelitian],
    [Desain arsitektur sistem],
    [Pengembangan algoritma test case generation],
    [Penyusunan laporan penelitian],
  ), [12],

  [2], [#a0.nama], [NIDN: #a0.nidn], [Anggota / #a0.jabatan], [#a0.keahlian],
  list(
    [Desain dan implementasi database],
    [Integrasi dataset internal],
    [Pengujian dengan aplikasi Kompen dan Jayanti],
    [Analisis hasil pengujian],
  ), [10],

  [3], [#a1.nama], [NIDN: #a1.nidn], [Anggota / #a1.jabatan], [#a1.keahlian],
  list(
    [Validasi metode pengujian],
    [Analisis metrik kinerja],
    [Evaluasi cakupan pengujian],
    [Penulisan artikel publikasi],
  ), [10],

  [4], [#a2.nama], [NIDN: #a2.nidn], [Anggota / #a2.jabatan], [#a2.keahlian],
  list(
    [Implementasi web crawling],
    [Integrasi Playwright framework],
    [Pengujian cross-browser],
    [Dokumentasi teknis],
  ), [10],

  [5], [#m0.nama], [NIM: #m0.nim], [Mahasiswa], [Teknik Informatika],
  list(
    [Pengumpulan dataset aplikasi],
    [Implementasi fitur crawling],
    [Testing prototipe awal],
    [Dokumentasi kode program],
  ), [8],

  [6], [#m1.nama], [NIM: #m1.nim], [Mahasiswa], [Teknik Informatika],
  list(
    [Ekstraksi elemen HTML],
    [Pengembangan modul parsing],
    [Testing fitur ekstraksi],
    [Pembuatan user manual],
  ), [8],

  [7], [#m2.nama], [NIM: #m2.nim], [Mahasiswa], [Teknik Informatika],
  list(
    [Implementasi test case generator],
    [Pengujian dengan dataset],
    [Perbaikan bug dan error],
    [Pengumpulan data hasil testing],
  ), [8],

  [8], [#m3.nama], [NIM: #m3.nim], [Mahasiswa], [Teknik Informatika],
  list(
    [Integrasi dengan Playwright],
    [Pengujian lintas browser],
    [Analisis laporan hasil testing],
    [Persiapan materi publikasi],
  ), [8],
)
