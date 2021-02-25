// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HUDKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "HUDKit",
            targets: ["HUDKit"]
        ),
    ],
    dependencies: [
        .package(name: "SFSafeSymbols", url: "https://github.com/piknotech/SFSafeSymbols.git", .upToNextMajor(from: .init(2, 1, 0)))
    ],
    targets: [
        .target(
            name: "HUDKit",
            dependencies: [
                "SFSafeSymbols"
            ]
        ),
        .testTarget(
            name: "HUDKitTests",
            dependencies: ["HUDKit"]
        ),
    ]
)
