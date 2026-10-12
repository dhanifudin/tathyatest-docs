// Buku panduan (manual book) TathyaTest — lampiran pendaftaran Hak Cipta program
// komputer. Dikompilasi mandiri ke build/supplement-manual-book.pdf (Makefile target
// `manual-book`). Screenshot di supplement/assets/manual/ diambil dari eksekusi nyata
// `tt` 0.1.0 terhadap aplikasi contoh todo-blade; transkrip teks mentahnya disimpan
// berdampingan (transcript-*.txt). Isi dibatasi pada cara pakai; istilah teknis
// dibiarkan dalam bahasa Inggris supaya tidak ambigu.
#import "common.typ": laporan

#let versi = "0.1.0"
#let repo = "https://github.com/dhanifudin/tathyatest"
#let accent = rgb("#4f46e5")
#let accent-soft = rgb("#eef2ff")
#let ink = rgb("#1f2937")
#let muted = rgb("#6b7280")

// Nama tanpa gelar akademik, biar sampulnya enteng.
#let polos(nama) = nama.split(",").at(0).trim()
#let tim = (laporan.ketua.nama, ..laporan.anggota.map(a => a.nama)).map(polos)

#set page(paper: "a4", margin: 2cm)
#set text(font: ("Noto Sans", "DejaVu Sans"), size: 10.5pt, lang: "id", region: "ID", fill: ink)
#set par(justify: false, leading: 0.7em, spacing: 1.1em)
#set heading(numbering: "1.1.")
#show heading.where(level: 1): it => {
  v(0.9cm, weak: true)
  block(below: 0.5cm, sticky: true)[
    #text(size: 20pt, weight: "bold", fill: accent)[#if it.numbering != none [#counter(heading).display() ] #it.body]
  ]
}
#show heading.where(level: 2): it => { v(0.35cm, weak: true); block(below: 0.2cm, sticky: true, text(size: 13pt, weight: "bold")[#it]) }
#show heading.where(level: 3): it => { v(0.2cm, weak: true); block(below: 0.1cm, sticky: true, text(size: 11pt, weight: "bold")[#it]) }
#show raw.where(block: true): it => block(
  width: 100%, fill: rgb("#f8fafc"), stroke: 0.5pt + rgb("#e2e8f0"), inset: 9pt, radius: 5pt,
  text(size: 8.5pt, it),
)
#show raw.where(block: false): it => box(fill: rgb("#f1f5f9"), inset: (x: 3pt), outset: (y: 2.5pt), radius: 3pt, text(size: 9.2pt, it))
#show figure.caption: it => text(size: 9.5pt, fill: muted, it)
#show table: set text(size: 9.3pt)
#set table(stroke: (x: none, y: 0.5pt + rgb("#e2e8f0")), inset: 6pt)
#show table.cell.where(y: 0): it => { set text(weight: "bold", fill: accent); it }
#show link: it => text(fill: accent, it)
#set list(marker: text(fill: accent)[•])
#set enum(numbering: n => text(fill: accent, weight: "bold")[#n.])

#let fig(path, caption, width: 100%) = figure(image(path, width: width), caption: caption)
#let tip(body) = block(
  width: 100%, fill: accent-soft, stroke: (left: 3pt + accent), inset: (x: 10pt, y: 8pt), radius: 4pt,
  body,
)
#let pill(body) = box(fill: accent, inset: (x: 8pt, y: 4pt), radius: 20pt, text(fill: white, size: 9pt, weight: "bold", body))

// ---------------------------------------------------------------- sampul
#page(numbering: none, margin: 0pt, header: none, footer: none)[
  #place(top + left, rect(width: 100%, height: 47%, fill: accent-soft))
  #place(top + left, dx: 2cm, dy: 4.6cm)[
    #pill[Buku Panduan · versi #versi]
    #v(0.5cm)
    #text(size: 52pt, weight: "bold", fill: accent)[TathyaTest]
    #v(0.1cm)
    #block(width: 14cm, text(size: 15pt, fill: ink)[
      Bikin test Playwright dari aplikasi web yang sudah jalan, tanpa menulis script.
    ])
  ]
  #place(top + left, dx: 2cm, dy: 14.6cm)[
    #block(width: 15cm)[
      #text(size: 10.5pt, fill: muted)[
        Panduan ini menemani kamu dari instalasi sampai laporan hasil test: satu file
        konfigurasi, lima perintah, dan test suite untuk functional testing, regression
        testing, serta functional-availability monitoring aplikasi webmu.
      ]
    ]
    #v(1.4cm)
    #text(size: 9pt, weight: "bold", fill: accent)[TIM]
    #v(0.15cm)
    #for n in tim [#text(size: 11pt)[#n] \ ]
  ]
  #place(bottom + left, dx: 2cm, dy: -1.8cm)[
    #text(size: 9.5pt, fill: muted)[
      Jurusan Teknologi Informasi · Politeknik Negeri Malang · 2026 \
      #link(repo)[#repo]
    ]
  ]
]

