// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "swift-bazel-build-event",
  products: [
    .library(
      name: "BazelBuildEvent",
      targets: ["BazelBuildEvent"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.0.0")
  ],
  targets: [
    .target(
      name: "BazelBuildEvent",
      dependencies: [
        .product(name: "SwiftProtobuf", package: "swift-protobuf")
      ]
    )
  ]
)
