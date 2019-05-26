---
layout: post
title:  Containerising the Mule Enterprise Service Bus (ESB)
date:   2019-05-25 08:35:00
permalink: /posts/docker/
categories:
  - Docker
  - Mule
  - Mule ESB
---
In this post we will assume that you have Docker and would like to create an image that contains the Mule ESB. If you're looking for a Mule Docker image you can use without making your own, then you can check out mikeyryan/mule on Docker Hub.

## Why Containerise the Mule ESB?
The Mule ESB will run perfectly fine anywhere that you can install Java. However, you may find yourself in need of a solution that's more scalable than installing it on a standalone machine. A typical scenario for using the Mule ESB is to install it on a standalone server and then deploy all of your applications to it. This comes with a few disadvantages, primarily that a single unhealthy app can impact others in the same Mule ESB. One method of addressing this is to run multiple versions of the Mule ESB on the server, which is where Docker comes in.

With Docker we can easily deploy containers with the Mule ESB and a single application that will run in an independent isolated environment. This can also be useful for portability, as Docker will help us ensure that the application will run the same locally as it would when it's deployed to a server or the cloud.

## Creating a Mule ESB Docker image
To begin with, we will need to create file called ```Dockerfile``` in our working directory. A Dockerfile has a file format that contains instructions and arguments, which define the contents and startup behaviour of the Docker container. To run the Mule ESB, our Dockerfile will need to contain the following:
```
# The first instruction in a Dockerfile must be FROM, which selects a base image. Since it's recommended to use official Docker images, we will use the official image for openjdk.
FROM openjdk:8-jdk-alpine

LABEL maintainer="https://mike.gough.me"

# Define environment variables as arguments that can be passed in when building this image.
ARG BUILD_DATE=25052019
ARG MULE_HOME=/opt/mule
ARG MULE_VERSION=4.2.0
ARG MULE_MD5=0f098b4bbc65d27cee9af59904ed6545
ARG TINI_SUBREAPER=
ARG TZ=Australia/Sydney

# Update CA certs for downloading the Mule ESB zip
RUN apk --no-cache update && \
    apk --no-cache upgrade && \
    apk --no-cache add ca-certificates && \
    update-ca-certificates && \
    apk --no-cache add openssl && \
    apk add --update tzdata && \
    rm -rf /var/cache/apk/*

# Create a user for the Mule ESB to run as
RUN adduser -D -g "" mule mule

# Setup a directory for the Mule ESB
RUN mkdir /opt/mule-standalone-${MULE_VERSION} && \
    ln -s /opt/mule-standalone-${MULE_VERSION} ${MULE_HOME} && \
    chown mule:mule -R /opt/mule*

# Set the timezone
RUN echo ${TZ} > /etc/timezone

# Run as the mule user
USER mule

# Unpack the Mule ESB and validate its checksum
RUN cd ~ && wget https://repository-master.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/${MULE_VERSION}/mule-standalone-${MULE_VERSION}.tar.gz && \
    echo "${MULE_MD5}  mule-standalone-${MULE_VERSION}.tar.gz" | md5sum -c && \
    cd /opt && \
    tar xvzf ~/mule-standalone-${MULE_VERSION}.tar.gz && \
    rm ~/mule-standalone-${MULE_VERSION}.tar.gz

# Set the mount locations
VOLUME ["${MULE_HOME}/logs", "${MULE_HOME}/conf", "${MULE_HOME}/apps", "${MULE_HOME}/domains"]

# Set the working directory
WORKDIR ${MULE_HOME}

# Run this command on container start
CMD [ "/opt/mule/bin/mule"]

# Expose the port 8081
EXPOSE 8081
```

The above Docker file will create an image based on the official openjdk Docker image. It downloads and installs a specific version of the Mule ESB which can be passed as an optional argument when running the build process. After downloading the Mule ESB it computes the MD5 checksum, also passed as an optional argument, to verify the integrity of the file download. To create the Docker image with version 4.2.0 of the Mule ESB, run the following command:
```
docker build --build-arg MULE_VERSION=4.2.0 --build-arg MULE_MD5=0f098b4bbc65d27cee9af59904ed6545 -t mule:ce-4-2-0 .
```

Thats it! In a future post we will look at how we can use this image as the base for another image which contains a Mule application.
