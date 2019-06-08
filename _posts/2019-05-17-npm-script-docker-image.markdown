---
layout: post
title:  "Containerising a Node.js script"
date:   2019-05-17 19:11:00
categories:
  - Docker
  - NPM
  - Continuous Integration
  - Continuous Delivery
  - RAML Enforcer
---

When working inside a Continuous Integration (CI) and Continuous Delivery (CD) environment, portability of code is often a core concern that needs to be addressed. Developers write code locally and need some level of assurance that it will run consistently regardless of where it is deployed. This is an area where Docker shines. The goal of this post is to run a script, written with Node.js, inside a docker container. It assumes that you have an existing script which requires access to files on the local file system as well as an account on Docker Hub.

## Docker concepts
To begin with, it's important to understand what Docker is and the principles behind it. Docker is a platform for *developers* and *system administrators* to develop, deploy and run applications with containers. The use of containers to deploy applications is called containerization, which is popular in CI and CD workflows because containers are<sup>[1]</sup>:
* Flexible - Any application can be containerized
* Lightweight - They leverage and share the host kernel
* Interchangeable - You can deploy updates and upgrades with zero down time
* Portable - You can build locally and deploy to a server on premises or in the cloud
* Scalable - You can scale your containers horizontally; increasing, decreasing or distributing replicas of them automatically
* Stackable - You can stack your containers vertically, defining  a stack declaratively

In Docker a container is launched by running an image, and an image is an executable package that includes everything needed to run an application.

## Great.. so how do we create an image?
To begin with, we will need to create file called ```Dockerfile``` in our working directory. A Dockerfile has a file format that contains instructions and arguments, which define the contents and startup behaviour of the Docker container. To run a Node.js script, our Dockerfile will need to contain the following, replacing ```<script-name>``` with the filename of your script:
```
# The first instruction in a Dockerfile must be FROM, which selects a base image. Since it's recommended to use official Docker images, we will use the official image for node. We will chose a specific image rather than defaulting to latest as future node versions may break our application.
FROM node:12-alpine

# Sets the working directory to /usr/src/app.
WORKDIR /usr/src/app

# Copies the package file for NPM to the working directory.
COPY package*.json ./

# Installs the required NPM packages.
RUN npm install

# Copies the application from the current directory to the working directory of the image.
copy . .

# If an action does not use the runs configuration option, the commands in ENTRYPOINT will execute. The Docker ENTRYPOINT instruction has a shell form and exec form. We will use the exec form of the ENTRYPOINT instruction to call our node script. This will allow us to pass arguments to the script when we run the container.
ENTRYPOINT ["node", "<script-name>"]
```

So the above ```Dockerfile``` will create a new image based on the official Node image, install our scripts NPM dependancies, copy the script to a working directory and when a container is started, automatically run the script. One thing we have overlooked is that since the ```Dockerfile``` installs NPM dependancies for us we shouldn't copy any node_modules into the image. To avoid this we can create a file called ```.dockerignore``` with the following contents:
```
node_modules
```

With our ```Dockerfile``` and ```.dockerignore``` files in place, we can now build our image by running the following command and replacing ```<docker-hub-username>``` with your Docker Hub username and ```<image-name>``` with something memorable:
```
sudo docker build --no-cache --tag "<docker-hub-username>/<image-name>:latest" .
```

![Docker build screenshot](/assets/images/posts/npm-script-docker-build.svg)

## Running our image
Having built a Docker image, we can now run it locally by using the following command and replacing ```<docker-hub-username>``` with your Docker Hub username and ```<image-name>``` with the name used earlier:
```
sudo docker run --init --rm --volume $(pwd):/tmp "<docker-hub-username>/<image-name>:latest" <image-args>
```

![Docker run screenshot](/assets/images/posts/npm-script-docker-run.svg)

For reference, the arguments we are passing through to Docker are:
* init - sets the ENTRYPOINT to tini. tini is a lightweight init process which will help ensure that Node.js returns and responds to signals correctly
* rm - removes the container once it has finished running
* volume - mounts the specified location inside the container

## Pushing our image to Docker Hub
The final step of our journey is to publish our local docker image to Docker Hub so that we are able to pull and run it from other locations such as a CI/CD server. Before we can push our image we will need to login do Docker Hub by running the following command and entering our Docker Hub username and password when prompted:
```
docker login
```
Once successfully authenticated, we can push our image by running the following command and replacing ```<docker-hub-username>``` with your Docker Hub username and ```<image-name>``` with the name used earlier:
```
sudo docker push "<docker-hub-username>/<image-name>:latest"
```

![Docker push screenshot](/assets/images/posts/npm-script-docker-push.svg)

Thats it! You can navigate to ```https://hub.docker.com/r/<docker-hub-username>/<image-name>``` to see your published image.

## References
- [Docker - Get Started][1]

[1]: https://docs.docker.com/get-started/        "Docker"
