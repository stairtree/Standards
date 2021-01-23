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

enum Wikipedia {
    static func countries() throws -> [CountryModel] {
        let html = try String(contentsOf: URL(string: "https://en.wikipedia.org/wiki/ISO_3166-1?action=render")!)
        let table = CountryTable(try SwiftSoup.parse(html).select("table").first(where: { try $0.children().first!.getElementsByTag("tr").count > 200 })!)
        
        let continentMapping = try countryToContinent()
        var countries = table.countries
        
        countries.indices.forEach {
            // countries[index].calling = calling[countries[index].alpha2].map { "+\($0.replacingOccurrences(of: "-", with: " "))" } ?? ""
            countries[$0].continents = continentMapping[countries[$0].alpha2] ?? []
            // countries[index].currency = currencies[countries[index].wikipediaLink]?.joined(separator: ", ")
        }
        return countries
    }
    
    static func countryToContinent() throws -> [String: Set<String>] {
        let html = try String(contentsOf: URL(string: "https://en.wikipedia.org/wiki/List_of_sovereign_states_and_dependent_territories_by_continent_(data_file)?action=render")!)
        let table = ContinentTable(try SwiftSoup.parse(html).select("table").first(where: { try $0.children().first!.getElementsByTag("tr").count > 200 })!)
        return table.relations
    }
    
    static func languages() throws -> [LanguageModel] {
        let html = try String(contentsOf: URL(string: "https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes?action=render")!)
        let table = LanguageTable(try SwiftSoup.parse(html).select("table").first(where: { try $0.children().last!.getElementsByTag("tr").count > 100 })!)
        return table.languages
    }
    
    static func currencies() throws -> [CurrencyModel] {
        let html = try String(contentsOf: URL(string: "https://en.wikipedia.org/wiki/ISO_4217?action=render")!)
        let table = CurrencyTable(try SwiftSoup.parse(html).select("table").first(where: { try $0.children().last!.getElementsByTag("tr").count > 100 })!)
        return table.currencies
    }
}

// MARK: - Tables

extension Wikipedia {
    struct CountryTable {
        var countries: [CountryModel]
        init(_ element: Element) {
            precondition(element.nodeName() == "table", "Must init with a table node")
            let tbody = element.child(0)
            // the header is part of the tbody,  so drop the first row
            self.countries = tbody.children().dropFirst().map {
                let flagURL = try! $0.child(0).getElementsByTag("img").first()!.attr("src")
                let wikiName = try! $0.child(0).getElementsByTag("a").first()!.attr("title")
                return CountryModel(
                    wikipediaID: .init(svgSrc: flagURL),
                    wikipediaName: wikiName,
                    unDesignation: try! $0.child(0).text(),
                    numeric: try! $0.child(3).text(),
                    alpha2: try! $0.child(1).text(),
                    alpha3: try! $0.child(2).text(),
                    continents: []
                )
            }
        }
    }
    
    struct ContinentTable {
        // alpha 2 to continent(s)
        var relations: [String: Set<String>]
        init(_ element: Element) {
            precondition(element.nodeName() == "table", "Must init with a table node")
            let tbody = element.child(0)
            // the header is part of the tbody,  so drop the first row
            let pairs: [(String, String)] = tbody.children().dropFirst().map {
                (try! $0.child(1).text().trimmingCharacters(in: .whitespaces), try! $0.child(0).text().trimmingCharacters(in: .whitespaces))
            }
            self.relations = Dictionary(pairs.map { ($0, Set([$1])) }, uniquingKeysWith: { $0.union($1) })
        }
    }
    
    struct LanguageTable {
        var languages: [LanguageModel]
        init(_ element: Element) {
            precondition(element.nodeName() == "table", "Must init with a table node")
            let tbody = element.child(0)
            // the header is part of the tbody,  so drop the first row
            self.languages = tbody.children().dropFirst().map {
                return LanguageModel(
                    family: try! $0.child(1).text(),
                    isoName: try! $0.child(2).text(),
                    shortName: try! $0.child(2).getElementsByTag("a").first()!.text(),
                    endonym: try! $0.child(3).text(),
                    code1: try! $0.child(4).text(),
                    code2T: try! $0.child(5).text(),
                    code2B: try! $0.child(6).text(),
                    code3: try! $0.child(7).text().split(separator: " ").first.map(String.init) ?? ""
                )
            }
        }
    }
    
    struct CurrencyTable {
        var currencies: [CurrencyModel]
        init(_ element: Element) {
            precondition(element.nodeName() == "table", "Must init with a table node")
            // the table has a caption as first child
            let tbody = element.child(1)
            // the header is part of the tbody,  so drop the first row
            self.currencies = tbody.children().dropFirst().map {
                let wikiLinks = try! $0.child(4).getElementsByTag("a").compactMap { try? $0.attr("href") }
                return CurrencyModel(
                    code: try! $0.child(0).text(),
                    numeric: try! $0.child(1).text(),
                    minorUnit: Int(try! $0.child(2).text()) ?? 0,
                    name: try! $0.child(3).text(),
                    usedInLinks: Set(wikiLinks)
                )
            }
        }
    }
}

// TODO:
// add detail info for each country based on ISO website drilldown pages from search

// TODO:
// Language collecitons
// https://en.wikipedia.org/wiki/Category:Languages_by_continent
// https://en.wikipedia.org/wiki/List_of_languages_by_number_of_native_speakers

// match countries and languages
// https://en.wikipedia.org/wiki/List_of_official_languages_by_country_and_territory
