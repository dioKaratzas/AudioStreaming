// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "AudioStreaming",
    platforms: [
        .iOS(.v14),
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "AudioStreaming",
            targets: ["AudioStreaming"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.3"),
    ],
    targets: [
        .target(
            name: "AudioStreaming",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
            ],
            path: "AudioStreaming"
        ),
        .testTarget(
            name: "AudioStreamingTests",
            dependencies: [
                "AudioStreaming"
            ],
            path: "AudioStreamingTests",
            resources: [
                .copy("Streaming/Metadata Stream Processor/raw-audio-streams/raw-stream-audio-empty-metadata"),
                .copy("Streaming/Metadata Stream Processor/raw-audio-streams/raw-stream-audio-no-metadata"),
                .copy("Streaming/Metadata Stream Processor/raw-audio-streams/raw-stream-audio-normal-metadata"),
                .copy("Streaming/Metadata Stream Processor/raw-audio-streams/raw-stream-audio-normal-metadata-alt")
            ]
        )
    ]
)
