// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FlameSteelEngine2SceneEditor",
    defaultLocalization: "en",
    dependencies: [
        .package(path: "PresentationKit"),
        .package(path: "ReactiveTech"),
        .package(path: "SceneControls"),
        .package(path: "EBox")
    ],
    targets: [
        .executableTarget(
            name: "FlameSteelEngine2SceneEditor",
            dependencies: [
                .product(name: "PresentationKit", package: "PresentationKit"),
                .product(name: "ReactiveTech", package: "ReactiveTech"),
                .product(name: "SceneControls", package: "SceneControls"),
                .product(name: "EBox", package: "EBox")
            ],
            path: "src",
            resources: [.process("Resources")]
        )
    ]
)
