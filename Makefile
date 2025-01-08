.PHONY: build check document install vignettes

build: document
	cd work && R CMD build ../

check: build
	cd work && R CMD check `ls codelist*.tar.gz | sort | tail -n 1`

document:
	R -e "roxygen2::roxygenise()"

vignettes: build
	cd work && tar -xzf `ls codelist*.tar.gz | sort | tail -n 1` && \
	  rm -r -f ../inst/doc && \
	  mkdir -p ../inst && \
	  cp -r codelist/inst/doc ../inst

install: build
	R CMD INSTALL `ls work/codelist*.tar.gz | sort | tail -n 1` 

readme:
	R -e 'library(simplermarkdown);options(md_formatter=format_copypaste);mdweave("README_source.md", "README.md", cmd2 = "pandoc %1$$s -t gfm -o %2$$s %3$$.0s")'

