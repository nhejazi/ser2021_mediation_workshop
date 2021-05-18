all: style site

site:
	Rscript -e "bookdown::clean_book(TRUE)"
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
	#rm -f *.log *.rds

pdf:
	Rscript -e "bookdown::clean_book(TRUE)"
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_document2')"

style:
	Rscript -e "styler::style_dir(filetype = 'rmd', recursive = FALSE)"

pdf2png:
	./img/pdf2png.sh

code:
	rm -f R_code/*.R
	R CMD BATCH purl.R
	rm purl.Rout .RData
