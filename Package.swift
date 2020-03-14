// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "MikeGoughMe",
    products: [
        .executable(name: "MikeGoughMe", targets: ["MikeGoughMe"])
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.5.0"),
        .package(url: "https://github.com/SwiftyGuerrero/CNAMEPublishPlugin", from: "0.1.0"),
        .package(url: "https://github.com/wacumov/VerifyResourcesExistPublishPlugin", from: "0.1.0"),
        .package(url: "https://github.com/labradon/minifycsspublishplugin", from: "0.1.0"),
        .package(url: "https://github.com/Ze0nC/ColorfulTagsPublishPlugin", .branch("master")),
        .package(url: "https://github.com/alexito4/ReadingTimePublishPlugin", from: "0.1.0"),
        .package(url: "https://github.com/alex-ross/highlightjspublishplugin", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "MikeGoughMe",
            dependencies: [
                "Publish",
                "CNAMEPublishPlugin",
                "VerifyResourcesExistPublishPlugin",
                "MinifyCSSPublishPlugin",
                "ColorfulTagsPublishPlugin",
                "ReadingTimePublishPlugin",
                "HighlightJSPublishPlugin"
            ]
        )
    ]
)