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

import Foundation

/// Must be comparable to determine order of definitions in source code
protocol SourceCodeEncodable: Comparable {
    static var header: String { get }
    static var typeName: String { get }
    static var collectionTypeName: String { get }
    var instanceName: String { get }
    var aliases: Set<String> { get }
    func toSourceCode() throws -> String
}

extension SourceCodeEncodable {
    static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.instanceName.compare(rhs.instanceName, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedAscending
    }
}

extension SourceCodeEncodable {
    static var header: String {
        """
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
            
            //===----------------------------------------------------------------------===//
            //      Automatically generated with `swift run update`. Do not modify.       //
            //===----------------------------------------------------------------------===//
            
            """
    }
}

struct DefinitionTemplate<S: SourceCodeEncodable> {
    let data: [S]
    init(_ data: [S]) { self.data = data }
    
    func string() throws -> String {
        S.header
            + prefix
            + (try data.sorted().map { try $0.toSourceCode() }.joined(separator: "\n"))
            + suffix
    }
    
    func write(to path: String) throws {
        try string().write(toFile: path, atomically: true, encoding: .utf8)
    }
    
    var prefix: String {
        "\nextension \(S.typeName) {\n"
    }
    
    var suffix: String {
        "\n}\n"
    }
}

struct CollectionTemplate<S: SourceCodeEncodable> {
    let data: [(name: String, [S])]
    init(_ data: [(name: String, [S])]) { self.data = data }
    
    func string() throws -> String {
        S.header
            + prefix
            + data.map(collection(_:)).joined(separator: "\n")
            + suffix
    }
    
    func write(to path: String) throws {
        try string().write(toFile: path, atomically: true, encoding: .utf8)
    }
    
    var prefix: String {
        "\nextension \(S.collectionTypeName) {\n"
    }
    
    var suffix: String {
        "\n}\n"
    }
    
    func collection(_ c: (name: String, [S])) -> String {
        """
            /// \(c.1.count) `\(S.typeName)`s
            public static let \(c.name): [\(S.typeName)] = [
                \(c.1.sorted().map { ".\($0.instanceName)" }.joined(separator: ", "))
            ]
        """
    }
}

struct AliasTemplate<S: SourceCodeEncodable> {
    let data: [S]
    init(_ data: [S]) { self.data = data }
    
    func string() throws -> String {
        S.header
            + prefix
            + data.map(aliases(_:)).joined(separator: "\n")
            + suffix
    }
    
    func write(to path: String) throws {
        try string().write(toFile: path, atomically: true, encoding: .utf8)
    }
    
    var prefix: String {
        "\nextension \(S.typeName) {\n"
    }
    
    var suffix: String {
        "\n}\n"
    }
    
    func aliases(_ instance: S) -> String {
        """
            /// Alias\(instance.aliases.count > 1 ? "s" : "") for \(S.typeName).\(instance.instanceName)
            \(instance.aliases.sorted().map { alias in
                """
                @available(*, deprecated, renamed: "\(instance.instanceName)")
                    public static let \(alias): \(S.typeName) = .\(instance.instanceName)
                """
            }.joined(separator: "\n"))
            
        """
    }
}
