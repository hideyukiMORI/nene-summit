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
        .testTarget(
            name: "NeNeSummitCoreTests",
            dependencies: ["NeNeSummitCore"],
            swiftSettings: [.treatAllWarnings(as: .error), .enableUpcomingFeature("ExistentialAny")]
        ),
    ],
    swiftLanguageModes: [.v6]
)
