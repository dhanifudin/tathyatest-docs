# Panduan Cepat - Template Proposal Penelitian

## Langkah 1: Edit Konfigurasi di proposal.tex

Buka file `proposal.tex` dan edit bagian konfigurasi (baris 70-121):

```latex
% Informasi Umum
\newcommand{\judulPenelitian}{JUDUL PENELITIAN ANDA DI SINI}
\newcommand{\bidangPenelitian}{Bidang Penelitian}
\newcommand{\jenisPenelitian}{Penelitian Reguler Kompetisi}
\newcommand{\nomorSPDIPA}{000/SP-DIPA/YYYY}
\newcommand{\lokasiPenelitian}{Lokasi Penelitian}
\newcommand{\lamaPenelitian}{6}
\newcommand{\biayaDiusulkan}{50.000.000}
\newcommand{\bulanTahun}{Januari 2026}

% Ketua Peneliti
\newcommand{\ketuaNama}{Nama Ketua Peneliti}
\newcommand{\ketuaNIDN}{0000000000}
\newcommand{\ketuaJabatan}{Lektor}
\newcommand{\ketuaProdi}{Program Studi}
\newcommand{\ketuaHP}{081234567890}
\newcommand{\ketuaEmail}{ketua@polinema.ac.id}

% Anggota Peneliti 1
\newcommand{\anggotaSatuNama}{Nama Anggota Peneliti 1}
\newcommand{\anggotaSatuNIDN}{0000000000}

% Anggota Peneliti 2
\newcommand{\anggotaDuaNama}{Nama Anggota Peneliti 2}
\newcommand{\anggotaDuaNIDN}{0000000000}

% Anggota Peneliti 3
\newcommand{\anggotaTigaNama}{Nama Anggota Peneliti 3}
\newcommand{\anggotaTigaNIDN}{0000000000}

% Mahasiswa yang terlibat
\newcommand{\jumlahMahasiswa}{2}

% Pejabat Pengesah
\newcommand{\kajurNama}{Nama Kajur/Kaprodi}
\newcommand{\kajurNIP}{000000000000000000}
\newcommand{\kajurJabatan}{Ketua Program Studi}
\newcommand{\kajurProdi}{Nama Program Studi}

\newcommand{\ketuaPTMNama}{Nama Ketua P3M}
\newcommand{\ketuaPTMNIP}{000000000000000000}

\newcommand{\tanggalPengesahan}{01 Januari 2026}
```

## Langkah 2: Isi Konten Penelitian

### Ringkasan (ringkasan.tex)
Tulis ringkasan penelitian Anda (maksimal 1 halaman) dan kata kunci.

### BAB 1: Pendahuluan (bab1.tex)
Isi:
- Latar Belakang
- Rumusan Masalah
- Batasan Masalah
- Tujuan Penelitian
- Manfaat Penelitian
- Luaran Penelitian

### BAB 2: Tinjauan Pustaka (bab2.tex)
Tulis teori-teori, konsep, dan penelitian terdahulu yang relevan.

### BAB 3: Metode Penelitian (bab3.tex)
Jelaskan metodologi penelitian secara detail.

### BAB 4: Biaya dan Jadwal (bab4.tex)
Rincian anggaran dan jadwal pelaksanaan.

### Lampiran
- **Lampiran A** (lampiran_a.tex): Justifikasi anggaran detail
- **Lampiran B** (lampiran_b.tex): Organisasi tim dan pembagian tugas
- **Lampiran C** (lampiran_c.tex): Biodata lengkap tim peneliti
- **Lampiran D** (lampiran_d.tex): Surat pernyataan keaslian (sudah otomatis dari konfigurasi)

## Langkah 3: Tambahkan Referensi

Edit file `references.bib` dan tambahkan referensi Anda dalam format BibTeX.

Contoh:
```bibtex
@article{key,
    author = {Nama Penulis},
    title = {Judul Artikel},
    journal = {Nama Jurnal},
    year = {2023},
    volume = {1},
    number = {1},
    pages = {1--10}
}
```

Untuk mensitasi dalam dokumen, gunakan: `\cite{key}`

## Langkah 4: Build PDF

```bash
# Build PDF
make

# Atau untuk melihat hasilnya langsung
make view
```

File PDF akan tersimpan di `build/proposal.pdf`

## Penomoran Halaman

Template ini menggunakan sistem penomoran halaman yang sesuai dengan standar proposal penelitian:

- **Halaman Cover**: Tanpa nomor halaman
- **Halaman Pengesahan, Daftar Isi, Ringkasan**: Menggunakan angka romawi kecil (i, ii, iii, ...)
- **BAB 1 hingga Lampiran**: Menggunakan angka arabic (1, 2, 3, ...)

Penomoran ini sudah otomatis dikonfigurasi dalam template, Anda tidak perlu mengubah apapun.

## Tips

1. **Logo**: Pastikan file `images/logo.png` ada dan sesuai
2. **Format Nomor**: Biaya diusulkan tanpa titik/koma (contoh: 50000000 bukan 50.000.000)
3. **NIDN/NIP**: Gunakan 10 digit untuk NIDN, 18 digit untuk NIP
4. **Auto-compile**: Gunakan `make watch` untuk auto-recompile saat file diubah
5. **Penomoran Halaman**: Sudah otomatis, tidak perlu diubah

## Format Halaman Cover

Halaman cover akan menampilkan:
- Box "Penelitian Reguler Kompetisi" di pojok kanan atas
- "USULAN PENELITIAN TERAPAN"
- "TENTANG"
- Judul penelitian (uppercase otomatis)
- Informasi pendanaan DIPA
- "Oleh:"
- Daftar tim peneliti (4 peneliti, urut nama):
  - [Nama Ketua] (NIDN: [NIDN])
  - [Nama Anggota 1] (NIDN: [NIDN])
  - [Nama Anggota 2] (NIDN: [NIDN])
  - [Nama Anggota 3] (NIDN: [NIDN])
- Logo Politeknik Negeri Malang
- "POLITEKNIK NEGERI MALANG"
- Bulan dan Tahun (uppercase otomatis)

## Troubleshooting

### Error saat build?
```bash
# Clean semua dan build ulang
make cleanall
make
```

### PDF tidak terupdate?
```bash
# Pastikan tidak ada proses latexmk yang masih berjalan
pkill -f latexmk
make cleanall
make
```

### Perlu bantuan?
Lihat file `README.md` untuk dokumentasi lengkap.
