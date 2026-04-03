// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "EBox",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(name: "EBox", targets: ["EBox"])
    ],
    targets: [
        .target(name: "EBox")
    ]
)
