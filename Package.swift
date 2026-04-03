// swift-tools-version: 5.9
import PackageDescription

var dependencies: [Package.Dependency] = [
    .package(path: "PresentationKit"),
    .package(path: "ReactiveTech"),
    .package(path: "SceneControls"),
    .package(path: "EBox"),
    .package(path: "WxClientPresentationKit")
]

var targetDependencies: [Target.Dependency] = [
    .product(name: "PresentationKit", package: "PresentationKit"),
    .product(name: "ReactiveTech", package: "ReactiveTech"),
    .product(name: "SceneControls", package: "SceneControls"),
    .product(name: "EBox", package: "EBox"),
    .product(name: "WxClientPresentationKit", package: "WxClientPresentationKit")
]

let package = Package(
    name: "FlameSteelEngine2SceneEditor",
    defaultLocalization: "en",
    platforms: [.macOS(.v10_15)],
    dependencies: dependencies,
    targets: [
        .executableTarget(
            name: "FlameSteelEngine2SceneEditor",
            dependencies: targetDependencies,
            path: "src",
            resources: [.process("Resources")]
        )
    ]
)