#set page(
  numbering: "1",
  footer: context [
    #set text(size: 8.5pt, fill: muted)
    #h(1fr) halaman #counter(page).display() #h(1fr)
  ],
)
#counter(page).update(1)

// ---------------------------------------------------------------- daftar isi
#heading(numbering: none, outlined: false)[Daftar isi]
#outline(title: none, indent: 1.2em, depth: 2)

// ---------------------------------------------------------------- 1
= Pendahuluan

== Apa itu TathyaTest?

TathyaTest adalah command-line tool yang membuat script functional test untuk aplikasi web. Kamu cukup memberi tahu URL aplikasi yang sedang berjalan dan akun untuk setiap role pengguna. Sisanya dikerjakan TathyaTest:

+ login ke aplikasi sebagai setiap role lewat Chromium sungguhan (Playwright),
+ meng-crawl halaman yang bisa dijangkau dan mencatat form, field, link, button, table, dan HTML constraint-nya,
+ menurunkan access matrix antar-role (RBAC) dari perbedaan hasil crawl tiap role,
+ menulis Playwright spec (TypeScript atau JavaScript) dalam lima kategori: auth, forms, interactions, pagination, dan RBAC, pada tiga tier: positive, negative, dan edge,
+ menjalankannya di Chromium, Firefox, dan WebKit, lalu menyajikan HTML report.

Tidak ada LLM dan tidak perlu API key. Data isian yang terlihat realistis dibuat `@faker-js/faker` dengan seed yang bisa dikunci supaya hasilnya sama setiap kali. Aplikasi server-rendered (Laravel, Rails, Django, Spring) maupun single-page application sama-sama bisa, asalkan punya login form.

== Fitur utama

#table(
  columns: (3.6cm, 1fr),
  [Fitur], [Keterangan],
  [Crawl per role], [Login sekali per role, lalu menelusuri URL same-origin dengan batas depth dan jumlah halaman. Hasilnya ada di `crawl/<role>.json`.],
  [Deteksi login control], [Field username, password, dan submit button dikenali dari atribut HTML. Tidak perlu selector manual.],
  [Access matrix RBAC], [Route yang cuma bisa dibuka satu role menghasilkan test "allowed" untuk role itu dan test "blocked" untuk role lain.],
  [Test variant dari HTML constraint], [`required`, `type`, `minlength`/`maxlength`, `min`/`max`, `pattern`, `<option>`, pasangan `_confirmation`, dan unique field menurunkan negative dan edge case secara sistematis.],
  [Lima kategori spec], [`auth/`, `forms/`, `interactions/`, `pagination/`, `rbac/`, plus helper `support/tathya.ts` dan `manifest.json`.],
  [Read-only mode], [Setiap test bertanda `@read` atau `@write`. `--read-only` mengubah test suite jadi functional-availability monitor yang aman untuk staging atau production.],
  [Cross-browser], [Playwright project `<role>-chromium`, `<role>-firefox`, `<role>-webkit` dibuat otomatis.],
  [HTML report], [Hasil eksekusi dibuka dengan `tt report`, lengkap dengan step dan trace.],
)

== Alur kerja

Lima perintah, dijalankan berurutan.

#fig("/paper/diagrams/pipeline-overview.svg", [Pipeline TathyaTest: config → crawl per role → element model → Playwright spec → hasil eksekusi.], width: 92%)

```
tt init  →  tt crawl  →  tt generate  →  tt run  →  tt report
(wizard)    (per role)    (spec)          (Playwright)  (HTML report)
```

== Istilah yang dipakai

#table(
  columns: (3cm, 1fr),
  [Istilah], [Arti],
  [Role], [Satu pasangan username dan password di `auth.roles`. Setiap role di-crawl dan diuji terpisah.],
  [Tier], [`positive` (input valid), `negative` (input tak valid harus ditolak), `edge` (nilai batas, nilai panjang, unicode, whitespace).],
  [Kategori], [`auth`, `forms`/`crud`, `interactions`, `pagination`, `rbac`, yaitu nama subdirektori spec hasil generate.],
  [Oracle], [Aturan yang memutuskan pass/fail: error indicator yang terlihat (`oracle.errorSelector`), URL tujuan, atau response code.],
  [Tag], [Label Playwright di setiap test: `@positive`/`@negative`/`@edge`, `@auth`/`@crud`/`@rbac`/…, `@role:<role>`, `@read`/`@write`.],
)

