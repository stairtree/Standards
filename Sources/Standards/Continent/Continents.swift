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

public enum ISOContinents {
    public static let all: [ContinentInfo] = [
        .Africa,
        .Asia,
        .Europe,
        .NorthAmerica,
        .SouthAmerica,
        .Oceania,
        .Antarctica,
    ]
}

extension ISOContinents {
    public static func find(byCode code: String) -> ContinentInfo? {
        ISOContinents.all.first { $0.code == code }
    }

    public static func find(byName name: String) -> ContinentInfo? {
        ISOContinents.all.first { $0.name == name }
    }
}
