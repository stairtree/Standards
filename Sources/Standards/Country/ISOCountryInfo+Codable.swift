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

public enum CountryEncodingStrategy {
    case name
    case numeric
    case alpha2 // default
    case alpha3
}

extension CodingUserInfoKey {
    public static let countryEncodingStrategy = CodingUserInfoKey(rawValue: "countryEncodingStrategy")!
}

extension ISOCountryInfo: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch encoder.userInfo[.countryEncodingStrategy] as? CountryEncodingStrategy {
        case .name?:
            try container.encode(name)
        case .numeric?:
            try container.encode(numeric)
        case .alpha3?:
            try container.encode(alpha3)
        default:
            try container.encode(alpha2)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let stringRep = try container.decode(String.self)

        if let coded = ISOCountries.find(byKey: stringRep) {
            self = coded
        } else if let named = ISOCountries.find(byName: stringRep) {
            self = named
        } else {
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid country code: \(stringRep)")
            throw DecodingError.dataCorrupted(context)
        }
    }
}
