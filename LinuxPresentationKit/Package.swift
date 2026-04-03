// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LinuxPresentationKit",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(name: "LinuxPresentationKit", targets: ["LinuxPresentationKit"])
    ],
    dependencies: [
        .package(path: "../PresentationKit")
    ],
    targets: [
        .target(
            name: "LinuxPresentationKit",
            dependencies: [
                .product(name: "PresentationKit", package: "PresentationKit")
            ]
        )
    ]
)
