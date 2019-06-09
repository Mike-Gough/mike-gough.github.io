---
layout: post
title:  Setup Subsystem for Linux on Windows 10
date:   2019-06-08 14:20:00
tags:
  - Windows
  - Linux
---
Windows Subsystem for Linux (WSL) lets developers run GNU/Linux code side-by-side with Windows processes. In this post we will walk through how you can setup WSL.
<!--more-->

## Prerequisites
To keep things simple, we will assume you have the following:
* A Windows 10 Machine with build 16215 or later
* An administrator account
* A Windows Store account

## What is WSL?
WSL is an optional feature of Windows 10 that allows Linux programs to run nativly on Windows. It was originally desiged by Microsoft in partnetship with Canonical (the creators of Ubuntu) and provides an environment that looks and behaves just like Linux. At a high level this allows you to run Linux code without having to fire up a Virtual Machine.

## Why WSL?
WSL gives Windows users access to powerful Linux applications and GNU tools such as find, awk, sed and grep. Although not all Linux applications can be used, it comes with software package tools such as apt and dpkg which can be used to install applications. WSL shows its utility in Continuous Integration and Continuous Delivery environmens that make use of open source software, as many open source tools and libraries assume developers are using Linux. While tools such as Docker help to ensure developed applications can be run consistently, WSL helps to ensure they can be developed consistently.

## Enable WSL

Begin by opening PowerShell as an Administrator and running the following command:
```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```
Then restart your if prompted.

## Install your Linux Distribution of Choice

To download and install your preferred distribution of linux, open the Windows Store and search for ```WSL``` or click on one of the links below:

* [Ubuntu](https://www.microsoft.com/store/p/ubuntu/9nblggh4msv6)
* [OpenSUSE](https://www.microsoft.com/store/apps/9njvjts82tjx)
* [SLES](https://www.microsoft.com/store/apps/9p32mwbh6cns)
* [Kali Linux](https://www.microsoft.com/store/apps/9PKR34TNCV07)
* [Debian GNU/Linux](https://www.microsoft.com/store/apps/9MSVKQC78PK6)

On the distributions page, click the _Get_ button. After pressing get, you may find you need to hit an _Install_ button. Once your Linux distribution is installed, you must initialize it before it can be used. 

## Initialising a new Linux Distribution
To complete the initialisation of your newly installed distribution,you'll need to launch an instance of it. You can do this by clicking the _Launch_ button inside the Windows Store, or by launching it from the Start menu. The first time a newly installed distribution launches, a Console window will open and you'll be asked to wait for the installation to complete. 

Once the distributions files are de-compressed and stored on your PC, you'll be prompted to setup a new Linux user account. When prompted, enter a new UNIX username and password. The user account that will created is a normal (non-administrator) user that you'll be logged-in as by default when launching the discribution. Make sure to chose a password you will remember, as when elevating your prilidges (using sudo), you will need to enter your password.

## Updating and upgrading your distributons packages
Most distributions ship with an minimal packages to keep the initial download size small. Microsoft recommend regularly updating your package catalog, and upgrading your installed packages using the distributions preferred package manager:
* On Debian/Ubuntu, you use apt:
  ```
  sudo apt update && sudo apt upgrade
  ```
* On OpenSuse, you use zypper:
  ```
  sudo zypper refresh && sudo zypper update
  ```

## Summary
We have walked through how to enable WSL, install a Linux Distribution and ensure it is up to date. You should now have a working Linux Distribution on your Windows 10 Machine that you can use to run bash scrips and much more.

## References
- [About the Windows Subsystem for Linux][1]
- [Install on Windows 10][2]
- [Initialize distro][3]

[1]: https://docs.microsoft.com/en-us/windows/wsl/about "About the Windows Subsystem for Linux"
[2]: https://docs.microsoft.com/en-us/windows/wsl/install-win10 "Install on Windows 10"
[3]: https://docs.microsoft.com/en-us/windows/wsl/initialize-distro "Initialize distro"
