// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "TJExtendedNavigationPop",
    platforms: [.iOS(.v12), .macCatalyst(.v13)],
    products: [
        .library(
            name: "TJExtendedNavigationPop",
            targets: ["TJExtendedNavigationPop"]
        )
    ],
    targets: [
        .target(
            name: "TJExtendedNavigationPop",
            path: ".",
            publicHeadersPath: "."
        )
    ]
)
