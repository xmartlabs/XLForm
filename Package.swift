// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
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
            publicHeadersPath: "XLForm",
            cSettings: [
                .headerSearchPath("XL"),
                .headerSearchPath("XL/Cell"),
                .headerSearchPath("XL/Controllers"),
                .headerSearchPath("XL/Descriptors"),
                .headerSearchPath("XL/Helpers"),
                .headerSearchPath("XL/Helpers/Views"),
                .headerSearchPath("XL/Validation"),
            ]
        )
    ]
)
