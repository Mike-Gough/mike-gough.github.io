---
date: 2019-05-18 09:45
title: Git pre-commit hook for Linting RESTful API Modelling Language (RAML)
description: Continuous Integration (CI) is a practice that requires developers to push code into a shared repository several times a day. When pushing our code to a shared repository, we should strive to ensure that our code is syntactically correct and builds so that other developers can grab the latest copy and begin iterating upon it easily. Today we are going to look at this principle and how we can easily identify and correct common coding mistakes when designing Service Contracts for Application Programming Interfaces (APIs). Specifically, we will explore how we can use Git hooks as a mechanism for ensuring a RAML Service Contract is valid using a Linter called RAML Enforcer.
tags: Articles, Linting, Git, CI/CD, RAML
---

## What is RAML Enforcer?
*RAML Enforcer* is a Linter which can be used to examine source code for programatic errors, bugs, stylistic errors or suspicious patterns. In a CI toolchain, *Linting* is performed very early in the workflow, usually prior to running unit tests or integrating code into a shared repository. *RAML Enforcer* is configurable through command line arguments and provides developers with the option to select from a set of prepackaged rules to enforce coding standards. In this case, we are interested in automatically checking our Service Contract for programatic errors and bugs prior to committing any changes.

## How can RAML Enforcer be run automatically?
Git has a mechanism for triggering scripts when interesting events occur, called hooks. There are two main categories of hooks, client side and server side. To address our goal of checking the quality of our RAML before integrating it into our local version control repository, we will look at using a local pre-commit hook. So.. what is a pre-commit hook, you ask? A pre-commit hook is a script that Git executes before committing staged files in the repository. In this case it will allow us to inspect the snapshot that’s about to be committed and see if it meets our code quality standards. Pre-commit hooks reside in local repositories within the `.git/hooks` directory.

Assuming that you already have a Git repository that contains a RAML Service Contract that you’d like to *Lint*, let's begin by navigating to the `.git/hooks` directory and creating a file called `pre-commit```. Add the following contents to the file, replacing `<main-raml-file-path>` with the path to your main RAML file:
```bash
#!/bin/sh
echo "# Running RAML Enforcer"
sudo docker run \
  --init --rm \
  --volume $(pwd):/tmp "mikeyryan/raml-enforcer:latest" \
  /tmp/<main-raml-file-path>
```
Hooks need to be executable, so you may need to change the file permissions of `pre-commit` if you're creating it from scratch. You can do so by running the following command:
```bash
chmod +x pre-commit
```

## Seeing it in action
Now that we have a pre-commit hook in place for our repository, lets see how it looks! Make a change to your RAML Service Contract, then try and commit it. You should see a report like this printed to the screen:

![Git hook screenshot](/images/posts/git-hook-linter-commit.svg)

When *RAML Enforcer* detects that the Service Contract contains errors or does not meet code standards, it prevents your staged files from being committed.

## Further reading
* [Atlassian - Git hooks](https://www.atlassian.com/git/tutorials/git-hooks)
* [Customising Git - Git Hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)
