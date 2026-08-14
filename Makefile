# Local build/preview entry points.
#
# LANG is forced to a UTF-8 locale because macOS leaves it unset unless the
# terminal forwards it. Without it Ruby defaults to US-ASCII and the Sass
# converter dies on the UTF-8 characters in the remote theme's main.scss:
#   Invalid US-ASCII character "\xE2" on line 34
# Set LANG in your shell profile too if you'd rather run jekyll directly.

export LANG = en_US.UTF-8

.PHONY: serve build cv clean

## serve: build and preview at http://localhost:4000 with live reload
serve:
	bundle exec jekyll serve --livereload

## build: build the static site into _site/
build:
	bundle exec jekyll build

## cv: regenerate the CV PDF (CI also does this on any _data/** push)
cv:
	Rscript cv/build_cv.R

## clean: remove build output and caches
clean:
	rm -rf _site .jekyll-cache .sass-cache
