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
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "509.0.0"..<"602.0.0")
    ],
    targets: [
        .macro(
            name: "AutoChangeableMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "AutoChangeable", dependencies: ["AutoChangeableMacros"]),
        .executableTarget(name: "AutoChangeableClient", dependencies: ["AutoChangeable"]),
    ]
)
