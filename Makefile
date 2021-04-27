all: style site

site:
	Rscript -e "bookdown::clean_book(TRUE)"
	Rscript -e "bookdown::render_book('index.Rmd', quiet=TRUE)"
	rm -f *# *.log

pdf:
	Rscript -e "bookdown::clean_book(TRUE)"
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"

style:
	Rscript -e "styler::style_dir(filetype = 'rmd', recursive = FALSE)"

pdf2png:
	./pdf2png.sh

code:
	rm -f R_code/*.R
	R CMD BATCH purl.R
	rm purl.Rout .RData
