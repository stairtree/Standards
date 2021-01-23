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

public enum CurrencyEncodingStrategy {
    case numeric
    case code
}

extension CodingUserInfoKey {
    public static let currencyEncodingStrategy = CodingUserInfoKey(rawValue: "currencyEncodingStrategy")!
}

extension ISOCurrencyInfo: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch encoder.userInfo[.currencyEncodingStrategy] as? CurrencyEncodingStrategy {
        case .numeric?:
            try container.encode(numeric)
        default:
            try container.encode(code)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let stringRep = try container.decode(String.self)

        // If the string is representing an Integer value, we assume it is a code
        if let _ = Int(stringRep) {
            guard let coded = ISOCurrencies.find(byNumeric: stringRep) else {
                let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid currency numeric code: \(stringRep)")
                throw DecodingError.dataCorrupted(context)
            }
            self = coded
        } else {
            guard let n = ISOCurrencies.find(byCode: stringRep) else {
                let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid currency code: \(stringRep)")
                throw DecodingError.dataCorrupted(context)
            }
            self = n
        }
    }
}
