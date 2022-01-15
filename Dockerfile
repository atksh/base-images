FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    evince \
    latexmk \
    xzdec \
    texlive-science \
    texlive-latex-extra \
    texlive-extra-utils \
    texlive-lang-cjk \
    language-pack-ja \
    xdvik-ja \ 
    locales-all \
    openssh-client \
    git \
    vim \
    cpanminus \
    perl \
    make \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    # JP locale
    && echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen

RUN tlmgr init-usertree
RUN kanji-config-updmap-sys ipaex
RUN cpanm Log::Log4perl Log::Dispatch::File YAML::Tiny File::HomeDir Unicode::GCString

RUN apt-get update && \
    apt-get install -y \
    openssh-client git vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workdir
ENV LANG=ja_JP.UTF-8
CMD ["/bin/bash"]
