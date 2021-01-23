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

/// Country according to ISO 3166-1
///
/// Source: Wikipedia
public struct ISOCountryInfo: Hashable, Equatable {
    /// The official name as assigned by the United Nations
    public let name: String
    /// The ISO 3166-1 numeric code
    public let numeric: String
    /// The ISO 3166-1 alpha-2 code
    public let alpha2: String
    /// The ISO 3166-1 alpha-3 code
    public let alpha3: String
    /// The continent, the country is considered to be part of
    ///
    /// - Note: Some countries span multiple continents (e.g. Turkey)
    public let continents: Set<String>
    /// The Unicode flag symbol for this country
    public var flag: String {
        ISOCountries.flag(countryCode: alpha2)
    }
    
    /// The country's name in the language of the given locale
    /// - Parameter locale: The locale to provide the country's name. By default the system's current locale is used.
    /// - Returns: The localized name of the country
    public func localizedName(for locale: NSLocale = NSLocale.current as NSLocale) -> String? {
        locale.displayName(forKey: .countryCode, value: alpha2)
    }
}

extension ISOCountryInfo {
    public var otherCurrencies: Set<ISOCurrencyInfo> {
        Set(ISOCurrencies.all.filter { $0.used.contains(alpha3) })
    }

    public var continentInfo: Set<ContinentInfo> {
        Set(continents.compactMap(ISOContinents.find(byCode:)))
    }
}
