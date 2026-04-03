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

#if os(macOS) && !targetEnvironment(macCatalyst)
dependencies.append(.package(path: "SwiftUIPresentationKit"))
targetDependencies.append(.product(name: "SwiftUIPresentationKit", package: "SwiftUIPresentationKit"))
#endif

#if os(macOS) || os(iOS) || targetEnvironment(macCatalyst)
dependencies.append(.package(path: "UIKitPresentationKit"))
targetDependencies.append(.product(name: "UIKitPresentationKit", package: "UIKitPresentationKit"))
#endif

let package = Package(
    name: "FlameSteelEngine2SceneEditor",
    defaultLocalization: "en",
    platforms: [.macOS(.v12), .iOS(.v14), .macCatalyst(.v14)],
    dependencies: dependencies,
    targets: [
        .executableTarget(
            name: "FlameSteelEngine2SceneEditor",
            dependencies: targetDependencies,
            path: "src",
            resources: [.process("Resources")],
            swiftSettings: [
                .define("MACCATALYST", .when(platforms: [.macCatalyst]))
            ]
        )
    ]
)
