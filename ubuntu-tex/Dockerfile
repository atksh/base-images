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
    curl \
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
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workdir
ENV LANG=ja_JP.UTF-8
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs build-essential
RUN npm install -g npm && \
    npm install -g textlint && \
    npm install -g \
    prh \
    textlint-filter-rule-comments \ 
    textlint-plugin-latex2e \
    textlint-rule-preset-ja-spacing \
    textlint-rule-preset-ja-technical-writing \
    textlint-rule-preset-ja-engineering-paper \
    textlint-rule-spellcheck-tech-word \
    textlint-rule-prh \
    textlint-rule-preset-japanese
CMD ["/bin/bash"]