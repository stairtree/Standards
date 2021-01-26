// swift-tools-version:5.2
//===----------------------------------------------------------------------===//
//
// This source file is part of the Standards open source project
//
// Copyright (c) Stairtree GmbH
// Licensed under the MIT license
//
// See LICENSE.txt for license information
//
// SPDX-License-Identifier: MIT
//
//===----------------------------------------------------------------------===//

import PackageDescription

let package = Package(
    name: "Standards",
    products: [
        .library(
            name: "Standards",
            targets: ["Standards"]),
        .executable(
            name: "update",
            targets: ["update"])
    ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.0.0"),
        .package(url: "https://github.com/MaxDesiatov/XMLCoder.git", from: "0.12.0"),
    ],
    targets: [
        .target(
            name: "Standards",
            dependencies: []),
        .target(
            name: "update",
            dependencies: [.byName(name: "SwiftSoup"), .byName(name: "XMLCoder")]),
        .testTarget(
            name: "StandardsTests",
            dependencies: [.byName(name: "Standards")]),
    ]
)
