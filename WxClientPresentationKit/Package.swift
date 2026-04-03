// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WxClientPresentationKit",
    platforms: [.macOS(.v12), .iOS(.v14), .macCatalyst(.v14)],
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
