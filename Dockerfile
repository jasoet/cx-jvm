FROM asia.gcr.io/systems-0001/cx-base:latest
MAINTAINER gopay-system <gopay-systems@go-jek.com>

ENV LANG en_US.UTF-8

RUN update-ca-certificates \
    && add-apt-repository -y ppa:openjdk-r \
    && apt-get update --fix-missing \
    && apt-get install -y apt-transport-https ca-certificates curl software-properties-common jq figlet python \
    && apt-get install -y openjdk-11-jdk openjdk-11-jre openjdk-11-jdk-headless openjdk-11-jre-headless \
    && apt-get install -y maven gradle libffi-dev

RUN sed -i -e 's/keystore.type=pkcs12/keystore.type=jks/' /etc/java-11-openjdk/security/java.security \
    && rm /etc/ssl/certs/java/cacerts \
    && /var/lib/dpkg/info/ca-certificates-java.postinst configure

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

RUN apt-key fingerprint 0EBFCD88

RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

RUN apt-get update \
    && apt-get -y install docker-ce

RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" \
    && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN apt-get update && apt-get install google-cloud-sdk -y

RUN mkdir -p /etc/docker/certs.d/artifactory-gojek.golabs.io:6555/

RUN curl --header "PRIVATE-TOKEN: ypAcvxG8dbxaaSZ9eEbM" "https://source.golabs.io/api/v4/groups/19/variables/artifactorydockerca" | jq '.value' | python -c "import sys, json; print json.load(sys.stdin)" > /etc/docker/certs.d/artifactory-gojek.golabs.io:6555/ca.crt
RUN curl --header "PRIVATE-TOKEN: ypAcvxG8dbxaaSZ9eEbM" "https://source.golabs.io/api/v4/groups/19/variables/gitlabrunnersvcaccount" | jq '.value' | python -c "import sys, json; print json.load(sys.stdin)" > /tmp/gitlabrunnersvcaccount.json
RUN echo '{ "insecure-registries" : ["artifactory-gojek.golabs.io:6555"] } ' > /etc/docker/demon.json
RUN docker login -u docker -p docker artifactory-gojek.golabs.io:6555
RUN gcloud auth activate-service-account --key-file /tmp/gitlabrunnersvcaccount.json

RUN rm -f /tmp/gitlabrunnersvcaccount.json
