// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swiftui-plus",
    platforms: [
           .iOS(.v15),
    ],
    products: [
        .library(
            name: "SwiftUIPlus",
            targets: ["SwiftUIPlus"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftUIPlus",
            dependencies: [
            ],
            path: "Sources"
        ),
    ]
)
