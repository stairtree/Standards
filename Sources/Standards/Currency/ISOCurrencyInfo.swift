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

/// Country according to ISO4217
public struct ISOCurrencyInfo: Hashable, Equatable {
    public let name: String
    public let numeric: String
    public let code: String
    public let minorUnit: Int
    public let used: Set<String> // alpha3 codes

    public func localizedName(for locale: NSLocale = NSLocale.current as NSLocale) -> String? {
        locale.displayName(forKey: .currencyCode, value: code)
    }

    private static let localeIdentifiers: [String] = Locale.availableIdentifiers
    private static let locales: [Locale] = localeIdentifiers.map { Locale(identifier: $0) }

    public var symbol: String {
        let locale = ISOCurrencyInfo.locales.first { $0.currencyCode == self.code }
        return locale?.currencySymbol ?? ""
    }
}
