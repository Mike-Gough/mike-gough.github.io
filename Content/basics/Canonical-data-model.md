---
date: 2020-08-16 10:00
title: Canonical Data Models
description: A look at what Canonical Data Models are, including some of their features and examples of situations in which they can be useful.
tags: Basics, Design Patterns, Messaging Patterns
---

## Canonical Model Design Pattern
A *Canonical Model* is an messaging pattern which provides an additional level of abstraction over data formats which are designed independantly of any one application. This pattern involves creating a messaging or data model that can be leveraged by multiple consumers either directly or indirectly. When new applications or integrations are created, they only need to perform transformations between the *Canonical Data Model* and their own data formats.

The *Canonical Model* design pattern gives you the opertunity to make an integrations between applications easier to understand and maintain. Arguably its most important feature is that it allows for decoupling the underlying data formats of application from one another. It lends itself to being used in situations such as *Event Driven* architectures where several applications work together through Messaging. It is also often used also in Service Oriented Architectures which promote the reuse of data structures, attributes and data types between applications.

## Intent
This design pattern is used for a variety of reasons including to:

* Standardise data models, helping to minimise dependancies when integrating applications that use different data formats
* Expose reusable services with standardised service contracts
* Reduce the learning curve of developers and simplify the development of integrations between systems
* Reduce the amount of data dormats that data scientists need to learn and work with

While standardised data models can help to simplify the understanding and implementation of data formats, one drawback is that it is time-consuming and complex to implement as the data model must be designed and produced from scratch. This can  become cumbersome and difficult to maintain as the data model grows in size.

## Problem
As with any design pattern its important to understand examples of situations in which they can be useful, so lets look at common example with multiple data sources and consumers.

An organisation has three applications containing customer data. The first application stores the customers full name. The second stores the customers first name, middle name and last name. The third stores the customers first and last name. 

In this situation each consumer of customer data must translate the three source data formats into their own internal data format. Translation logic is duplicated between consumers and adding new sources becomes a painful process as each consuming application needs to be updated.

As a result, a *Canonical Data Model* may be required in order to decouple the data formats and translation that needs to occur between these applications.

## Summary
Canonical Data Models are a design pattern that can be used to simplify the implementation and maintenance cost of integrations between applications. Consumers only need to perform transformations between the *Canonical Data Model* and their own data formats.

However it typically involves high upfront design costs and its benefits can't be fully realised unless it is applied to all data consumers and providers. This can be difficult to achieve without buy-in from their respective maintainers or the use of an Enterprise Service Bus.