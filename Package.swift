// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "XLForm",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "XLForm", targets: ["XLForm"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "XLForm",
            dependencies: [],
            path: "XLForm",
            publicHeadersPath: "XL"
        )
    ]
)
