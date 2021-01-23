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
import SwiftSoup

// TODO

struct CallingTable {
    // alpha2 -> prefix
    let codes: [String: String]
    
    init(_ element: Element) {
        precondition(element.nodeName() == "table", "Must init with a table node")
        let tbody = element.child(1)
        let rows = tbody.children().map {
            $0.children().map { (try? $0.text()).map { "\($0)" } ?? "" }
        }
        self.codes = Dictionary(uniqueKeysWithValues: rows.map { (String($0[2].split(separator: "/").first!.trimmingCharacters(in: .whitespaces)),$0[1]) })
    }
}

func fetchAlpha2ToCallingCodes() throws -> [String: String] {
    let html = try String(contentsOf: URL(string: "https://www.countrycode.org")!)
    let table = CallingTable(try SwiftSoup.parse(html).select("table").first!)
    return table.codes
}
