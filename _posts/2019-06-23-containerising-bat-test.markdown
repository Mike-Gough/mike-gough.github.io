---
layout: post
featured: true
title:  Black-box testing with MuleSoft's Blackbox Automated Testing (BAT) CLI
date:   2019-06-23 06:00:00
tags:
  - Docker
  - Mule ESB
---
In this post we will walk through how you can run a simple test using the BAT CLI inside of a Docker container.
<!--more-->
## Prerequisites
To keep things brief, we will assume you already have Docker installed and setup correctly.

## What is the BAT CLI?

![MuleSoft logo](/assets/images/posts/mulesoft-logo.svg)

The BAT CLI is an API Functional Monitoring tool produced by MuleSoft for assuring the quality and reliablility of APIs. It provides a convenient method for those working in the MuleSoft technology stack to implement Black-box testing and Runtime monitoring. Using dataweave, it is possible to develop tests that validate the behavior of APIs against live upstream systems, based on inputs and outputs. Additionally, it has a monitoring capability that allows you to verify that deployed APIs are operating as expected and output test results in a variety of formats as a once off operation or on a schedule.

## Test Writing Language

To begin with, we will need to create file called ```tests/example.dwl``` in our working directory. As the ```dwl``` file extension indicates, our test will be written using the Dataweave language. Dataweave is an expression language introduced by MuleSoft for transforming data. Within Dataweave, we will use an embeded Domain Specific Language (DSL) called Behaviour Driven Developmenmt (BDD), which has a similar syntax to other testing frameworks, to define our test. The following example shows a typical API test written using BDD in Dataweave, add the example to the ```tests/example.dwl``` file:
```
%dw 2.0 // Dataweave 2.0
import * from bat::BDD // Behaviour Driven Development (BDD) Domain Spesific Langage (DSL)
import * from bat::Assertions // Common matchers (i.e. mustEqual, mustMatch, every, oneOf, assert, etc.)
---
// Defines a suite of related tests
suite("Example") in [

  // The result of the test must be 200 to be considered a success
  it must 'return 200' in [

    // Perform a GET request
    GET `$(config.base_url)/zen` with {} assert [
      
      // Assert that the HTTP response code recieved was 200
      $.response.status mustEqual 200
    ] 
  ]
]
```

The ```$(config.base_url)``` section from the above example indicates that the test is expecting us to provide the Base URL as a configuration item, rather than hard code it within the test. Building our test in this way gives us the ability to change the Base URL so that our test can be executed against different environments. To store our config, we will need to create a ```config``` folder and add some configuration files to it. Lets create a file called ```config/default.dwl``` with the following contents:
```
%dw 2.0 // Dataweave 2.0
---
config::local::main({})
```
Next, create a config file for our production configuration called ```config/prod.dwl``` with the following contents:
```
%dw 2.0
---
{
  base_url: 'https://api.github.com'
}
```

Then, we need to create a manifest file called ```bat.yaml``` which will define the tests to be run as well as the type and location of the report to be produced by BAT. The file should have the following contents:
```
# Name of the test suite
suite:
  name: "Example Test Suite"

# A list of tests to be executed
files:
  - file: ./tests/example.dwl

# A list of reports to be produced
reporters:
  - type: HTML
    outFile: /usr/src/mymaven/results.html
```
Your working directory should now contain the following file structure:
```
working-directory
├── bat.yaml
├── tests
│   └── example.dwl
└── config
    ├── default.dwl
    └── prod.dwl
```

## Validating a Test Suite
To validate the files and folders we have created, we can run BAT inside a Docker container and provide some additional command line options. From the base of the working directory, run the following command:
```
docker run --init --rm -v "${PWD}":/usr/src/mymaven mikeyryan/mule-blackbox-automated-testing:latest bat.yaml --config=prod --validate
```
  ```bat.yaml``` tells BAT the directory the location of the manifest file.
  ```--config=prod``` selects a configuration file named prod (from the config folder) and registers the result as a global variable for interpolation by our tests

## Running a Test Suite
To execute the tests defined in the manifest file, we can run BAT inside a Docker container using the following command:
```
docker run --init --rm -v "${PWD}":/usr/src/mymaven mikeyryan/mule-blackbox-automated-testing:latest bat.yaml --config=prod
```
The output of the command should match the below:
```
BAT Version: 1.0.96
#  File: ./tests/example.dwl
    
    Example
        
        return 200
          ✓ GET https://api.github.com/zen (981.18ms)
            ✓ 200 must equal 200
```

## Summary
We have previously walked through how to containerise BAT and now we've demonstrated how easy it is to develop and run BAT tests inside Docker containers.

## References
- [Docker Hub - MuleSoft docker images][1]
- [Mulesoft - Install BAT][2]
- [BAT CLI Reference][3]
- [BAT BDD Reference][4]

[1]: https://hub.docker.com/r/mikeyryan/mule-blackbox-automated-testing "mikeyryan/mule-blackbox-automated-testing"
[2]: https://docs.mulesoft.com/api-functional-monitoring/bat-install-task "BAT Installation"
[3]: https://docs.mulesoft.com/api-functional-monitoring/bat-command-reference "BAT CLI Reference"
[4]: https://docs.mulesoft.com/api-functional-monitoring/bat-bdd-reference "BAT BDD Reference"