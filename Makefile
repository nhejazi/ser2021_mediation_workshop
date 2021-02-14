all: style book

book:
	Rscript -e "bookdown::clean_book(TRUE)"
	Rscript -e "bookdown::render_book('index.Rmd', quiet=TRUE)"

style:
	Rscript -e "styler::style_dir(filetype = 'rmd')"
