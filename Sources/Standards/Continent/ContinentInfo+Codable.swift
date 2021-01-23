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

public enum ContinentEncodingStrategy {
    case name
    case code
}

extension CodingUserInfoKey {
    public static let continentEncodingStrategy = CodingUserInfoKey(rawValue: "continentEncodingStrategy")!
}

extension ContinentInfo: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch encoder.userInfo[.continentEncodingStrategy] as? ContinentEncodingStrategy {
        case .name?:
            try container.encode(name)
        default:
            try container.encode(code)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let stringRep = try container.decode(String.self)

        if let coded = ISOContinents.find(byCode: stringRep) {
            self = coded
        } else if let named = ISOContinents.find(byName: stringRep) {
            self = named
        } else {
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid continent name or code: \(stringRep)")
            throw DecodingError.dataCorrupted(context)
        }
    }
}
