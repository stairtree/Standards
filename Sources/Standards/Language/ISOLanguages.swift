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

public enum ISOLanguages {
    public static func find(byName name: String) -> ISOLanguageInfo? {
        ISOLanguages.all.first { $0.name == name }
    }

    public static func find(byKey key: String) -> ISOLanguageInfo? {
        let lcKey = key.lowercased()
        return ISOLanguages.all.first {
            $0.code1 == lcKey
                || $0.code2B == lcKey
                || $0.code2T == lcKey
                || $0.code3 == lcKey
        }
    }

    public static func find(byCode1 code1: String) -> ISOLanguageInfo? {
        ISOLanguages.all.first { $0.code1 == code1.lowercased() }
    }

    public static func find(byCode2T code2T: String) -> ISOLanguageInfo? {
        ISOLanguages.all.first { $0.code2T == code2T.lowercased() }
    }

    public static func find(byCode2B code2B: String) -> ISOLanguageInfo? {
        ISOLanguages.all.first { $0.code2B == code2B.lowercased() }
    }

    public static func find(byCode3 code3: String) -> ISOLanguageInfo? {
        ISOLanguages.all.first { $0.code3 == code3.lowercased() }
    }
}
