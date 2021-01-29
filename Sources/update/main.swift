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

// Must run with `swift run update` from the package's root directory

let base = "./Sources/Standards/"
let gen = "_generated"

func run() throws {
    let countries = DefinitionTemplate(try Wikipedia.countries())
    try countries.write(to: "\(base)Country/\(gen)/ISOCountryInfo+AllCountries.swift")
    try CollectionTemplate([(name: "all", countries.data)])
        .write(to: "\(base)Country/\(gen)/ISOCountries+Collections.swift")
    try AliasTemplate(countries.data)
        .write(to: "\(base)Country/\(gen)/ISOCountries+Aliases.swift")

    let currencies = DefinitionTemplate(try ISO.currencies())
    try currencies.write(to: "\(base)Currency/\(gen)/ISOCurrencyInfo+AllCurrencies.swift")
    try CollectionTemplate([(name: "all", currencies.data)])
        .write(to: "\(base)Currency/\(gen)/ISOCurrencies+Collections.swift")
    try AliasTemplate(currencies.data)
        .write(to: "\(base)Currency/\(gen)/ISOCurrencies+Aliases.swift")

    let languages = DefinitionTemplate(try Wikipedia.languages())
    try languages.write(to: "\(base)Language/\(gen)/ISOLanguageInfo+AllLanguages.swift")
    try CollectionTemplate([(name: "all", languages.data)])
        .write(to: "\(base)Language/\(gen)/ISOLanguages+Collections.swift")
    try AliasTemplate(languages.data)
        .write(to: "\(base)Language/\(gen)/ISOLanguages+Aliases.swift")
}

do {
    try run()
} catch {
    print("ERROR: \(error)")
}