// ---------------------------------------------------------------- 2
= Kebutuhan sistem

== Hardware

Komputer kerja biasa sudah cukup. Saran minimum: prosesor 2 core, RAM 4 GB (8 GB lebih nyaman karena tiga browser berjalan bergantian), disk kosong 2 GB untuk Node.js, dependency, dan browser binary Playwright (sekitar 1 GB), serta akses jaringan ke aplikasi target.

== Software

#table(
  columns: (4cm, 2.6cm, 1fr),
  [Komponen], [Versi], [Keterangan],
  [Sistem operasi], [Linux, macOS, Windows (WSL2)], [Diuji di Linux. Di Linux tanpa display, Xvfb dijalankan otomatis bila `DISPLAY` kosong.],
  [Node.js dan npm], [≥ 18 (diuji di 24.x)], [Runtime CLI dan Playwright. Version manager `asdf` didukung `make install`.],
  [Git], [terbaru], [Mengambil source code.],
  [GNU Make], [terbaru], [Menjalankan `make install` dan `make verify`.],
  [Browser Playwright], [sesuai `@playwright/test` ≥ 1.45], [Chromium, Firefox, WebKit; dipasang dengan `npx playwright install`.],
  [PHP 8.4 + Composer (opsional)], [8.4], [Hanya kalau mau menjalankan aplikasi contoh di `case-study/`.],
  [Nix (opsional)], [terbaru], [`shell.nix` menyediakan PHP, Composer, dan system library yang dibutuhkan browser.],
)

// ---------------------------------------------------------------- 3
= Instalasi

== Ambil source code

```bash
git clone https://github.com/dhanifudin/tathyatest.git
cd tathyatest
```

== Pasang CLI `tt`

`make install` memasang dependency di `generator/`, mengompilasi TypeScript ke `generator/dist/`, lalu me-link perintah `tt` ke bin path Node (npm `prefix/bin` atau direktori `asdf` yang aktif).

```bash
make install            # npm install + build + link `tt`
npx playwright install  # unduh Chromium, Firefox, WebKit
make verify             # typecheck, unit test, dan smoke `tt <perintah> --help`
```

Tanpa Make juga bisa:

```bash
cd generator
npm install
npm run build
npm link
```

Di Linux, system library untuk browser bisa dipasang dengan `npx playwright install-deps`, atau pakai `nix-shell` di root repository yang sudah menyertakannya.

== Cek instalasi

Setelah terpasang, `tt` bisa dipanggil dari direktori mana pun selama bin directory npm/asdf ada di `PATH`.

```bash
tt --version   # 0.1.0
tt --help
```

#fig("/supplement/assets/manual/term-tt-help.png", [Output `tt --help`: daftar perintah dan opsi global.])

== Uninstall

```bash
make uninstall   # melepas link `tt`
make clean       # menghapus hasil build
```

// ---------------------------------------------------------------- 4
= Konfigurasi

Semua perilaku TathyaTest diatur satu file YAML, secara default `tathya.config.yaml` di working directory. File lain bisa ditunjuk dengan opsi global `-c <path>`. Karena file ini memuat credential, Git mengabaikannya (`.gitignore`); yang disimpan di repository adalah file `*.example.yaml`.

== Konfigurasi paling kecil

Cuma `baseUrl` dan minimal satu role di `auth.roles` yang wajib. Key lain punya nilai default.

```yaml
baseUrl: http://127.0.0.1:8000
auth:
  roles:
    - { name: admin, username: admin@example.com, password: password }
```

== Referensi key konfigurasi

Kalau ada yang salah, pesannya mirip lint: menyebut path key yang bermasalah.

