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

public enum ISOCountries {
    public static func flag(countryCode: String) -> String {
        var string = ""
        let country = countryCode.uppercased()

        let regionalA = "🇦".unicodeScalars
        let letterA = "A".unicodeScalars
        let base = regionalA[regionalA.startIndex].value - letterA[letterA.startIndex].value

        for scalar in country.unicodeScalars {
            guard let regionalScalar = UnicodeScalar(base + scalar.value) else { return "" }
            string.unicodeScalars.append(regionalScalar)
        }
        return string
    }

    public static func find(byKey key: String) -> ISOCountryInfo? {
        ISOCountries.all.first { $0.alpha2 == key.uppercased() || $0.alpha3 == key.uppercased() || $0.numeric == key }
    }

    public static func find(byAlpha2 alpha2: String) -> ISOCountryInfo? {
        ISOCountries.all.first { $0.alpha2 == alpha2.uppercased() }
    }

    public static func find(byAlpha3 alpha3: String) -> ISOCountryInfo? {
        ISOCountries.all.first { $0.alpha3 == alpha3.uppercased() }
    }

    public static func find(byName name: String) -> ISOCountryInfo? {
        ISOCountries.all.first { $0.name == name }
    }

    public static func find(numeric: String) -> ISOCountryInfo? {
        ISOCountries.all.first { $0.numeric == numeric }
    }
}
