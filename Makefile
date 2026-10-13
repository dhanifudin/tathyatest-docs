# Makefile untuk build proposal penelitian LaTeX

# Variables
MAIN = proposal
BUILD_DIR = build
PDF = $(BUILD_DIR)/$(MAIN).pdf

# Default target
.PHONY: all
all: $(PDF)

# Build PDF using latexmk with manual biber orchestration
$(PDF): $(MAIN).tex | $(BUILD_DIR)
	@echo "Building PDF..."
	latexmk -pdf -outdir=$(BUILD_DIR) $(MAIN).tex -f || true
	biber $(BUILD_DIR)/$(MAIN)
	latexmk -pdf -g -outdir=$(BUILD_DIR) $(MAIN).tex
	@echo "PDF built successfully: $(PDF)"

# Build and open PDF
.PHONY: view
view: $(PDF)
	@echo "Opening PDF with zathura..."
	zathura $(PDF) &

# Continuous build mode (auto-recompile on changes)
.PHONY: watch
watch:
	@echo "Starting continuous build mode..."
	@echo "Press Ctrl+C to stop"
	latexmk -pdf -pvc -outdir=$(BUILD_DIR) $(MAIN).tex

# Clean build files
.PHONY: clean
clean:
	@echo "Cleaning build files..."
	latexmk -c -outdir=$(BUILD_DIR)
	@echo "Build files cleaned"

# Clean all generated files including PDF
.PHONY: cleanall
cleanall:
	@echo "Cleaning all generated files..."
	latexmk -C -outdir=$(BUILD_DIR)
	rm -rf $(BUILD_DIR)
	@echo "All generated files cleaned"

# Create build directory if it doesn't exist
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

# Force rebuild
.PHONY: rebuild
rebuild: cleanall all

# ---- Laporan Akhir (Typst) ----
LAPORAN_SRC = laporan-akhir/main.typ
LAPORAN_PDF = $(BUILD_DIR)/laporan-akhir.pdf

# ---- Supplement documents (Typst) -- embedded as PDFs into laporan-akhir's lampiran ----
SUPPLEMENT_SRCS = supplement/sptjb.typ supplement/ringkasan-pkm.typ supplement/pernyataan-keaslian.typ supplement/manual-book.typ supplement/form-hki.typ
SUPPLEMENT_PDFS = $(BUILD_DIR)/supplement-sptjb.pdf $(BUILD_DIR)/supplement-ringkasan-pkm.pdf $(BUILD_DIR)/supplement-pernyataan-keaslian.pdf $(BUILD_DIR)/supplement-manual-book.pdf $(BUILD_DIR)/supplement-form-hki.pdf

.PHONY: supplement
supplement: $(SUPPLEMENT_PDFS)

$(BUILD_DIR)/supplement-%.pdf: supplement/%.typ supplement/common.typ laporan-akhir/config.typ | $(BUILD_DIR)
	typst compile --root . $< $@

# Buku panduan penggunaan (manual book) TathyaTest untuk pendaftaran Hak Cipta;
# tangkapan layar dan transkrip di supplement/assets/manual/.
.PHONY: manual-book
manual-book: $(BUILD_DIR)/supplement-manual-book.pdf