#table(
  columns: (4.6cm, 2.2cm, 1fr),
  [Key], [Default], [Arti],
  [`baseUrl`], [wajib], [URL aplikasi target, misalnya `http://127.0.0.1:8000`.],
  [`hooks.reset`], [`null`], [Endpoint `{ method: POST|GET|DELETE, path: /... }` yang mengembalikan data awal; dipanggil sebelum setiap test. Kosongkan kalau aplikasi tidak punya.],
  [`output.dir`], [`tests/generated`], [Direktori output spec.],
  [`output.language`], [`ts`], [`ts` (TypeScript) atau `js` (JavaScript).],
  [`coverage`], [`all`], [Tier yang dihasilkan: `positive`, `negative`, `edge`, atau `all`.],
  [`mode`], [`read-write`], [`read-only` menghasilkan hanya test non-mutating (lihat §5.8).],
  [`oracle.errorSelector`], [selector umum], [CSS selector yang menandakan validation error tampil. Default: `[aria-invalid="true"], [role=alert], .invalid-feedback, .is-invalid, .error-message, .field-error, .text-red-600, x-input-error p`.],
  [`auth.loginPath`], [`/login`], [Path halaman login.],
  [`auth.roles[]`], [wajib], [Daftar `{ name, username, password }`; minimal satu.],
  [`crawl.maxDepth`], [`3`], [Depth maksimum (dihitung dari segmen path).],
  [`crawl.maxPages`], [`100`], [Jumlah halaman maksimum per role.],
  [`crawl.include`], [`[]`], [Path tambahan yang selalu dikunjungi selain yang ditemukan dari DOM.],
  [`crawl.exclude`], [`[]`], [Prefix path yang tidak boleh dikunjungi, misalnya `/logout`.],
  [`crawl.inferRestRoutes`], [`true`], [Dari `/r/<id>/edit` atau `DELETE /r/<id>` ikut mengunjungi `/r/<id>`.],
  [`data.fields`], [`{}`], [Nilai valid yang dipatok per nama field (selain itu Faker yang mengisi).],
  [`data.defaults`], [`{}`], [Nilai valid cadangan per input type (`text`, `email`, `number`, `date`, …).],
  [`data.unique`], [`[]`], [Field dengan unique rule di server → negative case nilai duplikat.],
  [`data.duplicates`], [`{}`], [Nilai yang sudah ada, dipakai negative case duplikat.],
  [`data.requiredFields`], [`[]`], [Memaksa negative case "required-empty" untuk field yang tidak terdeteksi dari HTML.],
  [`data.confirmFields`], [`[]`], [Pasangan `*_confirmation` tambahan.],
  [`data.faker.locale`], [`en`], [Locale Faker, misalnya `id`.],
  [`data.faker.seed`], [`null`], [Integer supaya data isian bisa direproduksi.],
  [`evaluation.outDir`], [`metrics`], [Direktori report `tt eval`.],
  [`evaluation.repeat`], [`1`], [Berapa kali `tt eval` mengulang eksekusi untuk mengukur flake rate dan durasi.],
)

Key `evaluation.*` lainnya (opsional, hanya untuk `tt eval`) dijelaskan lewat komentar di file contoh pada Lampiran B.

== File contoh di repository

#table(
  columns: (6.2cm, 1fr),
  [File], [Untuk apa],
  [`tathya.config.example.yaml`], [Referensi generik dengan komentar di setiap key (dilampirkan utuh di Lampiran B).],
  [`tathya.blade.` \ `config.example.yaml`], [Aplikasi contoh Laravel Blade di port 8000.],
  [`tathya.inertia-react.` \ `config.example.yaml`], [Aplikasi contoh Laravel Inertia/React di port 8001.],
  [`tathya.saucedemo.config.yaml`], [Aplikasi publik SauceDemo (tanpa `hooks`, `loginPath: /`, `errorSelector: '[data-test="error"]'`).],
)

// ---------------------------------------------------------------- 5
#pagebreak(weak: true)
= Panduan langkah demi langkah

Bab ini memperagakan alur lengkap terhadap aplikasi contoh _todo-blade_ (Laravel Breeze, Blade) yang ikut di repository. Semua screenshot diambil dari eksekusi nyata TathyaTest versi #versi.

== Siapkan aplikasi target

Aplikasi target harus sudah jalan dan bisa dijangkau di `baseUrl` sebelum `tt crawl`. Untuk aplikasi contoh Blade:

```bash
nix-shell case-study/todo-blade/shell.nix     # menyediakan PHP 8.4 + Composer
cd case-study/todo-blade
composer install
cp .env.example .env
php artisan key:generate
touch database/database.sqlite
php artisan migrate:fresh --seed
php artisan serve                              # http://127.0.0.1:8000
```

Akun hasil seed: `admin@example.com` dan `user@example.com`, password-nya `password`. Role _admin_ bisa membuka `/admin/users`; role _user_ mendapat 403 di sana. Aplikasi ini juga punya `POST /__testing/reset` untuk mengembalikan data awal.

#fig("/supplement/assets/manual/app-login.png", [Halaman login aplikasi contoh. Login control-nya dikenali otomatis.], width: 80%)

#fig("/supplement/assets/manual/app-todos.png", [Halaman daftar todo (role _admin_): search form GET, table, action link, dan pagination semuanya jadi sumber test case.], width: 80%)

#fig("/supplement/assets/manual/app-todos-create.png", [Form create todo. Constraint `required`, `type=email`, `maxlength`, `<select>`, dan pasangan confirmation diturunkan jadi test variant.], width: 80%)

