.PHONY: all pdf html build install uninstall clean

INSTALL_DIR ?= $(HOME)/.local/bin

all: pdf html

build:
	docker compose build

pdf: build
	@mkdir -p out
	docker compose run --rm pdf

html: build
	@mkdir -p out
	docker compose run --rm html

install: build
	@mkdir -p $(INSTALL_DIR)
	ln -sf $(shell pwd)/bin/pandoc-pdf $(INSTALL_DIR)/pandoc-pdf
	ln -sf $(shell pwd)/bin/pandoc-html $(INSTALL_DIR)/pandoc-html
	@echo "Symlinked to $(INSTALL_DIR). Ensure it is in your PATH."
	@echo "  echo 'export PATH=\"\$$HOME/.local/bin:\$$PATH\"' >> ~/.bashrc"

uninstall:
	rm -f $(INSTALL_DIR)/pandoc-pdf $(INSTALL_DIR)/pandoc-html

clean:
	rm -rf out/
	touch out/.gitkeep
