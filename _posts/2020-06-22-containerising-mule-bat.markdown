---
layout: post
title:  Containerising MuleSoft's Blackbox Automated Testing (BAT) tool
date:   2019-06-22 10:19:00
tags:
  - Docker
  - Mule ESB
---
In this post we will assume that you have Docker and would like to create an image that contains the Blackbox Automated testing (BAT) application published by Mulesoft. If you're looking for a Mule Docker image you can use without making your own, then you can check out [mikeyryan/mule-blackbox-automated-testing](https://hub.docker.com/r/mikeyryan/mule-blackbox-automated-testing) on Docker Hub.
<!--more-->
## Why Containerise BAT?

![MuleSoft logo](/assets/images/posts/mulesoft-logo.svg)

BAT will run perfectly fine anywhere that you can install Java. However, you may find yourself in need of a solution that's more scalable than installing it on a standalone machine or needing to run multiple versions of BAT at the same time. A typical scenario for using Mule BAT is to install it on a standalone server and use it to monitor the availablilty of your APIs. Another, is to use it as part of your Continuous Deployment (CD) process to test that your APIs work as expected after being deployed. With Docker we can easily package BAT in a container which is useful for portability, as Docker will help ue sneusre that wour tests will run the same locally as they will when deployed to a server or used as part of a CD process.

## Creating a Docker image

![Docker logo](/assets/images/posts/docker-logo.svg)

To begin with, we will need to create file called ```Dockerfile``` in our working directory. A Dockerfile has a file format that contains instructions and arguments, which define the contents and startup behaviour of the Docker container. To run BAT, our Dockerfile will need to contain the following:
```
# The first instruction in a Dockerfile must be FROM, which selects a base image. Since it's recommended to use official Docker images, we will use the official image for maven.
FROM maven:3.6-jdk-8

LABEL maintainer="https://mike.gough.me"

# Install BAT using the script provided by MuleSoft
RUN curl -o- 'https://s3.amazonaws.com/bat-wrapper/install.sh' | bash

# Set the workdir to the default for the maven image we are using
WORKDIR /usr/src/mymaven

# Start BAT when the container is run
ENTRYPOINT ["bash", "bat"]
```

The above Docker file will create an image based on the official maven Docker image. It downloads and installs the latest version of BAT. To create the Docker image with the latest version of BAT, run the following command:
```
docker build mule-blackbox-automated-testing:latest .
```

Thats it! In a future post we will look at how we can use our BAT container to test an API.

## References
- [Docker Hub - MuleSoft docker images][1]
- [Mulesoft - Install BAT][2]
- [GitHub - Source code][3]

[1]: https://hub.docker.com/r/mikeyryan/mule-blackbox-automated-testing "mikeyryan/mule-blackbox-automated-testing"
[2]: https://docs.mulesoft.com/api-functional-monitoring/bat-install-task "BAT Installation"
[3]: https://github.com/Mike-Gough/mule-blackbox-automated-testing "BAT Dockerfile source code"