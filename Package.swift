// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ChimpionTools",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "ChimpionTools",
            targets: ["ChimpionTools"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", .upToNextMajor(from: "20.0.0")),
        .package(url: "https://github.com/iAmMccc/SmartCodable.git", branch: "main"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.6.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
        .package(url: "https://github.com/sunshinejr/SwiftyUserDefaults.git", from: "5.0.0"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0"),
        .package(url: "https://github.com/CoderMJLee/MJRefresh.git", from: "3.7.5"),
        .package(url: "https://github.com/SwipeCellKit/SwipeCellKit", from: "2.7.1"),
        .package(url: "https://github.com/marmelroy/Localize-Swift.git", .upToNextMajor(from: "3.2.0")),
        .package(url: "https://github.com/malcommac/SwiftDate.git", from: "7.0.0"),
    ],
    targets: [
        .target(
            name: "ChimpionTools",
            dependencies: [
                .product(name: "KeychainSwift", package: "keychain-swift"),
                .product(name: "Localize_Swift", package: "Localize-Swift"),
                "SmartCodable",
                "SnapKit",
                "Kingfisher",
                "Alamofire",
                "SwiftyUserDefaults",
                "SwiftyJSON",
                "MJRefresh",
                "SwipeCellKit",
                "SwiftDate",
            ],
            path: "Sources",
            resources: [
                .process("Assets"),
                .process("ChimpionTools/Resources"),
            ]
        ),
        .testTarget(
            name: "ChimpionToolsTests",
            dependencies: ["ChimpionTools"]
        ),
    ]
)
