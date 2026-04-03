// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftUIPresentationKit",
    platforms: [.macOS(.v12)],
    products: [
        .library(name: "SwiftUIPresentationKit", targets: ["SwiftUIPresentationKit"])
    ],
    dependencies: [
        .package(path: "../PresentationKit"),
        .package(path: "../ReactiveTech")
    ],
    targets: [
        .target(
            name: "SwiftUIPresentationKit",
            dependencies: [
                .product(name: "PresentationKit", package: "PresentationKit"),
                .product(name: "ReactiveTech", package: "ReactiveTech")
            ]
        )
    ]
)
