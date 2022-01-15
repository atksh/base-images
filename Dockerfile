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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN tlmgr init-usertree
RUN kanji-config-updmap-sys ipaex

RUN apt-get update && \
    apt-get install -y \
    openssh-client git vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workdir
CMD ["/bin/bash"]
