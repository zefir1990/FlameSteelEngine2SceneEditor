// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MacOSPresentationKit",
    products: [
        .library(name: "MacOSPresentationKit", targets: ["MacOSPresentationKit"])
    ],
    dependencies: [
        .package(path: "../PresentationKit")
    ],
    targets: [
        .target(
            name: "MacOSPresentationKit",
            dependencies: [
                .product(name: "PresentationKit", package: "PresentationKit")
            ]
        )
    ]
)
