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

struct CurrencyModel {
    var code: String
    var numeric: String
    var minorUnit: Int
    var name: String
    // Used to identify the countries the currency is used in
    var usedInLinks: Set<String>
}

extension CurrencyModel: SourceCodeEncodable {
    var instanceName: String { self.code.uppercased() }
    static var typeName: String { "ISOCurrencyInfo" }
    static var collectionTypeName: String { "ISOCurrencies" }
    var aliases: Set<String> { [self.name.toTypeName()] }
    func toSourceCode() throws -> String {
        """
            /// \(self.name)
            /// ```
            ///  numeric code: \(self.numeric)
            ///  code: \(self.code)
            ///  minor units: \(self.minorUnit)
            /// ```
            public static let \(self.instanceName) = \(Self.typeName)(
                name: "\(self.name)",
                numeric: "\(self.numeric)",
                code: "\(self.code)",
                minorUnit: \(self.minorUnit),
                used: [\(self.usedInLinks.sorted().map { "\"\($0)\"" }.joined(separator: ", "))]
            )
            
        """
    }
}