== Buat project dengan `tt init`

`tt init` adalah wizard interaktif yang membuat direktori project (namanya diubah jadi slug) berisi `tathya.config.yaml` dan direktori `tests/generated/`. Pertanyaannya berurutan: nama project, URL/domain, login path, lalu untuk setiap role: nama role, username, password, dan "tambah role lain?"; kemudian bahasa spec, locale Faker, seed Faker, dan path endpoint reset data. Tekan Enter untuk menerima nilai default yang ditampilkan.

```bash
tt init
```

#fig("/supplement/assets/manual/term-tt-init.png", [Sesi `tt init` untuk project _todo-blade-uji_ dengan dua role.])

File konfigurasi yang dihasilkan sesi di atas:

#raw(read("/supplement/assets/manual/tathya.config.init.yaml"), lang: "yaml", block: true)

#tip[`tt crawl` dan `tt generate` bisa dijalankan langsung di dalam direktori project hasil wizard; output `crawl/` dan `output.dir` ditulis relatif terhadap working directory. Tapi `tt run` memanggil `playwright test`, yang membaca `playwright.config.ts` milik repository TathyaTest. Jadi pada versi #versi, alur lengkap dijalankan dari direktori hasil clone TathyaTest. Tunjuk config project dengan opsi global `-c`, ditulis *sebelum* nama perintah:

```bash
cd tathyatest
tt -c todo-blade-uji/tathya.config.yaml crawl
tt -c todo-blade-uji/tathya.config.yaml generate
tt -c todo-blade-uji/tathya.config.yaml run --project admin-chromium
```

Kalau `-c` ditulis *setelah* `run`, opsi itu diteruskan ke Playwright sebagai config file-nya dan eksekusi gagal dengan `SyntaxError` pada file YAML. Cara paling gampang: salin `tathya.config.yaml` hasil wizard ke root repository, jadi `-c` tidak perlu.]

== Crawl aplikasi dengan `tt crawl`

`tt crawl` membuka Chromium, login sebagai setiap role, lalu menelusuri URL same-origin yang ditemukan dari DOM hasil render. Output-nya `crawl/<role>.json`. Perintah ini diam kalau berhasil dan berhenti cepat dengan pesan jelas kalau aplikasi di `baseUrl` tidak merespons atau login gagal.

```bash
tt crawl
ls -lh crawl/
```

#fig("/supplement/assets/manual/term-tt-crawl.png", [`tt crawl` menghasilkan satu element model per role.])

Isinya per halaman: form beserta field dan constraint-nya, link, button, dan table. Cuplikan `crawl/admin.json` (dipersingkat):

```json
{
  "baseUrl": "http://127.0.0.1:8000", "role": "admin",
  "pages": [
    { "url": "/todos", "title": "TathyaTodo",
      "forms": [
        { "action": "/todos", "method": "GET", "crudOp": "search",
          "fields": [
            { "name": "search", "type": "search", "label": "Search todos", "required": false,
              "constraints": { "maxlength": 255 },
              "locator": { "strategy": "label", "value": "Search todos" } } ],
          "submit": { "text": "Apply", "locator": { "strategy": "role", "value": "button:Apply" } } } ],
      "links": [ ... ], "buttons": [ ... ], "tables": [ ... ] } ]
}
```

Kalau ada halaman yang tidak muncul di sini, tambahkan path-nya ke `crawl.include` atau naikkan `crawl.maxDepth`/`crawl.maxPages`.

== Generate spec dengan `tt generate`

`tt generate` membaca `crawl/*.json`, membangun access matrix antar-role, menurunkan input variant dari HTML constraint, lalu menulis spec ke `output.dir`. Kalau hasil crawl hilang atau lebih lama dari file config, `tt generate` menjalankan `tt crawl` dulu; `--fresh` memaksa crawl ulang.

```bash
tt generate            # atau: tt generate --fresh
tree -L 2 tests/generated
```

#fig("/supplement/assets/manual/term-tt-generate.png", [Output `tt generate`: satu spec file per bentuk route, dikelompokkan per kategori, plus `support/tathya.ts` dan `manifest.json`.])

Setiap route, form, dan field yang ditemukan crawler mendapat test positive, negative, dan edge sesuai `coverage`. Contoh spec auth `tests/generated/auth/login.spec.ts` (dipersingkat):

