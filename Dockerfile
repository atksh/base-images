FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    evince \
    latexmk \
    xzdec \
    texlive-latex-extra \
    texlive-lang-cjk \
    language-pack-ja \
    xdvik-ja \ 
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN tlmgr init-usertree
RUN kanji-config-updmap-sys ipaex

WORKDIR /tmp
COPY update-tlmgr-latest.sh .
RUN sh update-tlmgr-latest.sh --upgrade

WORKDIR /workdir
CMD ["/bin/bash"]
