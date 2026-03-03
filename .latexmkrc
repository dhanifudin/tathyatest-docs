# Latexmk configuration for biblatex with biber
$pdf_mode = 1;                    # Generate PDF using pdflatex
$pdflatex = 'pdflatex -interaction=nonstopmode -synctex=1 %O %S';

# Configure biber for biblatex
$bibtex_use = 2;                  # Use biber

# Custom dependency for biber to handle outdir properly
add_cus_dep('bcf', 'bbl', 0, 'run_biber');

sub run_biber {
    my $base = shift;
    my $bcf = "$base.bcf";
    my $bbl = "$base.bbl";

    # Run biber
    system("biber", $base);

    return $?;
}

# Ensure generated files are tracked
push @generated_exts, 'bbl', 'bcf', 'blg', 'run.xml';
