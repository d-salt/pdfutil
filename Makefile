NAME=pdf utility
VERSION=1.0

SCRIPT_FILES = $(wildcard *.sh)

update:
	git pull origin master

deploy:
	@$(foreach file, $(SCRIPT_FILES), ln -svfn $(abspath $(file)) $(HOME)/bin/$(basename ${file} .sh);)

install: update deploy

