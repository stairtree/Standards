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

struct CountryModel {
    // Used to identify and link data between wikipedia pages
    var wikipediaID: WikipediaIdentifier
    // The common name of the country as extracted from the wikipedia link
    var wikipediaName: String
    // The UN designated name
    var unDesignation: String
    var numeric: String
    var alpha2: String
    var alpha3: String
    var continents: Set<String>
}

extension CountryModel: SourceCodeEncodable {
    var instanceName: String { self.alpha2.uppercased() }
    static var typeName: String { "ISOCountryInfo" }
    static var collectionTypeName: String { "ISOCountries" }
    var aliases: Set<String> { [self.wikipediaName.toTypeName()] }
    func toSourceCode() throws -> String {
        """
            /// \(self.unDesignation)
            /// ```
            ///  numeric: \(self.numeric)
            ///  alpha-2 code: \(self.alpha2)
            ///  alpha-3 code: \(self.alpha3)
            ///  continent\(self.continents.count > 1 ? "s" : ""): \(self.continents.compactMap { continentLookup[$0] }.sorted().joined(separator: ", "))
            /// ```
            public static let \(self.instanceName) = \(Self.typeName)(
                name: "\(self.unDesignation)",
                numeric: "\(self.numeric)",
                alpha2: "\(self.alpha2)",
                alpha3: "\(self.alpha3)",
                continents: [\(self.continents.map { "\"\($0)\"" }.sorted().joined(separator: ", "))]
            )
            
        """
    }
}
