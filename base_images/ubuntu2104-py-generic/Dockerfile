FROM ubuntu:21.04
MAINTAINER William Ronchetti (william_ronchetti@hms.harvard.edu)

# use latest conda, build for x86_64 and Python 3.8 (default)
ARG CONDA_VER=latest
ARG OS_TYPE=x86_64
ARG PYTHON_VERSION=3.8
ARG JDK_VERSION=8.0.312

ENV DEBIAN_FRONTEND noninteractive

# general updates & installing necessary Linux components
RUN apt-get update -y && apt-get install -y \
    bzip2 \
    gcc \
    g++ \
    git \
    less \
    make \
    time \
    unzip \
    vim \
    wget \
    curl \
    zlib1g-dev \
    liblz4-tool \
    libcurl4-openssl-dev \
    libssl-dev

# installing conda
RUN wget https://repo.continuum.io/miniconda/Miniconda3-${CONDA_VER}-Linux-${OS_TYPE}.sh && \
    bash Miniconda3-${CONDA_VER}-Linux-${OS_TYPE}.sh -p /miniconda3 -b
ENV PATH=/miniconda3/bin:$PATH
RUN conda update -y conda \
    && rm Miniconda3-${CONDA_VER}-Linux-${OS_TYPE}.sh
RUN conda config --add channels bioconda && conda config --add channels conda-forge

# install desired python
RUN conda install -c bioconda -y python=${PYTHON_VERSION} openjdk=${JDK_VERSION} && \
    conda clean -a -y -f

# supporting UTF-8
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# default command
CMD ["python -V"]
