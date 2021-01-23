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

extension ISOHumanSexInfo {
    public static let Unknown       = ISOHumanSexInfo(code: 0, name: "Unknown")
    public static let Male          = ISOHumanSexInfo(code: 1, name: "Male")
    public static let Female        = ISOHumanSexInfo(code: 2, name: "Female")
    public static let NotApplicable = ISOHumanSexInfo(code: 9, name: "Not Applicable")
}
