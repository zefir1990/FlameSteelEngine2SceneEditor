// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PresentationKit",
    products: [
        .library(
            name: "PresentationKit",
            targets: ["PresentationKit"]),
    ],
    dependencies: [
        .package(path: "../ReactiveTech")
    ],
    targets: [
        .target(
            name: "PresentationKit",
            dependencies: [
                .product(name: "ReactiveTech", package: "ReactiveTech")
            ]
        )
    ]
)