```ts
// Generated by `tt generate` — do not edit; this file is overwritten on every run.
import { test, performLogin, assertLoggedIn, assertLoginRejected, assertLoggedOut }
  from '../support/tathya.js';

test.describe("admin login", () => {
  test.skip(({ role }) => role !== "admin", "runs under the admin project only");

  test("admin logs in with valid credentials",
    { tag: ["@positive", "@auth", "@role:admin", "@read"] }, async ({ page }) => {
    await test.step("Log in as admin@example.com",
      () => performLogin(page, "admin@example.com", "password"));
    await test.step("Expect to be logged in", () => assertLoggedIn(page));
  });

  test("admin is rejected with a wrong password",
    { tag: ["@negative", "@auth", "@role:admin", "@write"] }, async ({ page }) => {
    await test.step("Log in as admin@example.com",
      () => performLogin(page, "admin@example.com", "password-wrong"));
    await test.step("Expect the login to be rejected", () => assertLoginRejected(page));
  });
});
```

Setiap test juga tercatat di `tests/generated/manifest.json`, yang memudahkan filtering dan reporting:

```json
{
  "id": "t0006", "title": "admin logs out", "category": "auth", "tier": "positive",
  "role": "admin", "route": "/dashboard", "targetForm": "POST:/logout",
  "targetField": null, "constraintKind": null, "assertionCount": 1,
  "locatorStrategy": "css", "faultClass": "auth", "mutating": true
}
```

== Jalankan test dengan `tt run`

`tt run` menjalankan `playwright test` atas `tests/generated/` dengan Playwright config bawaan repository: tiga project per role (`<role>-chromium`, `<role>-firefox`, `<role>-webkit`), satu worker, timeout 60 detik per test, reporter `list` di terminal dan `html` untuk report. Sebelum test pertama, global setup login sekali per role dan menyimpan session-nya ke `storageState/<role>.json`.

Argumen tambahan diteruskan apa adanya ke Playwright, jadi filtering memakai opsi Playwright biasa:

```bash
tt run                                        # semua project dan semua test
tt run --project admin-chromium               # satu role, satu browser
tt run --project admin-chromium --grep @auth   # hanya kategori auth
tt run --grep "@negative|@edge"               # hanya tier negative dan edge
tt run --grep-invert @rbac                    # semua kecuali RBAC
tt run --reporter=list,html                   # terminal + HTML report
```

#fig("/supplement/assets/manual/term-tt-run.png", [Bagian akhir output `tt run --project admin-chromium`: reporter `list` mencetak setiap test beserta step dan tag-nya, lalu ringkasan (test role _user_ di-skip karena hanya jalan di project _user-\*_).])

#tip[Kalau `--reporter` tidak diberikan, `tt run` menetapkan `--reporter=list`, dan opsi ini menggantikan daftar reporter di `playwright.config.ts`, jadi HTML report *tidak* diperbarui. Supaya `tt report` menampilkan report yang segar, sertakan `--reporter=list,html` (atau `--reporter=html`).]

== Lihat report dengan `tt report`

`tt report` membuka HTML report Playwright dari eksekusi terakhir (`playwright-report/index.html`) di browser. Isinya ringkasan pass/fail, filter per project dan tag, step (`test.step`) setiap test, serta Playwright trace untuk test yang gagal lalu di-retry.

```bash
tt run --project admin-chromium --reporter=list,html
tt report
```

#fig("/supplement/assets/manual/report-overview.png", [HTML report Playwright: ringkasan hasil per spec file.], width: 90%)

#fig("/supplement/assets/manual/report-detail.png", [Detail satu test case: step dan durasinya.], width: 90%)

== Semua sekaligus dengan `tt all`

`tt all` merangkai `crawl → generate → run` dalam satu perintah, pas untuk CI. `--fresh` memaksa crawl ulang; `-c` memilih config.

```bash
tt all
tt -c tathya.inertia-react.config.yaml all --fresh
```

== Read-only mode untuk functional-availability monitoring

Setiap test bertanda `@write` kalau eksekusinya bisa mengubah data aplikasi (form POST/PUT/PATCH/DELETE beserta variant-nya, klik button generik, dan test wrong password), atau `@read` kalau tidak (login, membuka setiap route, mengikuti link, pagination, search form GET). `--read-only` pada `generate`/`all` (atau `mode: read-only` di config) menghasilkan status sweep atas seluruh permukaan aplikasi yang aman diarahkan ke staging atau production: test memakai stored session, tidak pernah memanggil `hooks.reset`, dan memastikan setiap halaman yang dibuka masih hidup. Jadwalkan lewat cron atau CI dan suite ini jadi feature monitor: setiap route, link, pagination, dan search dicek untuk setiap role.

```bash
tt run --read-only      # jalankan suite yang ada, skip semua test @write
tt run --write-only     # kebalikannya; tidak bisa digabung dengan --read-only
tt all --read-only      # crawl + generate HANYA test @read, lalu jalankan

*/15 * * * * cd /srv/tathya && tt all --read-only -c tathya.prod.yaml   # contoh cron
```

