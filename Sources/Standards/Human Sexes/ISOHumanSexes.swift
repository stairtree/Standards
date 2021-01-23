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

public enum ISOHumanSexes {
    public static func find(byCode code: Int) -> ISOHumanSexInfo? {
        return ISOHumanSexes.all.first { $0.code == code }
    }

    public static func find(byName name: String) -> ISOHumanSexInfo? {
        return ISOHumanSexes.all.first { $0.name == name }
    }

    public static let all: [ISOHumanSexInfo] = [
        .Unknown,
        .Male,
        .Female,
        .NotApplicable
    ]
}
