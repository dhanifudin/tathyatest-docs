# Latexmk configuration for biblatex with biber
$pdf_mode = 1;        # Generate PDF using pdflatex
$bibtex_use = 2;      # Use biber instead of bibtex
$pdflatex = 'pdflatex -interaction=nonstopmode -synctex=1 %O %S';

# Run biber on .bcf files
add_cus_dep('bcf', 'bbl', 0, 'run_biber');

sub run_biber {
    my ($base) = @_;
    system("biber \"$base\"");
}
