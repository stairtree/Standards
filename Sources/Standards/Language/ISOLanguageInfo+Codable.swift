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

public enum LanguageEncodingStrategy {
    case name
    case code1 // default
    case code2B
    case code2T
    case code3
}

extension CodingUserInfoKey {
    public static let languageEncodingStrategy = CodingUserInfoKey(rawValue: "languageEncodingStrategy")!
}

extension ISOLanguageInfo: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch encoder.userInfo[.languageEncodingStrategy] as? LanguageEncodingStrategy {
        case .name?:
            try container.encode(name)
        case .code2B?:
            try container.encode(code2B)
        case .code2T?:
            try container.encode(code2T)
        case .code3?:
            try container.encode(code3)
        default:
            try container.encode(code1)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let stringRep = try container.decode(String.self)

        if let coded = ISOLanguages.find(byKey: stringRep) {
            self = coded
        } else if let named = ISOLanguages.find(byName: stringRep) {
            self = named
        } else {
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid language: \(stringRep)")
            throw DecodingError.dataCorrupted(context)
        }
    }
}
