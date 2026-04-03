// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ReactiveTech",
    platforms: [.macOS(.v12), .iOS(.v14), .macCatalyst(.v14)],
    products: [
        .library(
            name: "ReactiveTech",
            targets: ["ReactiveTech"]),
    ],
    targets: [
        .target(
            name: "ReactiveTech"
        )
    ]
)
