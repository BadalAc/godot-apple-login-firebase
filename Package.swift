// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "MyLibrary",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "MyLibrary",
            type: .dynamic,
            targets: ["MyLibrary"]),
    ],
    dependencies: [
        .package(url: "https://github.com/migueldeicaza/SwiftGodot", branch: "main"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.23.0")
    ],
    targets: [
        .target(
            name: "MyLibrary",
            dependencies: [
                "SwiftGodot",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk") // Only FirebaseAuth is needed
            ],
            swiftSettings: [.unsafeFlags(["-suppress-warnings"])]
        ),
    ]
)
