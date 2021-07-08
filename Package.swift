// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Git",
    platforms: [.macOS(.v10_12)],
    products: [
        .library(name: "Git", targets: ["Git"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Git", dependencies: [], path: "Sources")
    ]
)
