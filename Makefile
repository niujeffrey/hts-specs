all: pdf

PDFS =	BCFv1_qref.pdf \
	BCFv2_qref.pdf \
	BEDv1.pdf \
	CRAMv2.1.pdf \
	CRAMv3.pdf \
	crypt4gh.pdf \
	CSIv1.pdf \
	SAMv1.pdf \
	SAMtags.pdf \
	tabix.pdf \
	VCFv4.1.pdf \
	VCFv4.2.pdf \
	VCFv4.3.pdf \
	VCFv4.4.draft.pdf

pdf: $(PDFS:%=new/%)

%.pdf: new/%.pdf
	cp $^ $@

new/BEDv1.pdf    diff/BEDv1.pdf:    BEDv1.tex    new/BEDv1.ver
new/CRAMv2.1.pdf diff/CRAMv2.1.pdf: CRAMv2.1.tex new/CRAMv2.1.ver
new/CRAMv3.pdf   diff/CRAMv3.pdf:   CRAMv3.tex   new/CRAMv3.ver
new/crypt4gh.pdf diff/crypt4gh.pdf: crypt4gh.tex new/crypt4gh.ver
new/SAMv1.pdf    diff/SAMv1.pdf:    SAMv1.tex    new/SAMv1.ver
new/SAMtags.pdf  diff/SAMtags.pdf:  SAMtags.tex  new/SAMtags.ver
new/VCFv4.1.pdf  diff/VCFv4.1.pdf:  VCFv4.1.tex  new/VCFv4.1.ver
new/VCFv4.2.pdf  diff/VCFv4.2.pdf:  VCFv4.2.tex  new/VCFv4.2.ver
new/VCFv4.3.pdf  diff/VCFv4.3.pdf:  VCFv4.3.tex  new/VCFv4.3.ver
new/VCFv4.4.draft.pdf  diff/VCFv4.4.draft.pdf:  VCFv4.4.draft.tex  new/VCFv4.4.draft.ver

PDFLATEX = pdflatex

new/%.pdf: %.tex
	scripts/rerun.sh new/$* $(PDFLATEX) --output-directory new $<

new/BEDv1.pdf: BEDv1.tex
	latexmk --lualatex --output-directory=new $<

new/CRAMv2.1.ver new/CRAMv3.ver: img/CRAMFileFormat2-1-fig001.png img/CRAMFileFormat2-1-fig002.png img/CRAMFileFormat2-1-fig003.png img/CRAMFileFormat2-1-fig004.png img/CRAMFileFormat2-1-fig005.png img/CRAMFileFormat2-1-fig006.png img/CRAMFileFormat2-1-fig007.png

new/VCFv4.1.ver new/VCFv4.2.ver new/VCFv4.3.ver new/VCFv4.4.draft.ver:: img/all_orientations-400x296.png img/derivation-400x267.png img/erosion-400x211.png img/inserted_contig-400x247.png img/inserted_sequence-400x189.png img/inversion-400x95.png img/microhomology-400x248.png img/multiple_mates-400x280.png img/phasing-400x259.png img/reciprocal_rearrangement-400x192.png img/telomere-400x251.png

new/%.ver: %.tex
	@test -d new || mkdir new
	scripts/genversion.sh $^ > $@


diff diffs: $(PDFS:%=diff/%)

OLD = HEAD
NEW =

diff/%.pdf: %.tex
	BIBINPUTS=:.. TEXINPUTS=:..:../new latexdiff-vc --pdf --dir diff --force --git --only-changes --graphics-markup=none --ignore-warnings --revision $(OLD) $(if $(NEW),--revision $(NEW)) $<

diff/BEDv1.pdf: BEDv1.tex
	BIBINPUTS=:.. TEXINPUTS=:..:../new latexdiff-vc --config LATEX=lualatex --pdf --dir diff --force --git --only-changes --graphics-markup=none --ignore-warnings --revision $(OLD) $(if $(NEW),--revision $(NEW)) $<

show-styles:
	@sed -n '/\\usepackage/s/.*{\(.*\)}$$/\1/p' *.tex | sort | uniq -c


mostlyclean:
	-rm -f new/*.aux new/*.bbl new/*.blg new/*.fls new/*.fdb_latexmk new/*.log new/*.out new/*.toc new/*.ver
	-rm -f diff/**.aux diff/*.blg diff/*.idx diff/*.log diff/*.out diff/*.tex diff/*.toc

clean: mostlyclean
	-rm -f $(PDFS:%=new/%)$(if $(wildcard new),; rmdir new)
	-rm -f $(PDFS:%=diff/%)$(if $(wildcard diff),; rmdir diff)
	-rm -rf .jekyll-cache .jekyll-metadata _site


.PHONY: all pdf diff diffs show-styles mostlyclean clean
