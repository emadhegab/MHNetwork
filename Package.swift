// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MHNetwork",
    products: [
        .library(
            name: "MHNetwork",
            targets: ["MHNetwork"]),
    ],
    targets: [
        .target(
            name: "MHNetwork",
            dependencies: []),
        .testTarget(
            name: "MHNetworkTests",
            dependencies: ["MHNetwork"]),
    ]
)
