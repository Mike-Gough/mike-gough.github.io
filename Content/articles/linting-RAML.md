---
date: 2019-05-16 21:41
title: Linting RESTful API Modelling Language (RAML)
description: Within a Continuous Integration (CI) and Continuous Delivery (CD) environment, the first principles is that no code is delivered without automated tests. Today we are going to look at this principle and how we can easily identify and correct common  coding mistakes when designing Service Contracts for Application Programming Interfaces (APIs). Specifically, we will explore how Linting can be used for this purpose.
tags: Articles, Linting, CI/CD, RAML
---

## What is Linting
*Linting* is the process of using a tool to examine source code for programatic errors, bugs, stylistic errors or suspicious patterns. A *Linter* or *Lint* is a piece of software that supports verifying code quality through *Linting*. Most Linters are highly configurable and extensible, allowing developers to select from a set of prepackaged rules to enforce a particular coding standard, or to invent their own rules as needed.

In a CI toolchain, *Linting* is performed very early in the workflow, usually prior to running unit tests. It is often implemented on the local development machine inside of a pre-commit in distributed Version Control Systems such as *Git* to reject code that does not pass the *Linter* code quality checks. It can also be enforced as part of stage within the build process.

## Where does Linting come from?
*Lint* was the name of a program written in 1978 by Stephen Johnson at Bell Labs to identify problems with C source code before complication and runtime. It was later used in 1979 inside the seventh version of the Unix operating system. Over time the term *Lint* became a verb that meant checking your source code.

## So... why Lint your Service Contracts?
Whether you're implementing a Service Layer, Enterprise Service Bus or Application Network, as your API progresses through the various stages of development, code quality becomes critical. Collaborating with your customers to ensure that the design of an API meets functional requirements is a given, but it's also important to ensure that it doesn't include any structural issues. A poorly structured API can impact the reliability and efficiency of its consumers as well as make the implementation harder. For those employ a micro-services architecture or find themselves working with large teams, a consistent approach to the design of APIs is particularly important for maintainability.

*Linting* can be used to find and resolve both functional and structural issues with an API'cs Service Contract. It can identify and correct common code mistakes without having to run your code or execute tests. Some of the key benefits a *Linter* provides you with include:

* Avoiding errors - they give you immediate feedback about things that look like errors or could potentially be dangerous
* Readability - they can drive you to write cleaner and more constant code
* Maintainability - they can be used to help developers working as part of a team to adhere to a uniform coding standards
* Portability - they can be used within an IDE, text editors such as Visual Studio Code, a command line and continuous integration tools
* Automatic fixes - using a prettier they can enabling code style issues to be fixed automatically

## Integrating Linting into your RAML Service Contract
Unfortunately, at the time of writing most of the RAML *Linters* available are just wrapping an open source parser. Parsing RAML helps to identify errors, but does little in the way of improving the readability or maintainability of your Service Contracts. This is why I decided to build my own *Linter*, called *RAML Enforcer*. *RAML Enforcer* is a command line tool for identifying and reporting on patterns found within RAML code. It supports, RAML 0.8, RAML 1.0, Includes and Fragments.

Although there are a few different options for running *RAML Enforcer*, in this case we will build and run it directly from the source code. To get up and running you'll need to ensure you have Git, Node.js and NPM installed on your local machine. Once you have them, you can begin by opening up your Command Line Interface (CLI) of choice and using it to clone the source code of the project from GitHub:
```bash
git clone https://github.com/Mike-Gough/raml-enforcer
```

Next, you will need to navigate to the repository we just cloned and install the required dependancies for *RAML Enforcer* by running the following command:
```bash
cd raml-enforcer && \
  npm install
```

Finally, you can execute the *Linter* by using the following command, replacing `main-api-file` with the path to the main RAML file for your service contract:
```bash
node raml-enforcer.js <main-api-file>
```

The result will be a report which identifies errors and highlights styling issues:

![RAML Enforcer Report](/images/posts/raml-enforcer-report.svg)

In a future post, we will look at how *RAML Enforcer* can be used in a pre-commit hook.
