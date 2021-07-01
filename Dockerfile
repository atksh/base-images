FROM sharelatex/sharelatex:latest
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/update-tlmgr-latest.sh && \
    chmod u+x update-tlmgr-latest.sh && \
    ./update-tlmgr-latest.sh -- --upgrade && \
    tlmgr install scheme-full && \
    rm ./update-tlmgr-latest.sh
RUN apt-get update && \
    apt-get install -y openssh-client git
