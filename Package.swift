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
    targets: [
        .executableTarget(
            name: "FlameSteelEngine2SceneEditor",
            path: "src",
            exclude: excludedSources
        )
    ]
)
