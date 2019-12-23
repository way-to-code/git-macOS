// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Git",
    products: [
        .library(name: "Git", targets: ["Git-macOS"]),
        ],
    dependencies: [],
    targets: [
        .target(name: "Git-macOS", dependencies: [], path: "Sources"),
        .testTarget(name: "GitTests", dependencies: ["Git-macOS"], path: "Tests")
    ]
)
