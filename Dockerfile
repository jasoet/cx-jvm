FROM ubuntu:18.04
MAINTAINER gopay-system <gopay-systems@go-jek.com>

ENV LANG en_US.UTF-8

ENV SDKMAN_DIR=/root/.sdkman

RUN set -x \
    && apt-get update --fix-missing \
    && apt-get install -y apt-transport-https ca-certificates curl \
    && apt-get install -y software-properties-common jq figlet python zip wget build-essential make autoconf automake

RUN set -x && \
    curl -s "https://get.sdkman.io" | bash && \
    rm -rf /var/lib/apt/lists/* && \
    echo "sdkman_auto_answer=true" > $SDKMAN_DIR/etc/config && \
    echo "sdkman_auto_selfupdate=false" >> $SDKMAN_DIR/etc/config && \
    echo "sdkman_insecure_ssl=true" >> $SDKMAN_DIR/etc/config

COPY cx /usr/local/bin/cx
RUN chmod +x /usr/local/bin/cx

SHELL ["/bin/bash", "-c"]
RUN cx sdk install java
RUN cx sdk install gradle

ENTRYPOINT ["/usr/local/bin/cx"]
