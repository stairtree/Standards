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

public enum SexEncodingStrategy {
    case name
    case code
}

extension CodingUserInfoKey {
    public static let sexEncodingStrategy = CodingUserInfoKey(rawValue: "sexEncodingStrategy")!
}

extension ISOHumanSexInfo: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch encoder.userInfo[.sexEncodingStrategy] as? SexEncodingStrategy {
        case .name?:
            try container.encode(name)
        default:
            try container.encode(code)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        do {
            let code = try container.decode(Int.self)
            guard let coded = ISOHumanSexes.find(byCode: code) else {
                let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid sex code: \(code)")
                throw DecodingError.dataCorrupted(context)
            }
            self = coded
        } catch {
            let name = try container.decode(String.self)
            guard let named = ISOHumanSexes.find(byName: name) else {
                let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid sex name: \(name)")
                throw DecodingError.dataCorrupted(context)
            }
            self = named
        }
    }
}
