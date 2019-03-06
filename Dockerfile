FROM azul/zulu-openjdk:11

ENV LANG en_US.UTF-8

ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 5.2.1

ENV KOTLIN_HOME /opt/kotlin
ENV KOTLIN_VERSION 1.3.21

# Install apt dependencies
RUN set -x \
    && apt-get update --fix-missing \
    && apt-get install -y apt-transport-https ca-certificates curl \
    && apt-get install -y software-properties-common jq figlet python zip wget build-essential make autoconf automake

RUN set -o errexit -o nounset \
    && echo "Adding jvm user and group" \
    && groupadd --system --gid 1000 jvm \
    && useradd --system --gid jvm --uid 1000 --shell /bin/bash --create-home jvm \
    && chown --recursive jvm:jvm /home/jvm/

# Install Kotlin
RUN set -o errexit -o nounset \
    && echo "Download Kotlin" \
    && wget --no-verbose --output-document=kotlin.zip "https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip" \
    \
    && echo "Installing Kotlin" \
    && unzip kotlin.zip  \
    && rm kotlin.zip \
    && mv "kotlinc/" "${KOTLIN_HOME}/" \
    && rm -f "${KOTLIN_HOME}/bin/*.bat" \
    && chown --recursive jvm:jvm "${KOTLIN_HOME}/"

# Install Gradle
ARG GRADLE_DOWNLOAD_SHA256=748c33ff8d216736723be4037085b8dc342c6a0f309081acf682c9803e407357
RUN set -o errexit -o nounset \
    && echo "Downloading Gradle" \
    && wget --no-verbose --output-document=gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    \
    && echo "Checking download hash" \
    && echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum --check - \
    \
    && echo "Installing Gradle" \
    && unzip gradle.zip \
    && rm gradle.zip \
    && mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
    && ln --symbolic "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle \
    \
    && mkdir /home/jvm/.gradle \
    && chown --recursive jvm:jvm /home/jvm/.gradle \
    \
    && echo "Symlinking root Gradle cache to gradle Gradle cache" \
    && ln -s /home/jvm/.gradle /root/.gradle

ENV PATH "$PATH:${KOTLIN_HOME}/bin"

# Create jvm volume
USER jvm
VOLUME "/home/jvm/.gradle"
WORKDIR /home/jvm

RUN set -o errexit -o nounset \
    && echo "Testing Gradle installation" \
    && gradle --version \
    && kotlinc -v
