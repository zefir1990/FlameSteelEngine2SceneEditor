// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WindowsPresentationKit",
    products: [
        .library(name: "WindowsPresentationKit", targets: ["WindowsPresentationKit"])
    ],
    dependencies: [
        .package(path: "../PresentationKit")
    ],
    targets: [
        .target(
            name: "WindowsPresentationKit",
            dependencies: [
                .product(name: "PresentationKit", package: "PresentationKit")
            ]
        )
    ]
)
