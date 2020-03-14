---
date: 2020-01-26 06:00
title: How to run Swift in a Docker container
description: Learn how to run Swift inside a Docker container. Useful if you don't always have access to a machine running macOS or Linux to compile your code.
tags: Articles, Swift, Docker
---

## Prerequisites
To keep things simple, we will assume you have access to a bash Command Line Interface (CLI) on your local machine. Linux and macOS users should have access to a _Terminal_ application while Windows users will need to install one of several options, including but not limited to:

* [Windows subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
* [Git for Windows (Git Bash)](https://gitforwindows.org)

We will also assume that you have already installed Docker. If you want to get started with Docker on a Windows 10 or Mac OS operating system, installing Docker Desktop is the quickest way.

## What is Swift?

![Swift logo](/images/posts/swift-logo.svg)

Swift is a compiled programming language for writing iOS, macOS, watchOS, tvOS and Linux applications. It was originally created by Apple in 2014 as an open source, type-safe, extensible and fast programming language with a modern syntax.

To learn more about Swift, visit [swift.org](https://swift.org)

## Why run Swift inside docker?

![Docker logo](/images/posts/docker-logo.svg)

You can compile and run Swift anywhere that you can install the Swift Compiler. At present this means you either need to have access to a machine running macOS or Linux. For those with a Windows machine, or perhaps working in a corporate environment where you are unable to install the Swift Compiler locally, you can look to Docker for a solution. With Docker we can easily run an official Swift image to allow us to easily compile and run our code in an independent and isolated environment. This can also be useful for portability, as Docker will help us ensure that our Swift code will run the same locally as it would when it's deployed to a server or the cloud.

## How to run swift in a Docker container?
To begin with, we will need a simple Swift file that we can use to compile and run. Following tradition, lets create a file called `hello world.swift` containing the following:
```swift
import Swift
print("Hello, world!")
```

This should print the words "Hello, world!" on the screen when run.

### Creating a Swift container
Next, we will need to create a file called `Dockerfile` in our working directory. A Dockerfile has a file format that contains instructions and arguments, which define the contents and startup behaviour of the Docker container. The docker container we will create will run the Swift Compiler ontop of a Linux distribution and allow us to begin programming using Swift even on a Windows machine. To run our simple `hello world.swift` file, our Dockerfile will need to contain the following:
```dockerfile
# The first instruction in a Dockerfile must be FROM, which selects a base image. Since it's recommended to use official Docker images, we will use the official image
FROM swift

# Use the WORKDIR instruction to set the working directory, which we will use to store the code we want to run
WORKDIR /app

# Use the ADD instruction to copy our source code from the current directory into the working directory
ADD . ./

# Run the Swift exectutable when the container is started
ENTRYPOINT ["swift"]
```

The above Docker file will create an image based on the official Swift Docker image. When the image is built, it will copy the contents of the local directory into a folder named `/app` inside the image. This allows us to access and run the file inside the container. 

To build an image containing our simple `hello world.swift` file, we can run the following command:
```bash
docker build -t my-swift-image .
```

Thats it! We've made a Docker image containing Swift and our `hello world.swift` file. To run our Docker container and execute the `hello world.swift` file, run the following command:
```bash
docker run --rm my-swift-image "hello world.swift"
```
You should now see `Hello, world!` printed on the terminal... But wait, doesn't that mean each time we make a change to our code we will have to re-build the docker image? While we certainally could do this, it wouldn't be the most efficient method available to us.

### Editing Swift code inside of our Docker container on-the-fly
Instead of re-building our custom Docker image each time we change our code, we can run it and attach the local directory to it. To demonstrate that this is possible, lets begin with making a small change to our `hello world.swift` file. Change its contents to the following so that it will print a different line to the screen:
```swift
import Swift
print("Hello, cruel world!")
```

Using the following command to start a container with our custom image, attach the current directory to the `/app` folder and execute the `hello world.swift` file we just modified:
```bash
docker run --rm -v $(pwd):/app -it my-swift-image "hello world.swift"
```
You should now see `Hello, cruel world!` printed to the terminal!

### Using Swift interactivly inside a Docker container
Another option would be to use the official Swift image instead of our custom one. To start a container with the official Swift Docker image, you can run the following command:
```bash
docker run --rm -v "$(pwd)":/app -it swift
```
This will create a temporary container running Swift in interactive mode, allowing you to execute Swift commands inside a terminal environment. Lets tell Swift to execute our  `hello world.swift` file by using the following command:
```bash
swift run "/app/hello world.swift"
```
Once again you should see `Hello, cruel world!` printed to the terminal.

## Summary
Thats it! In this post we have demonstrated how easy it is to run swift code inside a Docker container. In future posts we will look at how we can containerise and run server-side Swift applications.

## References
- [Swift][1]

[1]: https://swift.org/ "swift.org"