#fig("/supplement/assets/manual/term-tt-run-readonly.png", [`tt run --read-only --project admin-chromium --grep @auth`: test `@write` di-skip.])

== Ukur mutu test suite dengan `tt eval`

`tt eval` menjalankan seluruh alur beberapa kali dan menulis `metrics/report.json` serta `metrics/report.md` (lokasi diatur `evaluation.outDir`). Isinya: seberapa banyak route, form, field, dan sel access matrix hasil crawl yang tersentuh test; mutu test suite (assertion density, rasio locator rapuh); flake rate dan durasi crawl/generate/execute; serta code coverage dan fault detection aplikasi, yang hanya aktif kalau aplikasi menjawab endpoint `/__testing/*` seperti aplikasi contoh.

```bash
tt eval                          # evaluasi config ini
tt eval --repeat 3               # ulang eksekusi 3x
tt eval --no-faults --no-coverage   # lewati fault injection dan code coverage
```

// ---------------------------------------------------------------- 6
= Output program

#table(
  columns: (5cm, 1fr),
  [Path], [Isi],
  [`crawl/<role>.json`], [Element model per role.],
  [`tests/generated/auth/`], [Test login valid, wrong password, logout, per role.],
  [`tests/generated/forms/`], [Test form: submit valid, negative dan edge variant per field, duplikat, confirmation.],
  [`tests/generated/interactions/`], [Klik button, link, toggle status, file upload, search/filter GET.],
  [`tests/generated/pagination/`], [Navigasi halaman next/previous dan parameter `page`.],
  [`tests/generated/rbac/`], [Route allowed/blocked per role berdasarkan access matrix.],
  [`tests/generated/support/tathya.ts`], [Fixture dan helper bersama: `performLogin`, `assertLoggedIn`, `resetAppData`, `expectRouteAllowed/Blocked`, dan lainnya.],
  [`tests/generated/manifest.json`], [Satu entri per test: id, title, category, tier, role, route, target field, constraint kind, jumlah assertion, locator strategy, mutating atau tidak.],
  [`storageState/<role>.json`], [Login session tersimpan hasil global setup.],
  [`playwright-report/`], [HTML report eksekusi terakhir (dibuka `tt report`).],
  [`test-results/`], [Artefak mentah Playwright: trace, screenshot, video kalau diaktifkan.],
  [`metrics/report.{json,md}`], [Report `tt eval`.],
)

#tip[Direktori `crawl/`, `tests/generated/`, dan `metrics/` ditulis ulang di setiap eksekusi. Jangan di-edit manual; baris pertama setiap spec hasil generate mengingatkan hal ini. Kalau ada yang perlu disesuaikan, ubah file config-nya, bukan spec output-nya.]

// ---------------------------------------------------------------- 7
= Kalau ada masalah

#table(
  columns: (4.2cm, 5cm, 1fr),
  [Gejala], [Penyebab], [Penanganan],
  [`tt crawl` berhenti dengan pesan aplikasi tidak bisa dijangkau], [Aplikasi di `baseUrl` belum jalan atau port salah.], [Jalankan aplikasi target (misalnya `php artisan serve`), periksa `baseUrl`.],
  [Crawler gagal setelah mencoba login ("still on a login-like page")], [Credential salah, `auth.loginPath` keliru, atau login control tidak terdeteksi.], [Periksa `auth.roles` dan `auth.loginPath`; pastikan field password bertipe `password` dan submit button bertipe `submit`.],
  [`Could not find the installed Playwright binary. Re-run make install`], [Dependency `generator/` belum terpasang atau link `tt` menunjuk build lama.], [Jalankan `make install` lagi.],
  [Browser tidak bisa dibuka di server tanpa GUI], [Tidak ada `DISPLAY`.], [Tidak perlu apa-apa: Playwright config menjalankan Xvfb `:99` otomatis; pastikan paket `xvfb` terpasang.],
  [WebKit gagal pada HTTPS ("TLS support is not available")], [Module GIO tidak ditemukan.], [Playwright config mengarahkan `GIO_MODULE_DIR` ke `/usr/lib/gio/modules`; pastikan paket `glib-networking` terpasang atau pakai `nix-shell`.],
  [Error config dilaporkan seperti pesan lint], [Key atau tipe nilai tidak sesuai schema.], [Perbaiki key yang disebut; bandingkan dengan `tathya.config.example.yaml`.],
  [Spec tidak mencerminkan perubahan aplikasi], [Hasil crawl lama.], [`tt generate --fresh` atau `tt all --fresh`.],
  [Halaman tertentu tidak ikut di-crawl], [Tidak ada link ke sana dari DOM, atau melebihi batas depth/halaman.], [Tambahkan path ke `crawl.include`, atau naikkan `crawl.maxDepth`/`crawl.maxPages`.],
  [`--read-only and --write-only exclude each other`], [Kedua opsi diberikan sekaligus.], [Pakai salah satu.],
  [`tt run -c ...` gagal dengan `SyntaxError` pada file YAML], [Opsi `-c` setelah `run` diteruskan ke Playwright sebagai config file-nya.], [Tulis opsi global sebelum nama perintah: `tt -c <path> run ...`.],
  [`tt report` menampilkan hasil eksekusi lama], [`tt run` tanpa `--reporter` memakai `--reporter=list`, yang menggantikan HTML reporter dari config.], [Jalankan `tt run ... --reporter=list,html` sebelum `tt report`.],
  [Test form gagal padahal validation error tampil], [Error selector aplikasi tidak termasuk dalam `oracle.errorSelector`.], [Tambahkan error selector aplikasi ke `oracle.errorSelector`.],
  [Negative case untuk server rule (unique, confirmation) tidak dihasilkan], [Rule tidak terlihat di HTML.], [Nyatakan lewat `data.unique`, `data.duplicates`, `data.confirmFields`, `data.requiredFields`.],
  [`tt eval` melewati code coverage atau fault detection], [Aplikasi tidak menjawab endpoint `/__testing/*`.], [Wajar untuk aplikasi biasa; metrik lain tetap dihitung.],
)

