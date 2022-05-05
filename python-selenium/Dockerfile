FROM atksh/python
RUN apt-get update && apt-get install -y wget

# google chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get -y update && apt-get install -y google-chrome-stable unzip

# chromedriver
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

# IPA font
RUN wget https://moji.or.jp/wp-content/ipafont/IPAexfont/IPAexfont00401.zip && \
    unzip IPAexfont00401.zip -d ~/.fonts/ && \
    fc-cache -fv

# virtual display
RUN apt-get update && \
    apt-get install -y \
    xvfb \
    xserver-xephyr \
    tigervnc-standalone-server \
    xfonts-base

RUN pip install --no-cache \
    selenium \
    pyvirtualdisplay

