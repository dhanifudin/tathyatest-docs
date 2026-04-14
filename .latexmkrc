# Latexmk configuration for biblatex with biber
$pdf_mode = 1;                    # Generate PDF using pdflatex
$pdflatex = 'pdflatex -interaction=nonstopmode -synctex=1 %O %S';

# Tell latexmk we're using biblatex with biber
$biblatex = 1;
$biber = 'biber %O %S';

# Ensure generated files are tracked
push @generated_exts, 'bbl', 'bcf', 'blg', 'run.xml';
