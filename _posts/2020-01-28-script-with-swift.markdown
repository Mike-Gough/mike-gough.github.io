---
layout: post
featured: false
title:  Script with Swift
date:   2020-01-28 06:00:00
tags:
  - Swift
---
Learn how to run executable scripts in Swift.
<!--more-->

## Prerequisites
To keep things simple we will assume you have access to a machine running macOS or Linux and have already installed Swift.

## How to script with swift

![Swift logo](/assets/images/posts/swift-logo.svg)

If you are already a Swift developer, you should be familiar with the process of creating a Swift package, application or command line tool. Once you have created one of these you would usually need to build a binary and then place it in a executable path before it can be run from a Command Line Interface (CLI). Sometimes, however, we just want to write a script and execute it as is, rather than package it for deployment. This can be particularly useful if you'd like to use Swift in different stages of the software development lifecycle such as inside of your Continuous Integration or Continuous Deployment pipelines.

In such pipelines, it's typical to create a bash file and execute it. For example you could create a file called ```hello-world``` with the following contents:
```
#!/usr/bin/env bash

echo "Hello, World!"
```
You would then make it executable by running:
```
chmod +x hello-world
```
And then execute it by running:
```
./hello-world
```
But this is not just limited to runtime languages like bash, the comment on the first line tells the machine what program to use when interpreting the file. This means we can create and execute a script using the Swift programming language instead. For example, let's replace the contents of the ```hello-world``` file we created earlier with this:
```
#!/usr/bin/env swift

print("Hello, World!")
```
Now you can execute the script by running the same command as we did earlier:
```
./hello-world
```
Once again you should see the text ```Hello, World!``` printed to the console.

## Summary
That's it! In this post we have demonstrated a simple way to build small Swift scripts that you can modify and run in place whenever you need to, without the need to recompile and deploy them.

## References
- [Swift][1]

[1]: https://swift.org/ "swift.org"