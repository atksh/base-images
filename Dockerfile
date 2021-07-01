FROM sharelatex/sharelatex:latest
RUN tlmgr update --self && \
    tlmgr update texlive-scripts && \
    tlmgr install scheme-full
RUN apt-get update && \
    apt-get install -y openssh-client git
