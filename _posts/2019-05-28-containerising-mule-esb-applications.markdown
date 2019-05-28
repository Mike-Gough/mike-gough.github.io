---
layout: post
title:  Containerising a Mule 4 application
date:   2019-05-28 13:29:00
permalink: /posts/docker/mule/4/hello-world-application
categories:
  - Docker
  - Mule
  - Mule ESB
---
In this post we will walk through how you can run a simple Mule 4 application inside of a Docker container.

## Prerequisites
To keep things brief, we will assume you already have JDK 8, Maven 3 and Docker installed and setup correctly. Your docker host needs to have at least 1GB of available RAM to run Mule ESB Server Runtime. You can refer to the [Mule ESB hardware requirements](https://docs.mulesoft.com/mule-runtime/4.2/hardware-and-software-requirements) documentation for additional information.

## Hello world Mule 4 application

![MuleSoft logo](/assets/images/posts/mulesoft-logo.svg)

I have created a simple Hello World application inside Mule 4 which can be used for this walkthrough. It has a single HTTP listener flow that listens on ```http://localhost:8081/api/hello-world``` and can be found on  [GitHub](https://github.com/Mike-Gough/mule-4-hello-world). The GitHub repository contains an example for both the community edition and enterprise edition of Mule. You can download and use either example, or if you prefer, your own application, however, if you choose to use the enterprise edition inside Docker, you may need to install a licence file.

## Building the application
To build the application, open your Command Line Interface (CLI) of choice, navigate to the application directory and run:
```
mvn clean package
```
This will cause Maven to create a ```target``` folder and package the application into a jar file inside of it. We will be using this jar file inside of our Docker image.

## Creating a Docker image for the Mule application
To begin with, we will need to create file called ```Dockerfile``` in our working directory. A Dockerfile has a file format that contains instructions and arguments, which define the contents and startup behaviour of the Docker container. To containerise the example Mule application, our Dockerfile will need to have the following contents for a community edition application:
```
# The first instruction in a Dockerfile must be FROM, which selects a base image. We are using the image I published from a previous post about containerising the Mule ESB. Change this line to your own repository if you have created your own image.
FROM mikeyryan/mule:4.2.0-ce

COPY ./target/mule-4-hello-world*.jar /opt/mule/apps/

CMD ["/opt/mule/bin/mule"]
```

If you are containerising an enterprise edition application, you will need to replace ```-ce``` with ```-ee``` in the line that begins with FROM. For applications other than the provided example from GitHub, you will need to modify the name of the JAR inside the COPY command to match the name of your project.

The above Dockerfile builds an image based on a pre-existing Mule ESB image and adds the application to it. Run it now by executing the following command:
```
docker build --tag mule-4-hello-world .
```
This command creates a Docker image called ```mule-4-hello-world``` which we can use to run our application.

## Running the application using Docker
To start a Docker container based on this image, execute the following command:
```
docker run --rm -it --name mule-4-hello-world -p 8081:8081 mule-4-hello-world
```
This will start a Docker container which will run in the foreground. The Docker image exposes port 8081 and binds it to the same port on localhost.

Once application is running, it can be accessed by navigating to ```http://localhost:8081/api/hello-world``` in your browser. When accessed, your browser should show:
```
Hello from Mule 4.2.0
```

## Summary
We have previously walked through how to containerise the Mule ESB and now we've demonstrated how easy it is to run Mule applications inside Docker containers. For those who prefer not to adventure down the path of containerising the Mule ESB themselves, they can still containerise a Mule application using the mikeyryan/mule image to easily get up and running.

## References
- [Containerising Mule Enterprise Service Bus (ESB) Enterprise Edition][1]
- [Containerising Mule Enterprise Service Bus (ESB) Community Edition][2]
- [Mule 4 - Example hello world application repository][3]

[1]: https://mike.gough.me/posts/docker/mule/esb/enterprise-edition "Containerising Mule Enterprise Service Bus (ESB) Enterprise Edition"
[2]: https://mike.gough.me/posts/docker/mule/esb/community-edition "Containerising Mule Enterprise Service Bus (ESB) Community Edition"
[3]: https://github.com/Mike-Gough/mule-4-hello-world "Mike-Gough/mule-4-hello-world"