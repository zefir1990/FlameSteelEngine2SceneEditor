// swift-tools-version: 5.9
import PackageDescription

var dependencies: [Package.Dependency] = [
    .package(path: "PresentationKit"),
    .package(path: "ReactiveTech"),
    .package(path: "SceneControls"),
    .package(path: "EBox")
]

var targetDependencies: [Target.Dependency] = [
    .product(name: "PresentationKit", package: "PresentationKit"),
    .product(name: "ReactiveTech", package: "ReactiveTech"),
    .product(name: "SceneControls", package: "SceneControls"),
    .product(name: "EBox", package: "EBox")
]

#if os(Windows)
dependencies.append(.package(path: "WindowsPresentationKit"))
targetDependencies.append(.product(name: "WindowsPresentationKit", package: "WindowsPresentationKit"))
#elseif os(Linux)
dependencies.append(.package(path: "LinuxPresentationKit"))
targetDependencies.append(.product(name: "LinuxPresentationKit", package: "LinuxPresentationKit"))
#elseif os(macOS)
dependencies.append(.package(path: "MacOSPresentationKit"))
targetDependencies.append(.product(name: "MacOSPresentationKit", package: "MacOSPresentationKit"))
#endif

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
