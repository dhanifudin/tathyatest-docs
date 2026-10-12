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
SUPPLEMENT_SRCS = supplement/sptjb.typ supplement/ringkasan-pkm.typ supplement/tkt.typ supplement/manual-book.typ supplement/form-hki.typ
SUPPLEMENT_PDFS = $(BUILD_DIR)/supplement-sptjb.pdf $(BUILD_DIR)/supplement-ringkasan-pkm.pdf $(BUILD_DIR)/supplement-tkt.pdf $(BUILD_DIR)/supplement-manual-book.pdf $(BUILD_DIR)/supplement-form-hki.pdf

.PHONY: supplement
supplement: $(SUPPLEMENT_PDFS)

$(BUILD_DIR)/supplement-%.pdf: supplement/%.typ supplement/common.typ | $(BUILD_DIR)
	typst compile --root . $< $@

# Buku panduan penggunaan (manual book) TathyaTest untuk pendaftaran Hak Cipta;
# tangkapan layar dan transkrip di supplement/assets/manual/.
.PHONY: manual-book
manual-book: $(BUILD_DIR)/supplement-manual-book.pdf

$(BUILD_DIR)/supplement-manual-book.pdf: $(wildcard supplement/assets/manual/*)

# Formulir permohonan pendaftaran ciptaan (HKI) Sentra KI Polinema, tata letak
# disalin dari docs/form-hki.docx; pencipta = dosen tim dari laporan-akhir/config.typ.
.PHONY: form-hki
form-hki: $(BUILD_DIR)/supplement-form-hki.pdf

.PHONY: laporan
laporan: supplement | $(BUILD_DIR)
	typst compile --root . $(LAPORAN_SRC) $(LAPORAN_PDF)
	@echo "PDF built successfully: $(LAPORAN_PDF)"

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
	@echo "  make form-hki     - Build formulir permohonan pendaftaran ciptaan (HKI)"
	@echo "  make cleanall     - Hapus semua file generated proposal termasuk PDF"
	@echo "  make rebuild      - Clean all dan build ulang proposal"
	@echo "  make laporan      - Build PDF laporan akhir (Typst), termasuk dokumen supplement"
	@echo "  make laporan-watch - Continuous build mode laporan akhir"
	@echo "  make laporan-view - Build dan buka PDF laporan akhir"
	@echo "  make supplement   - Build dokumen supplement saja (SPTJB, Ringkasan PKM, TKT)"
	@echo "  make paper-ieee          - Build paper/tathyatest-ieee.pdf with latexmk"
	@echo "  make paper-ieee-numbers  - Refresh paper/eval-numbers.tex from tt eval reports, then build"
	@echo "  make paper-juti          - Build paper/juti/tathyatest-juti.pdf with Typst (JUTI template)"
	@echo "  make paper-juti-numbers  - Refresh paper/juti/eval-numbers.typ from tt eval reports, then build"
	@echo "  make help         - Tampilkan help ini"
