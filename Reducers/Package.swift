// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReducersDemo",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "ClientDemo",
            targets: ["ClientDemo"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.

        // Tuist Manifests
        // - Public API / DSL of Tuist
        //
        // e.g. Project, Target, Settings, TuistConfig, Setup
        .target(
            name: "ProjectDescription",
            dependencies: []),

        // A demo of consumer of the libraries
        .target(
            name: "ClientDemo",
            dependencies: [
                "TuistModels",
                "TuistCore",
                "TuistGenerator",
                "ProjectDescription"
        ]),

        // Tuist Models
        // - Plain old data structs to model Projects
        //
        // e.g. Project, Target, Settings
        .target(
            name: "TuistModels",
            dependencies: ["TuistCore"]),
        .testTarget(
            name: "TuistModelTests",
            dependencies: ["TuistModels"]),

        // Project Generator
        // - Transforms project models to XcodeProj
        //
        // e.g. `BuildPhaseGenerator`, `TargetGenerator`
        .target(
            name: "TuistGenerator",
            dependencies: ["TuistCore", "TuistModels"]),

        // Core Utilities
        //
        // e.g. FileHandler, System
        .target(
            name: "TuistCore",
            dependencies: []),
    ]
)
