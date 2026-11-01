// swift-tools-version: 6.2
// tools-version は manifest の API の版。ツールチェーンの版は .swift-version。
// より古い tools-version を落としては確かめていない。

import PackageDescription

let package = Package(
    name: "NeNeSummit",
    targets: [
        .target(
            name: "NeNeSummitCore",
            swiftSettings: [.treatAllWarnings(as: .error), .enableUpcomingFeature("ExistentialAny")]
        ),
        .target(
            name: "NeNeSummitEngine",
            dependencies: ["NeNeSummitCore"],
            swiftSettings: [.treatAllWarnings(as: .error), .enableUpcomingFeature("ExistentialAny")]
        ),
        .target(
            name: "NeNeSummitRender",
            dependencies: ["NeNeSummitCore"],
            swiftSettings: [.treatAllWarnings(as: .error), .enableUpcomingFeature("ExistentialAny")]
        ),
        .target(
            name: "NeNeSummitTerminal",
            dependencies: ["NeNeSummitRender"],
            swiftSettings: [.treatAllWarnings(as: .error), .enableUpcomingFeature("ExistentialAny")]
        ),
        .executableTarget(
            name: "nene-summit",
            dependencies: ["NeNeSummitCore", "NeNeSummitEngine", "NeNeSummitRender", "NeNeSummitTerminal"],
            swiftSettings: [.treatAllWarnings(as: .error), .enableUpcomingFeature("ExistentialAny")]
        ),
        .testTarget(
            name: "NeNeSummitEngineTests",
            dependencies: ["NeNeSummitCore", "NeNeSummitEngine"],
            swiftSettings: [.treatAllWarnings(as: .error), .enableUpcomingFeature("ExistentialAny")]
        ),
        .testTarget(
            name: "NeNeSummitCoreTests",
            dependencies: ["NeNeSummitCore"],
            swiftSettings: [.treatAllWarnings(as: .error), .enableUpcomingFeature("ExistentialAny")]
        ),
        .testTarget(
            name: "NeNeSummitRenderTests",
            dependencies: ["NeNeSummitCore", "NeNeSummitEngine", "NeNeSummitRender"],
            swiftSettings: [.treatAllWarnings(as: .error), .enableUpcomingFeature("ExistentialAny")]
        ),
        .testTarget(
            name: "NeNeSummitTerminalTests",
            dependencies: ["NeNeSummitTerminal"],
            swiftSettings: [.treatAllWarnings(as: .error), .enableUpcomingFeature("ExistentialAny")]
        ),
    ],
    swiftLanguageModes: [.v6]
)
