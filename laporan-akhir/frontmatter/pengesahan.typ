#import "../config.typ": laporan
#import "../template.typ": ttd-block

#heading(level: 1, numbering: none, outlined: true)[HALAMAN PENGESAHAN \ LAPORAN PENELITIAN]

#set text(size: 9pt)

#table(
  columns: (0.6cm, 5.2cm, 1fr),
  stroke: none,
  row-gutter: 1pt,
  [1.], [Judul], [: #laporan.judul],
  [2.], [Ketua Peneliti], [],
  [], [#h(0.6cm) a. Nama], [: #laporan.ketua.nama],
  [], [#h(0.6cm) b. NIP], [: #laporan.ketua.nip],
  [], [#h(0.6cm) c. Pangkat / Golongan], [: #laporan.ketua.pangkat],
  [], [#h(0.6cm) d. Jabatan Fungsional], [: #laporan.ketua.jabatan],
  [], [#h(0.6cm) e. Sedang melakukan \ #h(0.9cm) penelitian], [: Tidak ada],
  [], [#h(0.6cm) f. Alamat], [: #laporan.ketua.alamat],
  [3.], [Jumlah Anggota Peneliti], [: #laporan.anggota.len() orang],
  [], [#h(0.6cm) Anggota Peneliti 1], [: #laporan.anggota.at(0).nama \ #h(0.9cm) NIDN: #laporan.anggota.at(0).nidn],
  [], [#h(0.6cm) Anggota Peneliti 2], [: #laporan.anggota.at(1).nama \ #h(0.9cm) NIDN: #laporan.anggota.at(1).nidn],
  [], [#h(0.6cm) Anggota Peneliti 3], [: #laporan.anggota.at(2).nama \ #h(0.9cm) NIDN: #laporan.anggota.at(2).nidn],
  [4.], [Jumlah Anggota Mahasiswa], [: #laporan.mahasiswa.len()],
  [5.], [Lokasi Penelitian], [: #laporan.lokasi],
  [6.], [Waktu Penelitian], [],
  [], [#h(0.6cm) a. Mulai], [: #laporan.waktu.mulai],
  [], [#h(0.6cm) b. Sampai], [: #laporan.waktu.sampai],
  [7.], [Program Strategis Riset], [: #laporan.program-strategis],
  [8.], [Rumpun Ilmu], [: #laporan.rumpun-ilmu],
  [9.], [Biaya yang Digunakan], [: Rp #laporan.biaya,-],
  [10.], [Sumber Dana], [: Penelitian ini dibiayai dengan dana DIPA Nomor SP DIPA-#laporan.dipa-nomor, Politeknik Negeri Malang],
)

#v(0.2cm)

#grid(
  columns: (1fr, 1fr),
  gutter: 1cm,
  ttd-block([Menyetujui, \ Kepala P3M], laporan.pejabat.kepala-p3m.nama, nip: laporan.pejabat.kepala-p3m.nip, gap: 0.6cm),
  ttd-block([Malang, #laporan.tanggal-pengesahan \ Ketua Tim Peneliti], laporan.ketua.nama, nip: laporan.ketua.nip, gap: 0.6cm),
)

#v(0.2cm)

#grid(
  columns: (1fr, 1fr),
  gutter: 1cm,
  ttd-block(
    [Mengetahui, \ Wakil Direktur I],
    laporan.pejabat.wakil-direktur.nama,
    nip: laporan.pejabat.wakil-direktur.nidn,
    gap: 0.6cm,
    id-label: "NIDN.",
  ),
  ttd-block([Pejabat Pembuat Komitmen Bidang I], laporan.pejabat.ppk.nama, nip: laporan.pejabat.ppk.nip, gap: 0.6cm),
)
