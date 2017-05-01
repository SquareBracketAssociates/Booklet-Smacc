MAIN = book
CHAPTERS = \
	Chapters/Smacc/SmaccIntro \
	Chapters/Smacc/SmaccTutorial \
	Chapters/Smacc/SmaccAST \
	Chapters/Smacc/SmaccDirectives \
	Chapters/Smacc/SmaccScanner \
	Chapters/Smacc/SmaccParser \
	Chapters/Smacc/SmaccTransformations \
	Chapters/Smacc/SmaccIdioms \
	Chapters/Smacc/SmaccVocabulary \
	Chapters/Smacc/SmaccConclusion \


OUTPUTDIRECTORY = build
LATEXTEMPLATE = support/templates/main.latex.mustache
LATEXCHAPTERTEMPLATE = support/templates/chapter.latex.mustache
HTMLTEMPLATE = support/templates/html.mustache
HTMLCHAPTERTEMPLATE = $(HTMLTEMPLATE)

.DEFAULT_GOAL = help
.phony: all book chapters

all: pdf html ## Build everything in all formats
book: pdfbook htmlbook ## Full book only, all formats
chapters: pdfchapters htmlchapters ## Separate chapters, all formats

include support/makefiles/help.mk
include support/makefiles/prepare.mk

include support/makefiles/pdf.mk
include support/makefiles/html.mk
include support/makefiles/epub.mk
