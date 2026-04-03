// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "EBox",
    platforms: [.macOS(.v12), .iOS(.v15), .macCatalyst(.v15)],
    products: [
        .library(name: "EBox", targets: ["EBox"])
    ],
    targets: [
        .target(name: "EBox")
    ]
)