$(BUILD_DIR)/supplement-manual-book.pdf: $(wildcard supplement/assets/manual/*)

# Formulir permohonan pendaftaran ciptaan (HKI) Sentra KI Polinema, tata letak
# disalin dari docs/form-hki.docx; pencipta = dosen tim dari laporan-akhir/config.typ.
# Draf Surat Pernyataan Keaslian laporan akhir untuk dicetak, ditandatangani, dan dipindai
# ke laporan-akhir/scan/d-pernyataan-keaslian.pdf (Lampiran C).
.PHONY: pernyataan
pernyataan: $(BUILD_DIR)/supplement-pernyataan-keaslian.pdf

.PHONY: form-hki
form-hki: $(BUILD_DIR)/supplement-form-hki.pdf

# Borang resmi TKT software (xlsx hasil isian, sumber yang dapat disunting) -> PDF.
# `make tkt-fill` mengisi ulang xlsx dari docs/pengukuran-tkt.zip (menimpa suntingan manual).
TKT_XLSX = supplement/assets/tkt-software.xlsx
TKT_PDF = $(BUILD_DIR)/tkt-software.pdf

.PHONY: tkt tkt-fill
tkt: $(TKT_PDF)

tkt-fill:
	python3 -I scripts/fill-tkt.py docs/pengukuran-tkt.zip $(TKT_XLSX)

$(TKT_PDF): $(TKT_XLSX) | $(BUILD_DIR)
	soffice --headless --convert-to pdf --outdir $(BUILD_DIR) $<
	printf '{"pages": %s}\n' "$$(pdfinfo $@ | awk '/^Pages:/{print $$2}')" > $(BUILD_DIR)/tkt-software.json

# Naskah JUTI (PDF) disematkan di lampiran G laporan akhir; file ini di-gitignore.
MANUSCRIPT_PDF = supplement/assets/tathyatest-juti-manuscript.pdf

.PHONY: manuscript
manuscript: $(MANUSCRIPT_PDF)

$(MANUSCRIPT_PDF): $(wildcard paper/juti/*.typ)
	typst compile --root paper paper/juti/main.typ $@

# Lampiran yang memerlukan scan hardcopy: salin PDF scan ke laporan-akhir/scan/<nama>.pdf.
# Placeholder dibuat otomatis hanya jika file belum ada; pages.json menyimpan jumlah halaman.
SCAN_DIR = laporan-akhir/scan
SCAN_NAMES = a-pengesahan d-pernyataan-keaslian f-sptjb
SCAN_PDFS = $(patsubst %,$(SCAN_DIR)/%.pdf,$(SCAN_NAMES))

.PHONY: scan-placeholders scan-index
scan-placeholders: $(SCAN_PDFS)

$(SCAN_DIR)/%.pdf:
	typst compile --root . --input label="$*" $(SCAN_DIR)/placeholder.typ $@

scan-index: scan-placeholders
	@printf '{' > $(SCAN_DIR)/pages.json; sep=''; \
	for n in $(SCAN_NAMES); do \
	  p=$$(pdfinfo $(SCAN_DIR)/$$n.pdf | awk '/^Pages:/{print $$2}'); \
	  printf '%s"%s": %s' "$$sep" "$$n" "$$p" >> $(SCAN_DIR)/pages.json; sep=', '; \
	done; printf '}\n' >> $(SCAN_DIR)/pages.json

.PHONY: laporan
laporan: supplement manuscript tkt scan-index | $(BUILD_DIR)
	typst compile --root . $(LAPORAN_SRC) $(LAPORAN_PDF)
	@echo "PDF built successfully: $(LAPORAN_PDF)"

# Build laporan saja (supplement dianggap sudah ada di build/)
.PHONY: laporan-quick
laporan-quick: manuscript tkt scan-index | $(BUILD_DIR)
	typst compile --root . $(LAPORAN_SRC) $(LAPORAN_PDF)
	@echo "PDF built successfully: $(LAPORAN_PDF)"

.PHONY: laporan-clean
laporan-clean:
	rm -f $(LAPORAN_PDF) $(SUPPLEMENT_PDFS)

.PHONY: laporan-watch
laporan-watch: supplement
	typst watch --root . $(LAPORAN_SRC) $(LAPORAN_PDF)

.PHONY: laporan-view
laporan-view: laporan
	zathura $(LAPORAN_PDF) &

# ---- Published papers (moved here from the tt implementation repo) ----
# TT_DIR points at the tt implementation repo checkout that `tt eval` writes
# metrics/report.json + metrics-saucedemo/report.json into; default assumes a
# sibling checkout (../tt). Override: make paper-ieee-numbers TT_DIR=/path/to/tt
TT_DIR ?= ../tt

# Typst isn't assumed to be on PATH; nix-shell -p typst provides a pinned-enough
# toolchain (tested with typst 0.13.1). `pacman -S typst` makes this wrapper
# unnecessary — the target still works either way since nix-shell just execs the
# command in a shell where `typst` resolves.
TYPST_RUN := nix-shell -p typst --run

.PHONY: paper-ieee paper-ieee-numbers paper-juti paper-juti-numbers
paper-ieee:
	cd paper && latexmk -pdf -interaction=nonstopmode tathyatest-ieee.tex

paper-ieee-numbers:
	TT_DIR=$(TT_DIR) node scripts/report-to-tex.mjs > paper/eval-numbers.tex
	$(MAKE) paper-ieee

paper-juti:
	$(TYPST_RUN) "typst compile --root paper paper/juti/main.typ paper/juti/tathyatest-juti.pdf"

paper-juti-numbers:
	TT_DIR=$(TT_DIR) node scripts/report-to-typst.mjs > paper/juti/eval-numbers.typ
	$(MAKE) paper-juti

# ---- Presentasi seminar hasil (Marp), tema meniru docs/TEMPLATE SEMINAR HASIL.pptx ----
# PPTX adalah luaran utama, dibuat dengan --pptx-editable (teks dan kotak dapat disunting
# di PowerPoint; eksperimental, memakai LibreOffice/soffice sehingga butuh ~1 menit).
# Gambar di slide harus PNG: SVG ikut dikonversi menjadi bentuk dan teksnya bertumpuk.
MARP = marp --html --theme presentasi/polinema.css --allow-local-files --browser chrome --browser-path "$$(which chromium)"
PRESENTASI_DEPS = presentasi/tathyatest.md presentasi/polinema.css presentasi/assets/pipeline-overview.png

.PHONY: presentasi presentasi-pdf presentasi-ppt
presentasi: $(BUILD_DIR)/presentasi.pptx
presentasi-pdf: $(BUILD_DIR)/presentasi.pdf

$(BUILD_DIR)/presentasi.pptx: $(PRESENTASI_DEPS) | $(BUILD_DIR)
	$(MARP) --pptx --pptx-editable presentasi/tathyatest.md -o $@

# Format .ppt lama untuk sistem unggah yang menolak .pptx. Memakai PPTX berbasis
# gambar (tanpa --pptx-editable) karena konversi PPTX editable -> .ppt menghilangkan
# latar dan kotak judul; slide menjadi gambar dan tidak bisa diedit.
presentasi-ppt: $(BUILD_DIR)/presentasi.ppt

$(BUILD_DIR)/presentasi.ppt: $(PRESENTASI_DEPS) | $(BUILD_DIR)
	$(MARP) --pptx presentasi/tathyatest.md -o $(BUILD_DIR)/presentasi-img.pptx
	soffice --headless --convert-to ppt --outdir $(BUILD_DIR) $(BUILD_DIR)/presentasi-img.pptx
	mv $(BUILD_DIR)/presentasi-img.ppt $@

$(BUILD_DIR)/presentasi.pdf: $(PRESENTASI_DEPS) | $(BUILD_DIR)
	$(MARP) presentasi/tathyatest.md -o $@

# Diagram untuk slide dirender ulang dari SVG makalah bila berubah.
presentasi/assets/pipeline-overview.png: paper/diagrams/pipeline-overview.svg
	rsvg-convert -w 1800 -b white $< -o $@

# Show help
.PHONY: help
help:
	@echo "Makefile untuk build proposal penelitian LaTeX dan laporan akhir Typst"
	@echo ""
	@echo "Target yang tersedia:"
	@echo "  make              - Build PDF proposal (default)"
	@echo "  make all          - Build PDF proposal"
	@echo "  make view         - Build dan buka PDF proposal"
	@echo "  make watch        - Continuous build mode proposal (auto-recompile)"
	@echo "  make clean        - Hapus file build proposal (kecuali PDF)"
	@echo "  make manual-book  - Build buku panduan (manual book) TathyaTest untuk HKI"
	@echo "  make pernyataan   - Build draf Surat Pernyataan Keaslian (untuk dicetak dan dipindai)"
	@echo "  make form-hki     - Build formulir permohonan pendaftaran ciptaan (HKI)"
	@echo "  make cleanall     - Hapus semua file generated proposal termasuk PDF"
	@echo "  make rebuild      - Clean all dan build ulang proposal"
	@echo "  make laporan      - Build PDF laporan akhir (Typst), termasuk dokumen supplement"
	@echo "  make tkt          - Konversi borang TKT (xlsx terisi) ke PDF; make tkt-fill isi ulang xlsx"
	@echo "  make manuscript   - Build PDF naskah JUTI untuk lampiran G laporan akhir"
	@echo "  make scan-index   - Siapkan placeholder + indeks halaman scan lampiran (laporan-akhir/scan/)"
	@echo "  make laporan-quick - Build laporan akhir saja (tanpa rebuild supplement)"
	@echo "  make laporan-clean - Hapus PDF laporan akhir dan supplement"
	@echo "  make laporan-watch - Continuous build mode laporan akhir"
	@echo "  make laporan-view - Build dan buka PDF laporan akhir"
	@echo "  make supplement   - Build dokumen supplement saja (SPTJB, Ringkasan PKM, TKT)"
	@echo "  make paper-ieee          - Build paper/tathyatest-ieee.pdf with latexmk"
	@echo "  make paper-ieee-numbers  - Refresh paper/eval-numbers.tex from tt eval reports, then build"
	@echo "  make paper-juti          - Build paper/juti/tathyatest-juti.pdf with Typst (JUTI template)"
	@echo "  make paper-juti-numbers  - Refresh paper/juti/eval-numbers.typ from tt eval reports, then build"
	@echo "  make presentasi   - Build slide seminar hasil (Marp) ke build/presentasi.pptx; presentasi-pdf untuk PDF"
	@echo "  make help         - Tampilkan help ini"
