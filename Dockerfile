FROM sharelatex/sharelatex:latest
RUN apt-get update && apt-get upgrade -y
RUN tlmgr update --self && \
    tlmgr update texlive-scripts && \
    tlmgr install scheme-full
RUN apt-get update && \
    apt-get install -y openssh-client git

WORKDIR /tmp
COPY update-tlmgr-latest.sh .
RUN bash update-tlmgr-latest.sh

WORKDIR /workdir
CMD ["/bin/bash"]
