source=maude.tex
master=maude.pdf

srcbib=`{ls *.bib}
srcdot=`{ls *.dot}
srchet=`{ls *.het}
srcall=$srcbib $srcdot $srchet
genall=${srcdot:%.dot=%.pdf} \
       ${srchet:%.het=%.pp.tex}

temp=${source:%.tex=%.aux} \
     ${source:%.tex=%.bbl} \
     ${source:%.tex=%.blg} \
     ${source:%.tex=%.lof} \
     ${source:%.tex=%.log} \
     ${source:%.tex=%.out} \
     ${source:%.tex=%.toc} \
     ${source:%.tex=%.synctex.gz}

dotpdf=dot -Nfontname=Courier -Tpdf -Kdot
hettex=hets -o pp.tex
bibtex=bibtex -terse
pdftex=xelatex -interaction errorstopmode -file-line-error

all:V: $master

$master: $source $srcall $genall

%.pdf:Q: %.tex
	$pdftex $stem
	$bibtex $stem
	$pdftex $stem
	if grep -q 'Rerun to get cross-references right' $stem.log; then
		$pdftex $stem
	fi

%.pp.tex:Q: %.het
	$hettex $prereq
	if grep -q 'logic Maude' $prereq; then
		9 sam -d $target < pp.sam
	fi

%.pdf:Q: %.dot
	$dotpdf -o $target $prereq

Maude:Q:
	svn export -r 13000 https://svn-agbkb.informatik.uni-bremen.de/Hets/trunk/Maude

clean:QV:
	rm -f $temp

distclean:QV: clean
	rm -f $master $genall

open:QV: $master
	open -a Skim $master
