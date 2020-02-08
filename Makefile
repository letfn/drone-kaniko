SHELL := /bin/bash

menu:
	@perl -ne 'printf("%10s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile | sort -b

all: # Run everything
	$(MAKE) lint
	$(MAKE) test
	$(MAKE) docs

fmt: # Format drone fmt
	@echo
	drone exec --pipeline $@

lint: # Run drone lint
	@echo
	drone exec --pipeline $@

test: # Run tests
	@echo
	cat .drone.yml.test.template | sed 's#$${PROJECT_PATH}#'"$(PWD)"'#' > .drone.yml.test
	drone exec --pipeline $@ --trusted .drone.yml.test

docs: # Build docs with hugo
	@echo
	drone exec --pipeline $@

build: # Build defn/container
	@echo
	drone exec --pipeline $@ --secret-file .drone.secret

pull:
	docker pull defn/container
