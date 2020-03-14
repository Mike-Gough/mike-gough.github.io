---
date:  2019-05-20 16:25
title: Continuous Deployment with GitHub Actions and Docker Hub
description: In this post we will assume that you practice Continuous Integration (CI) and have a product which is packaged as a Docker image. As your next step you are looking to implement Continuous Deployment (CD) from scratch or move to it from a Continuous Delivery workflow. Our aim will be to build and push a docker image to Docker Hub using GitHub actions.
tags: Articles, Docker, GitHub, CI/CD, RAML
---

## Principles
Before we dive into how we can achieve this goal, it’s important to understand the principles behind what we are trying to achieve and why. If you’re already familiar with Continuous Delivery and Continuous Deployment as well as the distinction between the two, feel free to skip this next part.

### What is Continuous Delivery?
Continuous Delivery is a software development discipline where you build software in such a way that the it can be released to production at any time<sup>[1]</sup>. In a Continuous Delivery workflow, each development change that is pushed to the main repository is ready to be shipped. However, the action of shipping requires human approval. Although there is usually a focus on automated testing as part of this process, in many organisations the risk of promoting a release to production is shouldered by the individual approving that release. Onus is placed on the developers to prioritise keeping the code deliverable over implementing new features.

### How does Continuous Delivery differ from Continuous Deployment?
By contrast, in Continuous Deployment each development change that is pushed to the main repository is automatically released to production, without any human intervention. In this workflow, a strong emphasis is placed on automated testing, as it should not be possible to merge code into the main development branch without that code passing a test suite. This means that the quality of your test suite determines the level of risk for a release, and automated testing must be prioritised during development. As such it’s important to ensure you don’t fall into the trap of mistaking good code coverage in your test suite for good quality tests. Developers within the team must ensure that the quality of tests presented in code reviews remains high.

## Using Github actions for Continuous Deployment
Now that we understand what Continuous Deployment is and what we are aiming for, let’s create a workflow that builds a Docker image and publishes it to Docker Hub. To begin, you’ll need to navigate to GitHub, ensure you are logged in and have opened the repository that you would like to work with. The repository should already contain a `Dockerfile`. Click the *Actions* button at the top of the page:
![GitHub actions button](/images/posts/github-actions-title-bar.jpg)

GitHub will prompt you to confirm that you’d like to create a new workflow, click the *Create a new workflow* button:
![Git hook screenshot](/images/posts/github-actions-create-button.jpg)

Leave the name of the file as `main.workflow` and click the button labelled *Edit file*
![Git hook screenshot](/images/posts/github-actions-heading.jpg)

Add the following to the contents of the editor, replacing `<project-name>` and `<docker-hub-username>` with the name of your project and username for Docker Hub:
```plaintext
# Create a new workflow that’s triggered by a push to master
workflow "Build on push" {
  on = "push"
  resolves = [
    "Push Docker image with build number",
    "Push Docker image with latest",
    "Archive release"
  ]
}

# Optionally add an action to run your test suite here

# Filter pushes to only those on the master branch
action "Filter for master" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

# Login to Docker Hub with your credentials (The GitHub UI will prompt you for them if they have not already been provided).
action "Authenticate with Docker Registry" {
  uses = "actions/docker/login@master"
  needs = ["Filter for master"]
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

# Build a docker image based off of a Dockerfile in the root directory of the repository
action "Build Docker Image" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Authenticate with Docker Registry"]
  args = "build -f Dockerfile --tag <project-name> ."
}

# Give the docket image a unique tag based on the GitHub SHA
action "Tag Docker Image with build number" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Build Docker Image"]
  args = "tag <project-name> <docker-hub-username>/<project-name>:$GITHUB_SHA"
}

# Automatically push the image to Docker Hub
action "Push Docker image with build number" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Tag Docker Image with build number"]
  args = "push <docker-hub-username>/<project-name>:$GITHUB_SHA"
}

# Filter for a tag which indicates that this push is a release (i.e. the push is tagged with v1.0.0)
action "Filter for tag" {
  uses = "actions/bin/filter@master"
  needs = ["Push Docker image with build number"]
  args = "tag v*"
}

# Tag the docket image as latest
action "Tag Docker Image with latest" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Filter for tag"]
  args = "tag <project-name> <docker-hub-username>/<project-name>:latest"
}

# Automatically push the image tagged latest to Docker Hub
action "Push Docker image with latest" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Tag Docker Image with latest"]
  args = "push <docker-hub-username>/<project-name>:latest"
}

# Create a release ZIP archive and add it to the repository
action "Archive release" {
  uses = "lubusIN/actions/archive@master"
  needs = ["Filter for tag"]
  env = {
    ZIP_FILENAME = "<project-name>"
  }
}
```

That was a lot to digest, so let’s take a look at the actions in this workflow. The workflow is trigged by any push to the repository. The first action filters out all pushes other than those to the master branch. It then attempts to login to Docker Hub using the credentials you have supplied as secrets.

Once authenticated, an action builds a Docker image, another tags it and yet another pushes it to Docker Hub. The next action is a filter, it checks if the push to the master branch was tagged as a release. If the push was a release then the next action tags the Docker image as latest and another pushes it to Docker Hub. Finally, an action zips the source code up and publishes it to the release page on GitHub.

To see all of this in action, commit the `main.workflow` file to the repository. Navigating to the actions tab should now show any in-progress builds as well as historical ones:

![Git hook screenshot](/images/posts/github-actions-run-results.jpg)

## References
- [Martin Fowler - Continuous Delivery][1]

[1]: https://martinfowler.com/bliki/ContinuousDelivery.html        "Martin Fowler - Continuous Delivery"
