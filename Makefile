configure:
	pip install poetry

pull:
	git submodule init
	git submodule update

build:
	poetry install

info:
	@: $(info Here are some 'make' options:)
	   $(info - Use 'make configure' to configure the repo by installing poetry.)
	   $(info - Use 'make pull' to initialize/pull the submodules.)
	   $(info - Use 'make build' to install entry point commands.)
