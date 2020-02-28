// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OperantKit",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "State",
            targets: ["State"]),
        .library(
            name: "OperantKit",
            targets: ["OperantKit"]),
        .executable(
            name: "FR",
            targets: ["FR"]),
        .executable(
            name: "Conc",
            targets: ["Conc"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
         .package(url: "https://github.com/ReactiveX/RxSwift.git", "5.0.0" ..< "6.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "State",
            dependencies: [],
            path: "Sources/State"),
        .target(
            name: "OperantKit",
            dependencies: ["State"],
            path: "Sources/OperantKit"),
        .target(
            name: "FR",
            dependencies: ["OperantKit"],
            path: "Sources/FR"),
        .target(
            name: "Conc",
            dependencies: ["OperantKit"],
            path: "Sources/Conc"),
        .target(
            name: "OperantKitArchived",
            dependencies: ["RxSwift", "RxCocoa"],
            path: "Sources/Archived"),
        .testTarget(
            name: "OperantKitTests",
            dependencies: ["OperantKitArchived", "RxTest"],
            path: "Tests"),
    ]
)
