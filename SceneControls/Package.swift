// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SceneControls",
    products: [
        .library(
            name: "SceneControls",
            targets: ["SceneControls"]),
    ],
    dependencies: [
        .package(path: "../PresentationKit"),
        .package(path: "../ReactiveTech")
    ],
    targets: [
        .target(
            name: "SceneControls",
            dependencies: [
                .product(name: "PresentationKit", package: "PresentationKit"),
                .product(name: "ReactiveTech", package: "ReactiveTech")
            ]
        )
    ]
)
