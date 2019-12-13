---
layout: post
featured: false
title:  Git Aliases
date:   2019-12-13 06:00:00
tags:
  - Git
---
In this post we will walk through how you can make your git workflow experience simpler and easier with aliases.
<!--more-->
## Prerequisites
To keep things brief, we will assume you already have Git installed and setup correctly.

## What is a Git Alias?
An alias in Git is synonomous with a shortcut and is similar to *aliases* found in command processors such as *Bash*. They can be used to map long, complicated or hard to remember commands into shorter and easier to remember ones that require fewer keystrokes. For example, consider the ```git push``` command. It is frequently used to check in your staged changes, but instead of typing in the word ```commit``` an alias could be created to shorten it to ```c``` allowing ```git c``` to be typed instead. This can be a life changer for longer commands which can be particularly verbose.

## How to create a Git Alias
Git Aliasss can be created using the ```git config``` command in either a local or global scope. To create an alias for commit which you can use in any repository, you can run the following command in your preferred Command Line Interface (CLI):

```
git config --global alias.c commit
```
The previous example can also be modified to use the ```--local``` flag instead of ```--global``` and run from inside of a repository to create a shortcut for just that repository instead any repository, like so:
```
git config --local alias.c commit
```

When the ```config``` command was run with the ```--global``` flag, Git created or modified the ```.gitconfig``` file, which is a hidden file typically located in your User home directory at ```~/.gitconfig```. If you were to inspect the contents of this file, you would see an alias section that looks something like this:
```
[alias]
  c = commit
```
This file can also be edited direcly to add, remove or updatd aliases for advanced users who are familiar with the correct syntax.

## Useful Git Aliases
Here are a few aliases which I have found improved my own git workflow experience:

### 1. Inline Quick Commit
Sometimes you just want to stage and commit all of the files you have modified in the current repository. This command quickly adds the files and commits them:
```
git config --global alias.coi "!git add -A && git commit -m "
```
Which can be run using:
```
git coi <commit message>
```

### 2. Amend the last commit
As developers, we are often optsmistic about our code and have a tendancy to commit our work only to realise we missed a file or forgot to remove a debugging statement. For these occasions, the following alias will ammend the latest commit with all of the changed files in the local repository, without the need to supply a new commit message:
```
git config --global alias.coa "!git add -A && git commit --amend --no-edit"
```
The alias can be run using:
```
git coa
```

### 3. Push to the remote branch
In my git workflow I typically create a branch locally, work on a feature and then want to push my completed work to origin either at the end of the day or once complete (whichever comes first). When I do so for the first time, a branch with the same name does not yet exist on origin so git throws an error. To address this, I use the following alias:
```
git config --global alias.po "!git push origin $(git rev-parse --abbrev-ref HEAD)"
```
Which can be run using:
```
git po
```

### 4. Update Submodules

Some of the Git repositories I work with contian one or more nested submodules, to update them I make use of the following alias:
```
git config --global alias.usr "!git submodule update --init --recursive"
```
This alias can be run using:
```
git usr
```

## Summary
We have previously walked through how to setup git hooks that run test suites and now we've demonstrated how easy it is to simplify your git workflow and create aliases for those commands you use frequently or are hard to remember.

## References
- [Git Basics - Git Aliases][1]
- [Git Hooks][2]

[1]: https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases "Git Basics - Git Aliases"
[2]: https://mike.gough.me/posts/git-hooks.html "Git pre-commit hook"