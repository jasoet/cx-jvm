FROM azul/zulu-openjdk:11

ENV LANG en_US.UTF-8

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

ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 5.2.1

ENV KOTLIN_HOME /opt/kotlin
ENV KOTLIN_VERSION 1.3.21

ENV MAVEN_HOME /opt/maven
ENV MAVEN_VERSION 3.6.0

ENV KSCRIPT_HOME /opt/kscript
ENV KSCRIPT_VERSION 2.7.1

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
RUN set -o errexit -o nounset \
    && echo "Downloading Gradle" \
    && wget --no-verbose --output-document=gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    \
    && echo "Installing Gradle" \
    && unzip gradle.zip \
    && rm gradle.zip \
    && mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
    && ln --symbolic "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle \
    \
    && mkdir /home/jvm/.gradle \
    && chown --recursive jvm:jvm /home/jvm/.gradle \
    && chown --recursive jvm:jvm "${GRADLE_HOME}/" \
    \
    && ln -s /home/jvm/.gradle /root/.gradle

# Install MAVEN
RUN set -o errexit -o nounset \
    && echo "Downloading Maven" \
    && wget --no-verbose --output-document=maven.zip "https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip" \
    \
    && echo "Installing Maven" \
    && unzip maven.zip \
    && rm maven.zip \
    && mv "apache-maven-${MAVEN_VERSION}" "${MAVEN_HOME}/" \
    && ln --symbolic "${MAVEN_HOME}/bin/mvn" /usr/bin/mvn \
    && ln --symbolic "${MAVEN_HOME}/bin/mvnDebug" /usr/bin/mvnDebug \
    \
    && mkdir /home/jvm/.m2 \
    && chown --recursive jvm:jvm /home/jvm/.m2 \
    && chown --recursive jvm:jvm "${MAVEN_HOME}/" \
    \
    && ln -s /home/jvm/.m2 /root/.m2

# Install Kscript
RUN set -o errexit -o nounset \
    && echo "Downloading Kscript" \
    && wget --no-verbose --output-document=kscript.zip "https://github.com/holgerbrandl/kscript/releases/download/v${KSCRIPT_VERSION}/kscript-${KSCRIPT_VERSION}-bin.zip" \
    \
    && echo "Installing KScript" \
    && unzip kscript.zip \
    && rm kscript.zip \
    && mv "kscript-${KSCRIPT_VERSION}" "${KSCRIPT_HOME}/" \
    && ln --symbolic "${KSCRIPT_HOME}/bin/kscript" /usr/bin/kscript \
    && ln --symbolic "${KSCRIPT_HOME}/bin/kscript.jar" /usr/bin/kscript.jar \
    \
    && mkdir /home/jvm/.kscript \
    && chown --recursive jvm:jvm /home/jvm/.kscript \
    && chown --recursive jvm:jvm "${KSCRIPT_HOME}/" \
    \
    && ln -s /home/jvm/.kscript /root/.kscript

# Register all Path
ENV PATH "$PATH:${KOTLIN_HOME}/bin"

# Create jvm volume
USER jvm
VOLUME "/home/jvm/.gradle" "/home/jvm/.m2"
WORKDIR /home/jvm

RUN set -o errexit -o nounset \
    && echo "Testing Gradle installation" \
    && gradle --version \
    && kotlinc -version \
    && mvn -v \
    && kscript -v
