#let fig(path, caption, width: 100%) = figure(
  image(path, width: width),
  caption: caption,
  numbering: n => [#numbering("A", counter(heading).get().first()).#n],
)

= DOKUMEN PROTOTYPE <lampiran-j>

Prototipe TathyaTest berupa CLI `tt` (TypeScript/Node.js dengan Playwright). Buku panduan penggunaan lengkap disusun sebagai dokumen terpisah (manual book); ringkasannya diberikan di bawah ini.

== Tautan Repositori

Kode sumber TathyaTest tersedia di #link("https://github.com/dhanifudin/tathyatest")[github.com/dhanifudin/tathyatest].

== Cara Penggunaan

+ *Instalasi.* Unduh kode sumber lalu pasang CLI `tt` beserta browser Playwright (Chromium, Firefox, WebKit):
  ```bash
  git clone https://github.com/dhanifudin/tathyatest.git
  cd tathyatest
  make install
  npx playwright install
  tt --version
  ```
+ *Siapkan aplikasi target.* Aplikasi yang diuji harus sudah berjalan dan dapat dijangkau pada `baseUrl`.
+ *Buat project.* `tt init` membuka wizard interaktif yang menghasilkan `tathya.config.yaml` (URL aplikasi, login path, dan akun per role).
+ *Crawl.* `tt crawl` login sebagai setiap role dan menelusuri DOM hasil render menjadi model elemen per role (`crawl/<role>.json`).
+ *Generate.* `tt generate` membangun matriks akses antar-role dan menghasilkan spesifikasi test case Playwright di `tests/generated/`.
+ *Jalankan.* `tt run` mengeksekusi test lintas role dan browser, misalnya `tt run --project admin-chromium`.
+ *Report.* `tt report` membuka laporan HTML hasil eksekusi terakhir. Seluruh langkah crawl, generate, dan run dapat dijalankan sekaligus dengan `tt all`.

#fig("/supplement/assets/manual/term-tt-init.png", [Sesi `tt init` untuk membuat konfigurasi project.], width: 85%)

#fig("/supplement/assets/manual/term-tt-run.png", [Hasil eksekusi `tt run --project admin-chromium`.], width: 85%)

#fig("/supplement/assets/manual/report-overview.png", [Laporan HTML hasil eksekusi test case.], width: 85%)
