import XCTest
@testable import Standards

private func displayName(forAlpha2 code: String) -> String {
    (Locale(identifier: "en_US_POSIX") as NSLocale).displayName(forKey: .countryCode, value: code)!
}

final class CountryTests: XCTestCase {
    func testAllCountriesHaveLocalizedNames() {
        for country in ISOCountries.all {
            XCTAssertNotNil(country.localizedName(), "Country '\(country.name)' has no localized name")
        }
    }

    func testEveryLocaleHasCountry() {
        // Those are not recognized by ISO 3166
        let knownExceptions = [
            "AC", // "Ascension Island"
            "CP", // "Clipperton Island"
            "DG", // "Diego Garcia"
            "EA", // "Ceuta & Melilla"
            "IC", // "Canary Islands"
            "TA", // "Tristan da Cunha"
            "XK", // "Kosovo"
        ]
        for code in Locale.isoRegionCodes {
            if knownExceptions.contains(code) {
                XCTAssertNil(ISOCountries.find(byKey: code),
                             "Expected '\(code)' (\(displayName(forAlpha2: code))) to be missing.")
                continue
            }
            XCTAssertNotNil(ISOCountries.find(byKey: code),
                            "Unknown region code: '\(code)' (\(displayName(forAlpha2: code)).")
        }
    }

    func testAllCountriesHaveFlags() {
        for country in ISOCountries.all {
            XCTAssertNotNil(country.flag, "Country '\(country.name)' has no flag")
        }
    }

//    func testFindCountryByCallingCode() {
//        let austria = "+43"
//        XCTAssertEqual(ISOCountries.find(callingCode: austria), .Austria)
//    }

    func testGetContinentInfoFromCountry() {
        let country = ISOCountryInfo.Austria
        XCTAssertEqual(country.continentInfo, [.Europe])
    }

//    func testCountriesForCurrency() {
//        let currency = ISOCurrencyInfo.AfghanAfghani.code
//        XCTAssertEqual(ISOCountries.find(currency: currency), [ISOCountryInfo.Afghanistan])
//    }

    func testFindCountryByNumeric() {
        let numeric = "040"
        XCTAssertEqual(ISOCountries.find(numeric: numeric), .Austria)
    }

    func testAllCountryAlpha2CodesAreUnique() {
        let all = ISOCountries.all.map { $0.alpha2 }
        let allSet = Set(all)
        XCTAssertEqual(all.count, allSet.count, "There are duplicate ISO3166-1 codes.")
    }

    func testAllCountryAlpha3CodesAreUnique() {
        let all = ISOCountries.all.map { $0.alpha3 }
        let allSet = Set(all)
        XCTAssertEqual(all.count, allSet.count, "There are duplicate ISO3166-3 codes.")
    }

    func testNoAlpha2CodeMatchesAlpha3Code() {
        let all = ISOCountries.all.map { $0.alpha2 }
        for c in all {
            let match = ISOCountries.find(byAlpha3: c)
            XCTAssertNil(match, "Alpha2 code '\(c)' matched alpha3 code of '\(match!)'")
        }
    }

    func testNoAlpha3CodeMatchesAlpha2Code() {
        let all = ISOCountries.all.map { $0.alpha3 }
        for c in all {
            let match = ISOCountries.find(byAlpha2: c)
            XCTAssertNil(match, "Alpha3 code '\(c)' matched alpha2 code of '\(match!)'")
        }
    }

//    func testEveryCurrencyOnEveryCountryExists() {
//        for country in ISOCountries.all {
//            XCTAssertNotNil(
//                ISOCurrencies.find(byCode: country.currency),
//                "Country '\(country.currency)' on \(country.name) doesn't exist"
//            )
//        }
//    }

    func testEveryContinentOnEveryCountryExists() {
        for country in ISOCountries.all {
            country.continents.forEach {
                XCTAssertNotNil(
                    ISOContinents.find(byCode: $0),
                    "Continent '\($0)' on \(country.name) doesn't exist"
                )
            }
        }
    }

//    func testOtherCurrenciesForSwitzerland() {
//        XCTAssertEqual(ISOCountryInfo.Switzerland.otherCurrencies,
//                       [ISOCurrencyInfo.WIREuro, .SwissFranc, .WIRFranc],
//                       "Switzerland has \(ISOCountryInfo.Switzerland.otherCurrencies.map { $0.code })")
//    }

    // MARK: - JSON -

    // MARK: Encoding

    func testCountryToJSONAsAlpha2() throws {
        let country = [ISOCountryInfo.Austria]
        let encoder = JSONEncoder()
        encoder.userInfo[.countryEncodingStrategy] = CountryEncodingStrategy.alpha2
        let result = try encoder.encode(country)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[\"AT\"]")
    }

