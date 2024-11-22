// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JetEmail-Core",
    platforms: [.macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        /*.library(
            name: "JetEmail-Package",
            targets: ["JetEmail-Package"]
        ),*/
        
        .library(name: "JetEmail-Foundation", targets: ["JetEmail-Foundation"]),
        .library(name: "Google"             , targets: ["Google"             ]),
        .library(name: "Microsoft"          , targets: ["Microsoft"          ]),
    ],
    dependencies: [
        .package(url: "https://github.com/openid/AppAuth-iOS.git"                               , .upToNextMajor(from: "1.6.2")),
        .package(url: "https://github.com/google/GTMAppAuth.git"                                , .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/google/google-api-objectivec-client-for-rest.git"     , .upToNextMajor(from: "3.5.1")),
        .package(url: "https://github.com/AzureAD/microsoft-authentication-library-for-objc.git", .upToNextMajor(from: "1.3.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Google",
            dependencies: [
                .product(name: "AppAuth"                     , package: "AppAuth-iOS"                              ),
                .product(name: "GTMAppAuth"                  , package: "gtmappauth"                               ),
                .product(name: "GoogleAPIClientForREST_Gmail", package: "google-api-objectivec-client-for-rest"    ),
                "JetEmail-Foundation"
            ]
        ),
        .target(
            name: "Microsoft",
            dependencies: [
                .product(name: "MSAL"                        , package: "microsoft-authentication-library-for-objc"),
                "JetEmail-Foundation"
            ]
        ),
        .target(
            name: "JetEmail-Foundation"
        ),
        /*.testTarget(
            name: "JetEmail-FoundationTests",
            dependencies: ["JetEmail-Foundation"]),*/
    ]
)
