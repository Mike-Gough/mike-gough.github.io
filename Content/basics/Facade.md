---
date: 2020-03-06 15:00
title: Facades
description: A look at what Facades are, including some of their features and examples of situations in which they can be useful.
tags: Basics, Structural Design Patterns
---

## Facade Pattern
A *Facade* is an design pattern which provides a simplified *interface* that *encapsulates* the inernal implementation details of a larger more complex body of code or one which contains lots of moving parts. When working with such code this patttern can be used to *seperate concerns* from the consumer through a minimalist interface that only exposes the functionality that the consumer really cares about. 

It this way it can thought of as analogous to a shield - as it shields the consumer from the complex details of the code and provides them with a simplified view which is easy to use. This reduces the learning curve required to successfully leverage the code which inturn typically promotes re-use.

While using the Facade design pattern gives you the opertunity to make an application easier to understand and integrate with, arguably its most important feature is that it promotes decoupling the underlying components of the application from consumers. 

Decoupling your applications code can help you to ensure that it is easy to modify without breaking any consumers which may depend on it. It should be used in situations where consumers need a simple facilitator, one that exposes a simplified interface with a *limited* set of *course-grained* behaviors.

## Intent
The intent behind a Facade is to provide a *course-grained interface* that:

* Offers convenient methods for common tasks that makes the code easier to read, use, understand and test
* Reduces the dependencies from consumer code on the internal implementation components of your code, making it easier to change
* Wraps a collection of poorly designed APIs within a single well-designed API

## Problem
As with any design pattern its important to understand examples of situations in which they can be useful, so lets look at common example where a consumer is trying to access your code remotely.

Within a single applications code base, fine-graned APIs can provide a developers with a large number of methods which can be chained together in flexible ways to produce new features for customers. However, one of the consequences of such fine-grained behavious is that interactions between components become tightly coupled and typically require lots of method invocations. 

This becomes particularly problematic with remote calls which are often orders of magnitude more expensive to perform since they typically require data to be serialised, authentication and authorisation checks to be performed, packets to be sent accross a network and so on. As a result a course-grained interface may be required in order to minimise the number of calls needed perform a function.

## Structure
The diagram below provides an example of a coarse-grained interface that's intended to be used by remote consumers that want to minimuse the number of calls needed to get something done:

![Facade structure](/images/posts/Facade-structure.svg)

In this example all the facade does is transalte the coarse-grained methods it exposes into the underlying fine-grained methods in the Customer object.

## Summary
Facades are a design pattern that can be used to simplify access to our code, by pre-defining a *limited* set of behaviours that can be called by a consumer. 

That's a key part though, because Facades are only realy useful when the underlying code is complex, has many moving parts is difficult to understand or use. It often comes at the expense of limiting the features and flexibility available to consumers.