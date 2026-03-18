// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "OperantKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "OperantKit",
            targets: ["OperantKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", exact: "6.10.2"),
    ],
    targets: [
        .target(
            name: "OperantKit",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
            ],
            path: "Sources",
            exclude: ["Info.plist"]),
        .testTarget(
            name: "OperantKitTests",
            dependencies: [
                "OperantKit",
                .product(name: "RxTest", package: "RxSwift"),
            ],
            path: "Tests",
            exclude: ["Info.plist"]),
    ],
    swiftLanguageVersions: [.v5]
)
