// swift-tools-version: 5.9
import PackageDescription

var excludedSources: [String] = []

#if os(Linux)
excludedSources.append("Windows")
excludedSources.append("macOS")
#elseif os(Windows)
excludedSources.append("Linux")
excludedSources.append("macOS")
#elseif os(macOS)
excludedSources.append("Linux")
excludedSources.append("Windows")
#endif

let package = Package(
    name: "FlameSteelEngine2SceneEditor",
    defaultLocalization: "en",
    dependencies: [
        .package(path: "PresentationKit"),
        .package(path: "ReactiveTech"),
        .package(path: "SceneControls")
    ],
    targets: [
        .executableTarget(
            name: "FlameSteelEngine2SceneEditor",
            dependencies: [
                .product(name: "PresentationKit", package: "PresentationKit"),
                .product(name: "ReactiveTech", package: "ReactiveTech"),
                .product(name: "SceneControls", package: "SceneControls")
            ],
            path: "src",
            exclude: excludedSources,
            resources: [.process("Resources")]
        )
    ]
)
