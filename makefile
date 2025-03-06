SHELL := /bin/bash

SED_PIPE = sed -E 's/(\[[^]]*\]\()([^)]*)\.md\)/\1\2.html)/g' | sed -E 's/(\[[^]]*\]\()(([^)]*\/)?[^/. )]+)(\))/\1\2.html\4/g'

MD_FILES := $(shell find . -type f -name '*.md')

HTML_FILES := $(MD_FILES:.md=.html)

all: clean $(HTML_FILES)

index.html: index.md
	@echo "Converting index.md to index.html"
	@cat $< | $(SED_PIPE) | pandoc --standalone --template=templates/template-index.html --mathjax -o $@ -

posts/%.html: posts/%.md
	@echo "Converting $< to $@"
	@cat $< | $(SED_PIPE) | pandoc --standalone --template=templates/template-posts.html --mathjax -o $@ -

aboutme/%.html: aboutme/%.md
	@echo "Converting $< to $@"
	@cat $< | $(SED_PIPE) | pandoc --standalone --template=templates/template-aboutme.html --mathjax -o $@ -

README.html: README.md
	@echo "Converting README.md to README.html"
	@cat $< | $(SED_PIPE) | pandoc --standalone --template=templates/template-default.html --mathjax -o $@ -

clean:
	@find . -type f -name '*.html' ! -name 'template*.html' -delete
	@echo "Cleaned all HTML files."
