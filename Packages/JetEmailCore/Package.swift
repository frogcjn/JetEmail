// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var package = Package(
    name: "JetEmailCore",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        //.tvOS(.v12),
        //.watchOS(.v4),
        .visionOS(.v2)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "JetEmailCore"      , targets: ["JetEmailPlatform", "JetEmailGoogle", "JetEmailMicrosoft", "JetEmailData", "JetEmailFoundation"]),
        
        /*.library(name: "JetEmailData"      , targets: ["JetEmailData"]),
        .library(name: "JetEmailGoogle"    , targets: ["JetEmailGoogle"]),
        .library(name: "JetEmailMicrosoft" , targets: ["JetEmailMicrosoft"]),
        .library(name: "JetEmailData"        , targets: ["JetEmailData"]),
        .library(name: "JetEmailFoundation", targets: ["JetEmailFoundation"])*/
    ],
    dependencies: [
        .package(url: "https://github.com/frogcjn/AppAuth-iOS.git", branch: "frogcjn/visionOS"), //.package(url: "https://github.com/openid/AppAuth-iOS.git", .upToNextMajor(from: "1.6.2")),
        .package(url: "https://github.com/frogcjn/GTMAppAuth.git", branch: "frogcjn/visionOS"), // .package(url: "https://github.com/google/GTMAppAuth.git", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/frogcjn/google-api-objectivec-client-for-rest.git", branch: "frogcjn/GTLR_SKIP_PAGES_WARNING"),
        //.package(url: "https://github.com/google/google-api-objectivec-client-for-rest.git", .upToNextMajor(from: "3.5.1")),
        .package(url: "https://github.com/frogcjn/MSAL.git", branch: "main"),
        //.package(url: "https://github.com/frogcjn/microsoft-authentication-library-for-objc.git", .upToNextMajor(from: "1.3.0")),
        //.package(name: "MSAL", path: "../microsoft-authentication-library-for-objc"),
        .package(url: "https://github.com/igorrendulic/MimeEmailParser.git", .upToNextMajor(from: "1.0.5")),
        .package(url: "https://github.com/frogcjn/OpenAI", branch:"main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "JetEmailPlatform",
            dependencies: [
                .target (name: "JetEmailGoogle"                         ),
                .target (name: "JetEmailMicrosoft"                      ),
                .target (name: "JetEmailData"                           ),
                .product(name: "OpenAI"                     , package: "OpenAI"                          ),
            ]
        ),
        .target(
            name: "JetEmailGoogle",
            dependencies: [
                .product(name: "AppAuth"                     , package: "AppAuth-iOS"                          ),
                .product(name: "GTMAppAuth"                  , package: "GTMAppAuth"                           ),
                .product(name: "GoogleAPIClientForREST_Gmail", package: "google-api-objectivec-client-for-rest"),
                .target (name: "JetEmailFoundation"                                                            ),
                .target (name: "JetEmailData"                                                                  ),
            ]/*,
            swiftSettings: [
                //.define("GTLR_SKIP_PAGES_WARNING")
            ]*/
        ),
        .target(
            name: "JetEmailMicrosoft",
            dependencies: [
                .product(name: "MSAL"               , package: "MSAL"),
                .target (name: "JetEmailFoundation"                  ),
                .target (name: "JetEmailData"                        )
            ]
        ),
        .target(
            name: "JetEmailData",
            dependencies: [
                .target(name: "JetEmailFoundation")
            ],
            resources: [.process("Resources/Localizable.xcstrings")]
        ),
        .target(
            name: "JetEmailFoundation",
            dependencies: [
                .product(name: "MimeEmailParser", package: "MimeEmailParser")
            ]
        ),
        
        /*.binaryTarget(
            name: "MSAL",
            path: "../MSAL/MSAL.xcframework"
        )*/
    ]
)

for target in package.targets {
    target.swiftSettings = (target.swiftSettings ?? []) + [.swiftLanguageVersion(.v6)/*, .enableUpcomingFeature("StrictConcurrency"), .enableUpcomingFeature("GlobalConcurrency"), .enableUpcomingFeature("IsolatedDefaultValues")*/]
}
