SHELL := /bin/bash

menu:
	@perl -ne 'printf("%10s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile | sort -b

all: # Run everything except build
	$(MAKE) fmt
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
	drone exec --pipeline $@

docs: # Build docs
	@echo
	drone exec --pipeline $@

build: # Build container
	@echo
	drone exec --pipeline build-a --secret-file .drone.secret
	sleep 5
	docker pull letfn/drone-kaniko:a
	@echo
	drone exec --pipeline build-b --secret-file .drone.secret .drone.yml.build
	sleep 5
	docker pull letfn/drone-kaniko:b
	@echo
	drone exec --pipeline build-c --secret-file .drone.secret .drone.yml.build
	sleep 5
	docker pull letfn/drone-kaniko:c
	@echo
	drone exec --pipeline build --secret-file .drone.secret .drone.yml.build
	sleep 5
	docker pull letfn/drone-kaniko

build-fast: # Build container direcly
	@echo
	drone exec --pipeline build-fast --secret-file .drone.secret .drone.yml.build
	sleep 5
	docker pull letfn/drone-kaniko
