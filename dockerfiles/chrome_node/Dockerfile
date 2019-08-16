FROM node:10

LABEL name="google chrome with node" \
      maintainer="Ismail" \
      version="1.0" \
      description="Google Chrome with Node for running karma and protractor"

# Install Chrome

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list

RUN apt-get update && \
    apt-get install -y google-chrome-stable

# Setting Chrome path 
ENV CHROME_BIN /usr/bin/google-chrome

# Log versions

RUN set -x \
    && node -v \
    && npm -v \
    && google-chrome --version