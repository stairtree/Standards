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

/// Language according to ISO639
public struct ISOLanguageInfo: Hashable, Equatable {
    /// ISO name
    public let name: String
    /// Native name
    public let endonym: String
    /// Language family
    public let family: String
    /// ISO 639-1 code
    public let code1: String
    /// ISO 639-2/T code
    public let code2T: String
    /// ISO 639-2/B code
    public let code2B: String
    /// ISO 639-3 code
    public let code3: String

    public func localizedName(for locale: NSLocale = NSLocale.current as NSLocale) -> String? {
        locale.displayName(forKey: .languageCode, value: code1)
    }
}
