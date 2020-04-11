// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GridView",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(
            name: "GridView",
            targets: ["GridView"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nerdsupremacist/VariadicViewBuilder.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "GridView",
            dependencies: ["VariadicViewBuilder"]),
    ]
)
