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

struct LanguageModel {
    var family: String
    var isoName: String
    var shortName: String
    /// Native name (endonym)
    var endonym: String
    var code1: String
    var code2T: String
    var code2B: String
    var code3: String
}

extension LanguageModel: SourceCodeEncodable {
    var stableName: String { self.isoName }
    var instanceName: String { self.shortName.toTypeName() }
    static var typeName: String { "ISOLanguageInfo" }
    static var collectionTypeName: String { "ISOLanguages" }
    func toSourceCode() throws -> String {
        """
            /// \(self.isoName)
            /// ```
            ///  endonym: \(self.endonym)
            ///  family: \(self.family)
            ///  code1: \(self.code1)
            ///  code2T: \(self.code2T)
            ///  code2B: \(self.code2B)
            ///  code3: \(self.code3)
            /// ```
            public static let \(self.instanceName) = \(Self.typeName)(
                name: "\(self.isoName)",
                endonym: "\(self.endonym)",
                family: "\(self.family)",
                code1: "\(self.code1)",
                code2T: "\(self.code2T)",
                code2B: "\(self.code2B)",
                code3: "\(self.code3)"
            )
        """
    }
}
