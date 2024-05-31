# pass in image name as a build argument like this:
# docker build --build-arg IMAGE_NAME=nateateteen/zshpod:latest -f dart.Dockerfile .
ARG IMAGE_NAME
FROM $IMAGE_NAME

ARG _USER="gitpod"

# sets user to root so that we can install stuff
USER root

# install dart
RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg2 curl git ca-certificates apt-transport-https openssh-client && \
    curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends dart && \
    dart --disable-analytics && \
    apt-get clean -y && \
    rm -rf \
	    /var/cache/debconf/* \
	    /var/lib/apt/lists/* \
	    /tmp/* \
	    /var/tmp/*

# sets path
ENV PATH="$PATH:/usr/lib/dart/bin"

# copies dart config files
WORKDIR /home/$_USER/.dart
ADD .dart_config/ .

# disables dart telemetry
WORKDIR /home/$_USER/.dart-tool
ADD .dart-tool/ .

# sets user back to gitpod
USER $_USER
