---
date: 2019-05-27 11:40
title: Containerising Mule Enterprise Service Bus (ESB) Enterprise Edition
description: In this post we will assume that you have Docker and would like to create an image that contains the Enterprise Edition of the Mule ESB.
tags: Articles, Docker, Mule ESB
---
If you're looking for a Mule Docker image you can use without making your own, then you can check out [mikeyryan/mule](https://hub.docker.com/r/mikeyryan/mule) on Docker Hub.

## Why Containerise the Mule ESB?

![MuleSoft logo](/images/posts/mulesoft-logo.svg)

The Mule ESB will run perfectly fine anywhere that you can install Java. However, you may find yourself in need of a solution that's more scalable than installing it on a standalone machine. A typical scenario for using the Mule ESB is to install it on a standalone server and then deploy all of your applications to it. This comes with a few disadvantages, primarily that a single unhealthy app can impact others in the same Mule ESB. One method of addressing this is to run multiple versions of the Mule ESB on the server, which is where Docker comes in.

With Docker we can easily deploy containers with the Mule ESB and a single application that will run in an independent isolated environment. This can also be useful for portability, as Docker will help us ensure that the application will run the same locally as it would when it's deployed to a server or the cloud.

## Creating a Docker image

![Docker logo](/images/posts/docker-logo.svg)

To begin with, we will need to create a new file called `Dockerfile` in our working directory. A Dockerfile has a file format that contains instructions and arguments, which define the contents and startup behaviour of the Docker container. To run the Mule ESB, our Dockerfile will need to contain the following:
```dockerfile
# The first instruction in a Dockerfile must be FROM, which selects a base image. Since it's recommended to use official Docker images, we will use the official image for openjdk.
FROM openjdk:8-jdk

LABEL maintainer="https://mike.gough.me"

# Define environment variables as arguments that can be passed in when building this image.
ARG MULE_VERSION=4.2.0
ARG MULE_MD5=0f098b4bbc65d27cee9af59904ed6545
ARG TZ=Australia/Sydney

ENV MULE_HOME=/opt/mule
ENV MULE_DOWNLOAD_URL http://s3.amazonaws.com/new-mule-artifacts/mule-ee-distribution-standalone-${MULE_VERSION}.zip

# Set the timezone
RUN echo ${TZ} > /etc/timezone

# Set the working directory
WORKDIR ${MULE_HOME}

RUN mkdir -p /opt && \
    cd /opt && \
    wget "$MULE_DOWNLOAD_URL" -O mule-ee-distribution-standalone-${MULE_VERSION}.zip

# Unpack Mule ESB
RUN cd /opt && \
  rm -rf mule-enterprise-standalone-${MULE_VERSION} && \
  unzip mule-ee-distribution-standalone-${MULE_VERSION}.zip && \
  rm -rf mule-standalone-${MULE_VERSION} && \
  rm -f mule-ee-distribution-standalone-${MULE_VERSION}.zip && \
  mv mule-enterprise-standalone-${MULE_VERSION} mule-standalone-${MULE_VERSION}

RUN cd /opt && \
  rm -rf mule && \
  ln -s mule-standalone-${MULE_VERSION} mule

# Set the mount locations
VOLUME ["${MULE_HOME}/logs", "${MULE_HOME}/conf", "${MULE_HOME}/apps", "${MULE_HOME}/domains", "${MULE_HOME}/patches", "${MULE_HOME}/.mule"]

# Run this command on container start
CMD [ "${MULE_HOME}/bin/mule"]

# HTTP listener default port, remote debugger, JMX, MMC agent, AMC agent
EXPOSE 8081 5000 1098 7777 9997
```

The above Docker file will create an image based on the official openjdk Docker image. It downloads and installs a specific version of the Mule ESB which can be passed as an optional argument when running the build process. To create the Docker image with version 4.2.0 of the Mule ESB, run the following command:
```bash
docker build --build-arg MULE_VERSION=4.2.0 -t mule:ee-4-2-0 .
```
With newer versions of Mule (4 and above) you may need to provide a licence instead of using a 30 day trial.

Thats it! In a future post we will look at how we can use this image as the base for another image which contains a Mule application.

## References
- [Docker Hub - Mule docker images][1]
- [Mule Installation][2]
- [Mule 4 Standalone][3]

[1]: https://hub.docker.com/r/mikeyryan/mule "mikeyryan/mule"
[2]: https://docs.mulesoft.com/mule-runtime/4.2/mule-standalone "Mule Installation"
[3]: https://www.mulesoft.com/lp/dl/mule-esb-enterprise "Mule 4 standalone"
