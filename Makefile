# This Makefile is for my own convenience and isn't really used for deployment.

# package manager or sources
HUGO=hugo

# npm install -g spellcheck-cli
SPELLCHECK=spellchecker 

# npm install -g prettier
PRETTIER=prettier

# package manager or sources
PNGCRUSH=pngcrush

all: clean check public

# Build the public/ dir.
public: check
	$(HUGO)

dev:
	-$(HUGO) serve -D

clean:
	-rm -rf public

# Catch-all "check" task worth running before deployment.
check: check-spelling check-formatting

# Not the most accurate, but may save me from looking like a fool.
check-spelling:
	-$(SPELLCHECK) \
		-f ./content/**/*.md \
		-l en-US \
		-p frontmatter spell indefinite-article repeated-words syntax-urls \
		-d dictionary.txt \
		--no-suggestions

# Check formatting on everything but HTML files (will look very strange if
# auto-formatted w/ Go templating, so we don't even bother)
check-formatting:
	$(PRETTIER) -l ./**/*.{css,js}

format:
	$(PRETTIER) -w ./**/*.{css,js}

dictionary.txt:
	@echo Preserving previous dictionary as dictionary.old.txt
	-mv dictionary.txt dictionary.old.txt
	$(SPELLCHECK) \
		-f ./content/**/*.md \
		-l en-US \
		-p frontmatter spell indefinite-article repeated-words syntax-urls \
		--generate-dictionary

pngopt:
	find -path './static/**/*.png' -exec pngcrush -ow {} \;

.PHONY: all dev clean check check-spelling
