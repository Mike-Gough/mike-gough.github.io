---
date: 2020-03-09 06:25
title: Script with Go
description: Learn how to run executable scripts in Go.
tags: Tips, Go
---

## Prerequisites
To keep things simple we will assume you have access to a machine running macOS or Linux and have already installed [Go](https://golang.org/) and [Gorun](https://github.com/erning/gorun).

## How to script with Go

![Go logo](/images/posts/go-logo.svg)

If you are already a Go developer, you should be familiar with the process of creating a Go package, application or command line tool. Once you have created one of these you would usually need to build a binary and then place it in a executable path before it can be run from a Command Line Interface (CLI). Sometimes, however, we just want to write a script and execute it as is, rather than package it for deployment. This can be particularly useful if you'd like to use Go in different stages of the software development lifecycle such as inside of your Continuous Integration or Continuous Deployment pipelines.

In such pipelines, it's typical to create a bash file and execute it. For example you could create a file called `hello-world` with the following contents:
```bash
#!/usr/bin/env bash

echo "Hello, World!"
```
You would then make it executable by running:
```bash
chmod +x hello-world
```
And then execute it by running:
```bash
./hello-world
```
But this is not just limited to runtime languages like bash, the comment on the first line tells the machine what program to use when interpreting the file. This means we can create and execute a script using the Go programming language instead. For example, let's replace the contents of the `hello-world` file we created earlier with this:
```go
#! /usr/bin/env gorun

package main

import "fmt"

func main() {
	fmt.Printf("hello, world\n")
}
```
Now you can execute the script by running the same command as we did earlier:
```bash
./hello-world
```
Once again you should see the text `Hello, World!` printed to the console.

## Summary
That's it! In this post we have demonstrated a simple way to build small Go scripts that you can modify and run in place whenever you need to, without the need to recompile and deploy them.

## References
- [Go][1]
- [Writing Scripts with Go][2]

[1]: https://golang.org/ "golang.org"
[2]: https://gist.github.com/posener/73ffd326d88483df6b1cb66e8ed1e0bd "Story: Writing Scripts with Go"