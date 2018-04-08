TEX = pdflatex
BIB = bibtex

doc = 

build: $(doc)

$(doc): %: %.tex
	$(TEX) $@
	$(BIB) $@
	$(TEX) $@ >/dev/null 2>&1
	$(TEX) $@ >/dev/null 2>&1

distclean:
	$(RM) *.out *.aux *.log *.toc *.lof *.lot       # latex
	$(RM) *.nav *.snm *.vrb *.nav                   # beamer
	$(RM) *.bbl *.blg                               # bibtex
	$(RM) *.syntex.gz                               # synctex
	$(RM) *-eps-converted-to.pdf                    # epstopdf

clean: distclean
	$(RM) $(addsuffix .pdf,$(doc))

.PHONY: build distclean clean
