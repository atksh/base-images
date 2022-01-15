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
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    # JP locale
    && echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen

RUN tlmgr init-usertree
RUN kanji-config-updmap-sys ipaex
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends cpanminus make gcc libc6-dev && \
    cpanm -n -q Log::Log4perl && \
    cpanm -n -q XString && \
    cpanm -n -q Log::Dispatch::File && \
    cpanm -n -q YAML::Tiny && \
    cpanm -n -q File::HomeDir && \
    cpanm -n -q Unicode::GCString && \
    apt-get remove -y cpanminus make gcc libc6-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workdir
ENV LANG=ja_JP.UTF-8
CMD ["/bin/bash"]
