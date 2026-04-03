// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WxClientPresentationKit",
    platforms: [.macOS(.v12), .iOS(.v15), .macCatalyst(.v15)],
    products: [
        .library(name: "WxClientPresentationKit", targets: ["WxClientPresentationKit"])
    ],
    dependencies: [
        .package(path: "../PresentationKit")
    ],
    targets: [
        .target(
            name: "WxClientPresentationKit",
            dependencies: [
                .product(name: "PresentationKit", package: "PresentationKit")
            ]
        )
    ]
)
