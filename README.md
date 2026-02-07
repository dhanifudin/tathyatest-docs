# Template Proposal Penelitian LaTeX - Politeknik Negeri Malang

Template LaTeX untuk proposal penelitian P3M Politeknik Negeri Malang sesuai dengan sistematika yang berlaku.

## Spesifikasi Format

- Kertas: A4
- Margin: 1.5 cm (semua sisi)
- Font: Times New Roman 12pt
- Spasi: 1.5
- Logo: Menggunakan logo Politeknik Negeri Malang
- Penomoran Halaman:
  - Halaman Cover: Tanpa nomor
  - Halaman Pengesahan, Daftar Isi, Ringkasan: Angka romawi kecil (i, ii, iii, ...)
  - BAB 1 hingga Lampiran: Angka arabic (1, 2, 3, ...)

## Struktur File

```
.
├── proposal.tex          # File utama
├── cover.tex            # Halaman cover
├── pengesahan.tex       # Halaman pengesahan
├── ringkasan.tex        # Ringkasan
├── bab1.tex             # BAB 1: Pendahuluan
├── bab2.tex             # BAB 2: Tinjauan Pustaka
├── bab3.tex             # BAB 3: Metode Penelitian
├── bab4.tex             # BAB 4: Biaya dan Jadwal
├── lampiran_a.tex       # Lampiran A: Justifikasi Anggaran
├── lampiran_b.tex       # Lampiran B: Organisasi Tim
├── lampiran_c.tex       # Lampiran C: Biodata
├── lampiran_d.tex       # Lampiran D: Surat Pernyataan
├── references.bib       # File daftar pustaka
├── images/
│   └── logo.png         # Logo Politeknik Negeri Malang
├── .latexmkrc           # Konfigurasi latexmk
├── Makefile             # Makefile untuk build
└── README.md            # File ini
```

## Cara Penggunaan

### Prasyarat

Pastikan Anda telah menginstall:
- LaTeX distribution (TeX Live, MiKTeX, atau MacTeX)
- latexmk
- biber (untuk bibliography)
- make (optional, untuk menggunakan Makefile)

### Build PDF

Ada beberapa cara untuk build PDF:

#### 1. Menggunakan Make (Recommended)

```bash
# Build PDF
make

# Build dan buka PDF
make view

# Continuous build mode (auto-recompile saat ada perubahan)
make watch

# Clean build files
make clean

# Clean semua files termasuk PDF
make cleanall

# Rebuild dari awal
make rebuild

# Tampilkan help
make help
```

#### 2. Menggunakan latexmk langsung

```bash
# Build PDF
latexmk -pdf -outdir=build proposal.tex

# Continuous preview mode
latexmk -pdf -pvc -outdir=build proposal.tex

# Clean
latexmk -c -outdir=build
```

#### 3. Manual (jika tidak ada latexmk)

```bash
pdflatex proposal.tex
biber proposal
pdflatex proposal.tex
pdflatex proposal.tex
```

### Output

File PDF hasil build akan berada di folder `build/proposal.pdf`

## Cara Mengisi Template

### 1. Konfigurasi Data Penelitian (proposal.tex)

**PENTING:** Edit bagian konfigurasi di `proposal.tex` (baris 70-121) untuk mengisi semua data penelitian Anda. Semua data akan otomatis muncul di halaman cover, pengesahan, dan lampiran.

**Informasi Umum:**
- `\judulPenelitian` - Judul penelitian (akan otomatis uppercase di cover)
- `\bidangPenelitian` - Bidang penelitian
- `\jenisPenelitian` - Jenis penelitian (default: "Penelitian Reguler Kompetisi")
- `\nomorSPDIPA` - Nomor SP DIPA
- `\lokasiPenelitian` - Lokasi penelitian
- `\lamaPenelitian` - Lama penelitian dalam bulan
- `\biayaDiusulkan` - Biaya yang diusulkan (tanpa titik/koma)
- `\bulanTahun` - Bulan dan tahun penelitian

**Tim Peneliti (1 Ketua + 3 Anggota):**
- Ketua Peneliti: `\ketuaNama`, `\ketuaNIDN`, `\ketuaJabatan`, `\ketuaProdi`, `\ketuaHP`, `\ketuaEmail`
- Anggota 1: `\anggotaSatuNama`, `\anggotaSatuNIDN`
- Anggota 2: `\anggotaDuaNama`, `\anggotaDuaNIDN`
- Anggota 3: `\anggotaTigaNama`, `\anggotaTigaNIDN`
- `\jumlahMahasiswa` - Jumlah mahasiswa yang terlibat

**Pejabat Pengesah:**
- `\kajurNama`, `\kajurNIP`, `\kajurJabatan`, `\kajurProdi`
- `\ketuaPTMNama`, `\ketuaPTMNIP`
- `\tanggalPengesahan`

### 2. Isi Konten Penelitian

**Ringkasan (ringkasan.tex)**
- Tulis ringkasan penelitian maksimal 1 halaman
- Tambahkan kata kunci yang relevan

**BAB 1-4 (bab1.tex - bab4.tex)**
- Isi setiap bagian sesuai dengan outline penelitian Anda
- Hapus bagian yang tidak diperlukan
- Tambah subsection sesuai kebutuhan

**Lampiran (lampiran_a.tex - lampiran_d.tex)**
- Lampiran A: Isi justifikasi anggaran dengan detail
- Lampiran B: Lengkapi susunan tim dan pembagian tugas
- Lampiran C: Lengkapi biodata tim peneliti
- Lampiran D: Surat pernyataan (otomatis menggunakan data dari konfigurasi)

**Daftar Pustaka (references.bib)**
- Tambahkan referensi menggunakan format BibTeX
- Gunakan citation style APA
- Cite di dalam dokumen dengan `\cite{key}`

## Tips

1. **Menambahkan Gambar**
   ```latex
   \begin{figure}[htbp]
       \centering
       \includegraphics[width=0.8\textwidth]{images/nama_gambar.png}
       \caption{Caption gambar}
       \label{fig:label}
   \end{figure}
   ```

2. **Menambahkan Tabel**
   ```latex
   \begin{table}[htbp]
   \centering
   \caption{Judul tabel}
   \begin{tabular}{|c|l|r|}
   \hline
   Kolom 1 & Kolom 2 & Kolom 3 \\
   \hline
   Data 1 & Data 2 & Data 3 \\
   \hline
   \end{tabular}
   \end{table}
   ```

3. **Sitasi**
   - Dalam teks: `\cite{key}`
   - Multiple citations: `\cite{key1,key2}`

4. **Cross-reference**
   - Label: `\label{sec:label}` atau `\label{fig:label}`
   - Reference: `\ref{sec:label}` atau `\ref{fig:label}`

## Troubleshooting

1. **Error: Font Times New Roman tidak ditemukan**
   - Pastikan package `mathptmx` terinstall
   - Atau gunakan `\usepackage{times}`

2. **Error: biber not found**
   - Install biber: `tlmgr install biber` (TeX Live)
   - Atau gunakan backend bibtex: ubah di proposal.tex

3. **PDF tidak terupdate**
   - Jalankan `make cleanall` kemudian `make`
   - Atau hapus folder build dan build ulang

## Lisensi

Template ini bebas digunakan dan dimodifikasi sesuai kebutuhan.

## Kontak

Untuk pertanyaan atau saran, silakan hubungi P3M Politeknik Negeri Malang.
