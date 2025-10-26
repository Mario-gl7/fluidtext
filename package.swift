// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LinguaReader",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .executable(name: "LinguaReaderApp", targets: ["LinguaReaderApp"])
    ],
    targets: [
        .target(
            name: "LinguaReaderApp",
            dependencies: [],
            path: "ios"
        )
    ]
)
