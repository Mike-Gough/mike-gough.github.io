---
date: 2020-02-02 06:00
title: Creating Swift microservices using Vapor and MongoDB
description: Learn how to create a server-side RESTful API using Swift and Vapor backed with a NoSQL database for storage and run it all using Docker.
tags: Articles, Swift, Docker, MongoDB, Vapor
---

## Prerequisites
To keep things simple we will assume you have access to a machine running macOS or Linux and have already installed Curl, Swift, Vapor and Docker.

## Creating a MongoDB instance
For this tutorial we will need to setup a local MongoDB instance that we can use for our Todo API. The following command starts a MongoDB container instance, allowing us to execute MongoDB statements against a database instance:
```bash
docker run -d \
  --name mongodb \
  -p 27017-27019:27017-27019 \
  -v ~/data:/data/db \
  mongo:latest
```

## Creating a Vapor project
For this post we will make use of the built in Vapor code generator to create a simple RESTful API for creating, reading, updating and deleting todos. Use vapor to create a new project by running the following command:
```bash
vapor new vapor-todo-api
```
Once the project files have been generated, navigate into the directory by running:
```bash
cd vapor-todo-api
```
In order to connect our Vapor application to a MongoDB database we have to modify some of the generated code to remove the use of SQLite. Let's replace the SQLite dependency and target with MeowVapor inside the `Package.swift` file:
```swift
// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "vapor-todo-api",
    products: [
        .library(
            name: "vapor-todo-api", 
            targets: ["App"]
        ),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(
            url: "https://github.com/vapor/vapor.git", 
            from: "3.0.0"
        ),

        // 🔵 Swift ORM (queries, models, relations, etc) built on Meow, MongoKitten.
        .package(
            url: "https://github.com/OpenKitten/MeowVapor.git", 
            from: "2.1.2"
        )
    ],
    targets: [
        .target(
            name: "App", 
            dependencies: [
                "MeowVapor", 
                "Vapor"
            ]
        ),
        .target(
            name: "Run", 
            dependencies: [
                "App"
            ]
        ),
        .testTarget(
            name: "AppTests", 
            dependencies: [
                "App"
            ]
        )
    ]
)
```
MeowVapor is a wrapper for Meow and MongoKitten and provides us with a boiletplate-free object persitance framework for MongoDB and Swift, freeing us from the need to manage our database. After adding this dependancy we need to modify the generated `Sources/App/configure.swift` file in order to set up the MongoDB driver instead of the default SQLite one. We are going to start by setting the database connection details based on an environment variable `MONGODB_URI`:
```swift
import MeowVapor
import Vapor

// Called before your application initializes.
public func configure(
    _ config: inout Config, 
    _ env: inout Environment, 
    _ services: inout Services) throws {
    
    let uri = Environment.get("MONGODB_URI")
        ?? "mongodb://localhost/tododb"

    // Configure a MongoDB database
    let meow = try MeowProvider(uri: uri)
    
    // Register providers first
    try services.register(meow)

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig()
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)
}
```
Next, we need to change to the `Sources/Models/Todo.swift` file so that our Todo model includes an attributed called `_id` which will be used to store a unique identifier of the type `ObjectId` for our MongoDB documents:
```swift
import MeowVapor
import Vapor

// A single entry of a Todo list.
final class Todo: Model {
    
    // A unique identifier for the `Todo`
    var _id: ObjectId

    // A title describing what this `Todo` entails.
    var title: String

    // Creates a new `Todo`.
    init(_id: ObjectId, title: String) {
        self._id = _id
        self.title = title
    }
    
    // Creates a new `Todo`.
    init(title: String) {
        self._id = ObjectId()
        self.title = title
    }
}

// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension Todo: Content { }

// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension Todo: Parameter {}
```

Then we need to update our routes inside the `Sources/App/routes.swift` file to support the GET, POST, PUT end DELETE methods for the Todo's endpoint:
```swift
import Vapor
import MeowVapor

// Register your application's routes here.
public func routes(_ router: Router) throws {
    let todoController = TodoController()
    
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.put("todos", use: todoController.upsert)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
```

Lastly we will need to build and run our application. To create a Docker image containing our Vapor project, we can use the `web.Dockerfile` file that was automatically generated for us by running the following command:
```bash
docker build --build-arg env=docker -t vapor-todo-api-image -f web.Dockerfile
```
This command may take some time to finish, but when complete we will have made a Docker image containing our compiled Vapor project. The container can be run using the command:
```bash
docker run --name vapor-todo-api -p 8080:80 vapor-todo-api-image
```

## Testing the Todo API
Now that we have a running instance of a MongoDB database and our API, let's test it to ensure it works as expected. To insert a new Todo we can call the POST endpoint that we created using the Curl command:
```bash
curl -X POST \
  -H "Content-Type: application/json" -d '{"_id":"5e36366465da966614a18f46", "title":"My todo!"}' \
   localhost/todos
```
After running this command you should recieve a copy of the created Todo in the API response:
```bash
{"_id":"5e36366465da966614a18f46", "title":"My todo!"}
```

To verify that our Todo was indeed created, we can use our GET endpoint:
```bash
curl -X GET localhost/todos
```
This should print the following to the screen:
```bash
[{"_id":"5e36366465da966614a18f46","title":"My Todo!"}
```

Now that we have verified our Todo was indded created, lets replace it using our PUT endpoint by running:
```bash
curl -X PUT \
  -H "Content-Type: application/json" -d '{"_id":"5e36366465da966614a18f46", "title":"My updated todo!"}' \
  localhost/todos
```
You should recieve a copy of the updated Todo in the API response:
```bash
{"_id":"5e36366465da966614a18f46", "title":"My updated todo!"}
```

Finally we can delete our Todo using our DELETE endpoint by running:
```bash
curl -X DELETE localhost/todos/5e36366465da966614a18f48
```
This should return a HTTP 200 response.

## Summary
That's it! In this post we have demonstrated how to build an RESTful API in Swift that allows you to create, read, update and delete Todo's inside of a MongoDB database. Future posts will look at how we can deploy microservices using kubernetes.

## References
- [Swift][1]
- [Vapor][2]
- [Docker - Get Started][3]

[1]: https://swift.org/ "swift.org"
[2]: https://vapor.codes "vapor.codes"
[3]: https://docs.docker.com/get-started/ "Docker"