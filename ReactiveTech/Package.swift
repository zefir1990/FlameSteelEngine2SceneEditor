// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ReactiveTech",
    platforms: [.macOS(.v12), .iOS(.v15), .macCatalyst(.v15)],
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
