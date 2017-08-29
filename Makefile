.DEFAULT_GOAL = help

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

# Redirect to bootstrap makefile if pillar is not found
PILLAR ?= $(wildcard pillar)
ifeq (,$(PILLAR))
	include support/makefiles/bootstrap.mk
else
	include support/makefiles/main.mk
endif
