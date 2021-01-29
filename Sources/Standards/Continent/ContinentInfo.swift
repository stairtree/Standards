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


/// There is no official standard describing continents but the codes are widely used
///
/// Note that the names are in English and not standardized. Even their meaning is not the same everywhere.
/// i.e. Central America is not defined to be part of NA or SA explicitly, and depending on the source, countries' assignment varies.
///
/// [USGS](https://planetarynames.wr.usgs.gov/Abbreviations) groups South and Central America, while [Wikipedia](https://en.wikipedia.org/wiki/List_of_sovereign_states_and_dependent_territories_by_continent_(data_file)) splits Central America between South America and North America
public struct ContinentInfo: Hashable, Equatable {
    public let code: String
    public let name: String

    public var countries: Set<ISOCountryInfo> {
        Set(ISOCountries.all.filter { $0.continents.contains(code) })
    }
}
