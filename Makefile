SHELL := /bin/bash

ifeq (shell,$(firstword $(MAKECMDGOALS)))
NAME := $(strip $(wordlist 2,2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS)))
$(eval $(NAME):;@:)
endif

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
	drone exec --pipeline $@

docs: # Build docs with hugo
	@echo
	drone exec --pipeline $@

build: # Build defn/container
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

shell: # Get a shell
	docker run --rm -ti -v $(PWD):/drone/src --entrypoint bash $(NAME)

pull:
	docker pull defn/container
