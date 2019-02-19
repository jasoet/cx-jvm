FROM asia.gcr.io/systems-0001/cx-base:latest
MAINTAINER gopay-system <gopay-systems@go-jek.com>

ENV LANG en_US.UTF-8

RUN update-ca-certificates \
    && apt-get update --fix-missing \
    && apt-get install -y apt-transport-https ca-certificates curl \
    && apt-get install -y software-properties-common jq figlet python zip wget build-essential make autoconf automake

COPY sdkman-install.sh /
RUN chmod +x sdkman-install.sh
RUN bash sdkman-install.sh

COPY entrypoint.sh /
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

