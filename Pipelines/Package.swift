// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pipelines",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Pipelines",
            dependencies: []),
        .testTarget(
            name: "PipelinesTests",
            dependencies: ["Pipelines"]),
        
        // Public Manifests API
        .target(
            name: "ProjectDescription",
            dependencies: []),
        
        // Tuist specific logic
        .target(
            name: "TuistKit",
            dependencies: [
                "TuistSupport",
                "ProjectDescription",
                "TuistXcodeProjGenerator"
        ]),
        
        // Model Transformers
        .target(
            name: "TuistTransformers",
            dependencies: []),
        
        // XcodeProj generator
        // Graph > XcodeProj models
        .target(
            name: "TuistXcodeProjGenerator",
            dependencies: ["TuistShared"]),
        
        // Shared models (e.g. Graph)
        .target(
            name: "TuistShared",
            dependencies: [
                "TuistSupport"
        ]),
        .testTarget(
            name: "TuistSharedTests",
            dependencies: ["TuistShared", "TuistSupport"]),
        
        // Utilities (e.g. FileHandler / System)
        .target(
            name: "TuistSupport",
            dependencies: []),
    ]
)
