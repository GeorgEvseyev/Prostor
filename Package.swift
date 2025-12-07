// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Element Swift",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "tools", targets: ["Tools"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "1.6.2")),
        .package(url: "https://github.com/GeorgEvseyev/swift-command-line-tools.git", from: "0.1.0"),

        .package(url: "https://github.com/jpsim/Yams", .upToNextMinor(from: "6.2.0"))
    ],
    targets: [
        .executableTarget(name: "Tools",
                          dependencies: [
                            .product(name: "ArgumentParser", package: "swift-argument-parser"),
                            .product(name: "CommandLineTools", package: "swift-command-line-tools"),
                            .product(name: "Yams", package: "Yams")
                          ],
                          path: "Tools/Sources")
    ]
)