// ---------------------------------------------------------------- 8
= Batasan

Beberapa hal memang di luar jangkauan versi ini:

- Server-side validation rule yang tidak tampak di HTML (custom rule, closure rule, logika `FormRequest`) tidak bisa disimpulkan otomatis. Beri petunjuknya lewat `data.unique`, `data.duplicates`, `data.confirmFields`, dan `data.requiredFields`.
- Security/injection testing, performance testing, dan aplikasi mobile/native tidak dicakup.
- Aplikasi harus punya login form berbasis username dan password. Alur OAuth, OTP, atau CAPTCHA belum didukung.
- Crawl terbatas pada URL same-origin dan tunduk pada `crawl.maxPages`/`crawl.maxDepth`.

// ---------------------------------------------------------------- 9
= Penutup

Dengan URL aplikasi dan akun tiap role, TathyaTest memberimu test suite berupa Playwright spec standar: bisa dibaca, di-version, dan dijalankan di CI mana pun. Source code, issue, dan update ada di #link(repo)[#repo]. Selamat mencoba.

// ---------------------------------------------------------------- lampiran
#pagebreak(weak: true)
#heading(numbering: none)[Lampiran A: Ringkasan perintah]

#table(
  columns: (5.2cm, 1fr),
  [Perintah], [Fungsi],
  [`tt`], [Menampilkan help.],
  [`tt --version`], [Menampilkan versi (#versi).],
  [`tt -c <path> <perintah>`], [Opsi global: memakai config file selain `tathya.config.yaml`.],
  [`tt init`], [Wizard pembuatan direktori project dan `tathya.config.yaml`.],
  [`tt crawl`], [Crawl aplikasi sekali per role → `crawl/<role>.json`.],
  [`tt generate [--fresh] [--read-only]`], [Generate Playwright spec → `output.dir`; crawl ulang kalau hasil crawl hilang/usang; `--fresh` memaksa; `--read-only` hanya test non-mutating.],
  [`tt run [--read-only | --write-only] [argumen playwright...]`], [Menjalankan spec; argumen lain diteruskan ke `playwright test` (`--project`, `--grep`, `--grep-invert`, `--reporter`, `--headed`, …).],
  [`tt report`], [Membuka HTML report eksekusi terakhir.],
  [`tt all [--fresh] [--read-only]`], [`crawl` → `generate` → `run`.],
  [`tt eval [--repeat <n>] [--no-faults] [--no-coverage]`], [Evaluasi mutu test suite → `metrics/report.{json,md}`.],
  [`make install` / `make verify` / `make uninstall` / `make clean`], [Target instalasi dan verifikasi di repository.],
)

Tag yang bisa dipakai di `--grep`: `@positive`, `@negative`, `@edge`; `@auth`, `@crud`, `@interaction`, `@pagination`, `@rbac`; `@role:<role>`; `@read`, `@write`.

#pagebreak(weak: true)
#heading(numbering: none)[Lampiran B: Config file referensi]

Isi `tathya.config.example.yaml` dari repository, versi #versi:

#raw(read("/supplement/assets/manual/tathya.config.example.yaml"), lang: "yaml", block: true)
