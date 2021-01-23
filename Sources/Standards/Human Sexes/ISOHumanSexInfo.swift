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

/// Human sexes according to ISO 5218
public struct ISOHumanSexInfo: Hashable, Equatable {
    public let code: Int
    public let name: String
}
