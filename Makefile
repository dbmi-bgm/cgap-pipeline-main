configure:
	pip install poetry

pull:
	git submodule init
	git submodule update

build:
	poetry install

build-image:
	docker build base_images/ubuntu-py-generic -t cgap-ubuntu2004-py-38

build-image-37:
	docker build base_images/ubuntu-py-generic --build-arg PYTHON_VERSION=3.7 -t cgap-ubuntu2004-py-37

info:
	@: $(info Here are some 'make' options:)
	   $(info - Use 'make configure' to configure the repo by installing poetry.)
	   $(info - Use 'make pull' to initialize/pull the submodules.)
	   $(info - Use 'make build' to install entry point commands.)
	   $(info - Use 'make build-image' to build the base Docker image for pipeline images with Python 3.8.)
	   $(info - Use 'make build-image-37' to build the base Docker image for pipeline images with Python 3.7.)
