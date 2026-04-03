// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "UIKitPresentationKit",
    platforms: [.macOS(.v12), .macCatalyst(.v13)],
    products: [
        .library(name: "UIKitPresentationKit", targets: ["UIKitPresentationKit"])
    ],
    dependencies: [
        .package(path: "../PresentationKit"),
        .package(path: "../ReactiveTech")
    ],
    targets: [
        .target(
            name: "UIKitPresentationKit",
            dependencies: [
                .product(name: "PresentationKit", package: "PresentationKit"),
                .product(name: "ReactiveTech", package: "ReactiveTech")
            ]
        )
    ]
)
