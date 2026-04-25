// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "dw",
    platforms: [
        .macOS(.v12), .iOS(.v15)
    ],
    products: [
        .library(name: "dw", targets: ["dw"]),
    ],
    targets: [
        .target(
            name: "dw",
            path: "src"
        ),
    ]
)
