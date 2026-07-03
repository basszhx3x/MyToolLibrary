// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MyToolLibrary",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "MyToolLibrary",
            targets: ["MyToolLibrary"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "20.0.0"),
        .package(url: "https://github.com/iAmMccc/SmartCodable.git", branch: "main"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.6.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
        .package(url: "https://github.com/sunshinejr/SwiftyUserDefaults.git", from: "5.0.0"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0"),
        .package(url: "https://github.com/CoderMJLee/MJRefresh.git", from: "3.7.5"),
        .package(url: "https://github.com/SwipeCellKit/SwipeCellKit", from: "2.7.1"),
        .package(url: "https://github.com/marmelroy/Localize-Swift.git", from: "3.0.0"),
        .package(url: "https://github.com/malcommac/SwiftDate.git", from: "7.0.0"),
    ],
    targets: [
        .target(
            name: "MyToolLibrary",
            dependencies: [
                "KeychainSwift",
                "SmartCodable",
                "SnapKit",
                "Kingfisher",
                "Alamofire",
                "SwiftyUserDefaults",
                "SwiftyJSON",
                "MJRefresh",
                "SwipeCellKit",
                "Localize-Swift",
                "SwiftDate",
            ],
            path: "Sources",
            resources: [
                .process("Assets"),
                .process("MyToolLibrary/Resources"),
            ]
        ),
        .testTarget(
            name: "MyToolLibraryTests",
            dependencies: ["MyToolLibrary"]
        ),
    ]
)
