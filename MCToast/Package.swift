// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MCToast",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "MCToast",
            targets: ["MCToast"]
        ),
    ],
    targets: [
        .target(
            name: "MCToast",
            path: "Sources"
        ),
    ]
)
