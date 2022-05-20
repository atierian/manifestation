// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Manifestation",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "manifestation",
            targets: ["Manifestation"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/atierian/swift-package-manager",
            branch: "main"
        ),
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            branch: "main"
        )
    ],
    targets: [
        .executableTarget(
            name: "Manifestation",
            dependencies: [
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                ),
                .product(
                    name: "SwiftPM",
                    package: "swift-package-manager"
                )
            ]
        ),
        .testTarget(
            name: "ManifestationTests",
            dependencies: ["Manifestation"]),
    ]
)
