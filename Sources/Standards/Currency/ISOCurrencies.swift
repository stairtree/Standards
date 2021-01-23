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

public enum ISOCurrencies {
    public static func find(byCode code: String) -> ISOCurrencyInfo? {
        ISOCurrencies.all.first { $0.code == code.uppercased() }
    }

    public static func find(byName name: String) -> ISOCurrencyInfo? {
        ISOCurrencies.all.first { $0.name == name }
    }

    public static func find(byNumeric numeric: String) -> ISOCurrencyInfo? {
        ISOCurrencies.all.first { $0.numeric == numeric }
    }
}
