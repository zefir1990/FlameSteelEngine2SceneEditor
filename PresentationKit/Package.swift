// swift-tools-version: 6.0
import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "PresentationKit",
    platforms: [.macOS(.v12), .iOS(.v14), .macCatalyst(.v14)],
    products: [
        .library(
            name: "PresentationKit",
            targets: ["PresentationKit"]),
    ],
    dependencies: [
        .package(path: "../ReactiveTech"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "600.0.0")
    ],
    targets: [
        .macro(
            name: "PresentationKitMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "PresentationKit",
            dependencies: [
                "PresentationKitMacros",
                .product(name: "ReactiveTech", package: "ReactiveTech")
            ]
        )
    ]
)
