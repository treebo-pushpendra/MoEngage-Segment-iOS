// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Segment-MoEngage",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "Segment-MoEngage",
            targets: ["Segment-MoEngage"]),
    ],
    dependencies: [
        .package(name: "Segment",url: "https://github.com/segmentio/analytics-ios.git", from: "4.0.0"),
        .package(name: "MoEngage-iOS-SDK",url: "https://github.com/moengage/MoEngage-iOS-SDK.git", from: "9.5.0"),
    
    ],
    targets: [
        .target(name: "Segment-MoEngage",
                dependencies: ["Segment","MoEngage-iOS-SDK"],
                path: "Pod/Classes",
                publicHeadersPath: ""

               )
    ]
    
)
