// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ReactiveTech",
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
