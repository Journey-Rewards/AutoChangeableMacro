// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "AutoChangeable",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "AutoChangeable",
            targets: ["AutoChangeable"]
        ),
        .executable(
            name: "AutoChangeableClient",
            targets: ["AutoChangeableClient"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/openium/swift-syntax-xcframeworks", exact: "600.0.1"),
    ],
    targets: [
        .macro(
            name: "AutoChangeableMacros",
            dependencies: [
                .product(name: "SwiftSyntaxWrapper", package: "swift-syntax-xcframeworks")
            ]
        ),
        .target(name: "AutoChangeable", dependencies: ["AutoChangeableMacros"]),
        .executableTarget(name: "AutoChangeableClient", dependencies: ["AutoChangeable"]),
    ]
)
