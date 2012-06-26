#
# Makefile for cooleasy
#
#
TARGETS = `find setup.py cooleasy scripts -name "*.py"`

# use TAG=a for alpha, b for beta, rc for release candidate
ifdef TAG
    PKGTAG := egg_info --tag-build=$(TAG) --tag-date
else
    PKGTAG :=
endif

.PHONY: help build pkg sdist egg check uninstall clean doc clean_doc

## help: outputs help information
help:
	@grep -E '^## ' Makefile|grep -v ':'|sed 's,^## ,,g'
	@echo This Makefile has the targets:
	@grep -E '^## [.a-z_/]{2,}:' Makefile | sed 's/^## */	/g' | sed 's/: /	/g'


update:
	git pull

build:
	python setup.py $(PKGTAG) build

pkg: sdist egg

sdist:
	python setup.py $(PKGTAG) sdist

## egg: creates an binary egg for cooleasy
egg:
	-python setup.py $(PKGTAG) bdist_egg

release: pyflakes pep8
	-python setup.py $(PKGTAG) bdist_egg

## check: run pyflakes for cooleasy
check: pyflakes pep8

pyflakes:
	pyflakes $(TARGETS)
	@echo

pep8:
	pep8 --repeat --statistics $(TARGETS)
	@echo

lint:
	-pylint cooleasy scripts

## uninstall: uninstall dasbootsrap
uninstall:
	-easy_install -m cooleasy
	-rm -rf /usr/local/lib/python2.7/dist-packages/cooleasy*

## doc: creates html documentation
doc:
	make -C docs html
clean_doc:
	rm -rf docs/_build

## clean: deletes all of the working files
clean:
	find . "(" -name "*~" -or -name ".#*" -or -name "#*#" -or -name "*.pyc" ")" -print0 | xargs -0 rm -f
	rm -rf build dist MANIFEST *.egg-info
