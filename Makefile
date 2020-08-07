NAME=pdf utility
VERSION=1.0

SCRIPT_FILES = $(wildcard *.sh)

deploy:
	@ls ${HOME}/bin &> /dev/null || mkdir ${HOME}/bin && echo 'directory ${HOME}/bin created.'
	@$(foreach file, $(SCRIPT_FILES), ln -svfn $(abspath $(file)) $(HOME)/bin/$(basename ${file} .sh);)

update:
	git pull origin master

install: update deploy

