// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MoEngage-Swift-Segment",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MoEngage-Swift-Segment",
            targets: ["MoEngage-Swift-Segment"]),
    ],
    dependencies: [
        .package(url: "git@github.com:segmentio/analytics-swift.git", from: "1.3.1"),
        .package(url: "git@github.com:moengage/MoEngage-iOS-SDK.git", from: "9.2.0")
    ],
    targets: [
        .target(
            name: "MoEngage-Swift-Segment",
            path: "Sources/MoEngage-Swift-Segment"),
    ]
)
