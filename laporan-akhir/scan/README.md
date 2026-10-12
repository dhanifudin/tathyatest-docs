# Scan lampiran

Lampiran yang memerlukan scan hardcopy dibaca dari folder ini. Cukup salin file
PDF hasil scan dengan nama berikut (menimpa placeholder), lalu `make laporan`:

| File | Lampiran |
|------|----------|
| `d-pernyataan-keaslian.pdf` | D. Surat Pernyataan Keaslian |
| `f-sptjb.pdf` | F. SPTJB (yang sudah ditandatangani) |
| `i-kerjasama-mitra.pdf` | I. Surat Kerjasama Mitra |

File `*.pdf` dan `pages.json` di-gitignore (dokumen pribadi / hasil generate).
Jumlah halaman dihitung otomatis (`pdfinfo`) oleh `make scan-index`.
Lampiran yang tidak relevan: hapus `#include`-nya di `main.typ`.
