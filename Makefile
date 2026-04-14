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

# Show help
.PHONY: help
help:
	@echo "Makefile untuk build proposal penelitian LaTeX"
	@echo ""
	@echo "Target yang tersedia:"
	@echo "  make          - Build PDF (default)"
	@echo "  make all      - Build PDF"
	@echo "  make view     - Build dan buka PDF"
	@echo "  make watch    - Continuous build mode (auto-recompile)"
	@echo "  make clean    - Hapus file build (kecuali PDF)"
	@echo "  make cleanall - Hapus semua file generated termasuk PDF"
	@echo "  make rebuild  - Clean all dan build ulang"
	@echo "  make help     - Tampilkan help ini"
