.PHONY: all clean serve pdf

help:
	@echo "Available rules are:"
	@echo "    serve: Start local gitbook server"
	@echo "    node_modules: Install dependencies"
	@echo "    all: Build website and pdf without launching local server"
	@echo "    pdf: Build the pdf copy of the website"
	@echo "    clean: Clean up"

all: node_modules
	gitbook build
	-@cp ostap-tutorials.pdf _book/

serve: node_modules
	while true; do gitbook serve; sleep 5; done

pdf: node_modules
	gitbook pdf
	@mv book.pdf ostap-tutorials.pdf

node_modules:
	gitbook install

clean:
	@rm -rf _book
	@rm -f book.pdf ostap-tutorials.pdf
	@rm -rf node_modules

publish-travis: all pdf
	@ghp-import -n ./_book && git push -fq https://${GH_TOKEN}@github.com/$(TRAVIS_REPO_SLUG).git gh-pages > /dev/null
