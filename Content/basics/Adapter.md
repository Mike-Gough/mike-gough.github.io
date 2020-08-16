---
date: 2020-03-10 18:00
title: Adapters
description: A look at what Adapers are and how they can be used to allow components with incompatible interfaces to collaborate.
tags: Basics, Structural Design Patterns
---

## Adapter Pattern
An *Adapter* is a structural design pattern that allows applications, or components within applications that have incompatible interfaces to collaborate. This pattern can be thought of as a *wrapper* - as it typically involves wrapping an incompatable interface with a new interface.

## Intent
The intent behind an Adapter is to provide a *interface* that:

* Acts as translator between your code base and legacy, 3rd party or other interfaces
* Promotes decoupling the client from the conrete implementation of the legacy, 3rd party or other interface which may change over time 

## Problem
As with any design pattern its important to understand examples of situations in which they can be useful, so lets look at common example where a consumer requires access to some data but it is not accessible.

Imagine that you are extending an existing client side web application. The Application needs to fetch transaction data in a JSON format so that it can display it inside of a table for the end user. The data you require is currently stored inside of a relational database, but your browser does not provide a method for you to connect directly to this database and run an SQL query to retrieve the data.

You could refactor your client side application into a server side application that is capable of connecting to databases and performing SQL queries, however, this introduces extra complexities to your code base and its deployment. It would also mean significantly delaying your delivery time which ultimatly makes the option undesirable.

## Solution
Instead of significantly refactoring your application you decide to create an *adapter*. 

The adapter acts as a SQL client to the database and invokes SQL queries to fetch the required transactions. It then translates the results of the SQL query into a JSON object that the consumer can understand. This way your client side web application can retrieve the data it needs by making an HTTP call using AJAX to your adapter. 

The diagam below provides a high level example of a protocol adapter, which is a common design pattern found in microservice architectures that allows data to be exposed from legacy systems:

![Adapter pattern](/images/posts/adapter-pattern.svg)

In this example all the adapter does is transalte the results of the SQL queries into JSON and exposes them to the consuming web application.

## Summary
Adapters are a design pattern that can be used to allow applications to send or recieve data that would otherwise be inaccessible to them, by acting as a midleman that *translates* between the two.

An important takeaway is that Adapters are most useful when they are *translating* from one *incompatable interface* to a compatible one. 

This pattern may add unnessisary complexity to your code base if you implement it for interfaces which are already compatible or ones you can change (i.e. are not from a 3rd party) - sometimes its just simpler to change your interfaces.