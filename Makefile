# Makefile for the LaTeX documentation

# --- USER CONFIGURATION ---
# Define the components for the final PDF name.
# Edit these variables to change the output filename.
DOC_NAME = Doument_Title
VERSION = v1
MAIN_BASE   = main

# --- SYSTEM COMMANDS ---
LATEX  = pdflatex
BIBTEX = bibtex

# --- DERIVED VARIABLES & DIRECTORIES ---
# The final filename is constructed from the variables above.
DELIV_NAME = $(DOC_NAME)_$(VERSION)
FINAL_PDF  = $(DELIV_NAME).pdf
MAIN_SRC   = $(MAIN_BASE).tex
TEX_FILES  = $(wildcard sections/*.tex) $(wildcard style/*.tex) config.tex
BUILD_PDF  = build/$(MAIN_BASE).pdf

# --- RULES ---
all: $(FINAL_PDF)

$(FINAL_PDF): $(BUILD_PDF)
	@echo "--- Copying and renaming PDF to $(FINAL_PDF) ---"
	@cp $(BUILD_PDF) $(FINAL_PDF)
	@echo "--- Build complete. Final document is $(FINAL_PDF) ---"

$(BUILD_PDF): $(MAIN_SRC) $(TEX_FILES)
	@echo "--- [1/4] Compiling LaTeX (for BibTeX) ---"
	@$(LATEX) -output-directory=build $(MAIN_SRC)
	@if grep -q '\\citation' build/$(MAIN_BASE).aux; then \
		echo "--- [2/4] Running BibTeX ---"; \
		cd build && $(BIBTEX) $(MAIN_BASE) && cd ..; \
	else \
		echo "--- [2/4] Skipping BibTeX (no citations found) ---"; \
	fi
	@echo "--- [3/4] Compiling LaTeX (to include bibliography) ---"
	@$(LATEX) -output-directory=build $(MAIN_SRC)
	@echo "--- [4/4] Compiling LaTeX (to fix cross-references) ---"
	@$(LATEX) -output-directory=build $(MAIN_SRC)

clean:
	@echo "--- Cleaning up project directory ---"
	@rm -rf build
	@rm -f $(FINAL_PDF)
	@echo "Done."

$(BUILD_PDF): | build

build:
	@mkdir -p build

.PHONY: all clean