    func testCountryToJSONAsAlpha2ByDefault() throws {
        let country = [ISOCountryInfo.Austria]
        let encoder = JSONEncoder()
        let result = try encoder.encode(country)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[\"AT\"]")
    }

    func testCountryToJSONAsAlpha3() throws {
        let country = [ISOCountryInfo.Austria]
        let encoder = JSONEncoder()
        encoder.userInfo[.countryEncodingStrategy] = CountryEncodingStrategy.alpha3
        let result = try encoder.encode(country)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[\"AUT\"]")
    }

    func testCountryToJSONAsNumeric() throws {
        let country = [ISOCountryInfo.Austria]
        let encoder = JSONEncoder()
        encoder.userInfo[.countryEncodingStrategy] = CountryEncodingStrategy.numeric
        let result = try encoder.encode(country)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[\"040\"]")
    }

    func testCountryToJSONAsName() throws {
        let country = [ISOCountryInfo.Austria]
        let encoder = JSONEncoder()
        encoder.userInfo[.countryEncodingStrategy] = CountryEncodingStrategy.name
        let result = try encoder.encode(country)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[\"Austria\"]")
    }

    // MARK: Decoding

    func testCountryFromJSONAsAlpha2() throws {
        let json = "[\"AT\"]"
        let decoder = JSONDecoder()
        let result = try decoder.decode([ISOCountryInfo].self, from: json.data(using: .utf8)!)
        XCTAssertEqual(result, [ISOCountryInfo.Austria])
    }

    func testCountryFromJSONAsAlpha3() throws {
        let json = "[\"AUT\"]"
        let decoder = JSONDecoder()
        let result = try decoder.decode([ISOCountryInfo].self, from: json.data(using: .utf8)!)
        XCTAssertEqual(result, [ISOCountryInfo.Austria])
    }

    func testCountryFromJSONAsNumeric() throws {
        let json = "[\"040\"]"
        let decoder = JSONDecoder()
        let result = try decoder.decode([ISOCountryInfo].self, from: json.data(using: .utf8)!)
        XCTAssertEqual(result, [ISOCountryInfo.Austria])
    }

    func testCountryFromJSONAsName() throws {
        let json = "[\"Austria\"]"
        let decoder = JSONDecoder()
        let result = try decoder.decode([ISOCountryInfo].self, from: json.data(using: .utf8)!)
        XCTAssertEqual(result, [ISOCountryInfo.Austria])
    }

    func testInvalidCountryFromJSONString() throws {
        let json = "[\"Moon\"]"
        let decoder = JSONDecoder()
        XCTAssertThrowsError(
            try decoder.decode([ISOCountryInfo].self, from: json.data(using: .utf8)!)
        )
    }

    // MARK: Roundtrip

    func testRoundtripAllCountrysThroughJSONWithAlpha2() throws {
        for country in ISOCountries.all {
            let encoder = JSONEncoder()
            encoder.userInfo[.countryEncodingStrategy] = CountryEncodingStrategy.alpha2
            let json = try encoder.encode([country])
            let decoder = JSONDecoder()
            let result = try decoder.decode([ISOCountryInfo].self, from: json)
            XCTAssertEqual([country], result, "JSON Roundtrip of \(country.alpha2) failed!")
        }
    }

    func testRoundtripAllCountrysThroughJSONWithAlpha3() throws {
        for country in ISOCountries.all {
            let encoder = JSONEncoder()
            encoder.userInfo[.countryEncodingStrategy] = CountryEncodingStrategy.alpha3
            let json = try encoder.encode([country])
            let decoder = JSONDecoder()
            let result = try decoder.decode([ISOCountryInfo].self, from: json)
            XCTAssertEqual([country], result, "JSON Roundtrip of \(country.alpha3) failed!")
        }
    }

    func testRoundtripAllCountrysThroughJSONWithNumeric() throws {
        for country in ISOCountries.all {
            let encoder = JSONEncoder()
            encoder.userInfo[.countryEncodingStrategy] = CountryEncodingStrategy.numeric
            let json = try encoder.encode([country])
            let decoder = JSONDecoder()
            let result = try decoder.decode([ISOCountryInfo].self, from: json)
            XCTAssertEqual([country], result, "JSON Roundtrip of \(country.numeric) failed!")
        }
    }

    func testRoundtripAllCountrysThroughJSONWithName() throws {
        for country in ISOCountries.all {
            let encoder = JSONEncoder()
            encoder.userInfo[.countryEncodingStrategy] = CountryEncodingStrategy.name
            let json = try encoder.encode([country])
            let decoder = JSONDecoder()
            let result = try decoder.decode([ISOCountryInfo].self, from: json)
            XCTAssertEqual([country], result, "JSON Roundtrip of \(country.name) failed!")
        }
    }
}
