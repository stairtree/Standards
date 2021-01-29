import XCTest
@testable import Standards

final class CurrencyTests: XCTestCase {
//    func testEveryLocaleHasCurrency() {
//        for code in Locale.isoCurrencyCodes {
//            XCTAssertNotNil(ISOCurrencies.find(byCode: code), "Unknown currency code: '\(code)'")
//        }
//    }

    func testGetCurrencyByName() {
        let currency = ISOCurrencies.find(byName: "Euro")
        XCTAssertEqual(currency, .EUR)
    }

    func testCurrencySymbol() {
        let currency = ISOCurrencyInfo.EUR
        XCTAssertEqual(currency.symbol, "€")
    }

    func testAllCurrenciesHaveLocalizedNames() {
        for currency in ISOCurrencies.all {
            guard !currency.used.isEmpty else { continue }

            // Skip these, as they are known to have no localized name
            guard !["MRU", "STN"].contains(currency.code) else { continue }

            #if os(Linux)
            // Skip these, as they are known to have no localized name under Linux
            guard !["BYN"].contains(currency.code) else { continue }
            #endif

            XCTAssertNotNil(
                currency.localizedName(),
                "Currency '\(currency.name) (\(currency.code))' has no localized name"
            )
        }
    }

    func testAllCurrencyCodesAreUnique() {
        let all = ISOCurrencies.all.map { $0.code }
        let allSet = Set(all)
        XCTAssertEqual(all.count, allSet.count, "There are duplicate ISO4217 codes.")
    }

//    func testACurrencyIsListedAsUsed() {
//        for country in ISOCountries.all {
//            guard let currency = ISOCurrencies.find(byCode: country.currency) else {
//                XCTFail("Country has illegal currency code")
//                return
//            }
//            XCTAssertTrue(
//                currency.used.contains(country.alpha3),
//                "'\(country.name) (\(country.alpha3))' is not listed where '\(currency.name) (\(currency.code))' is used"
//            )
//        }
//    }

    func testCountriesWhereUsedAreValid() {
        for currency in ISOCurrencies.all {
            for countryCode in currency.used {
                XCTAssertNotNil(
                    ISOCountries.find(byKey: countryCode),
                    "Country with code '\(countryCode)' doesn't exist"
                )
            }
        }
    }

    // MARK: - JSON -

    // MARK: Encoding

    func testCurrencyToJSONAsCode() throws {
        let currency = [ISOCurrencyInfo.EUR]
        let encoder = JSONEncoder()
        encoder.userInfo[.currencyEncodingStrategy] = CurrencyEncodingStrategy.code
        let result = try encoder.encode(currency)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[\"EUR\"]")
    }

    func testCurrencyToJSONAsCodeByDefault() throws {
        let currency = [ISOCurrencyInfo.EUR]
        let encoder = JSONEncoder()
        let result = try encoder.encode(currency)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[\"EUR\"]")
    }

    func testCurrencyToJSONAsNumeric() throws {
        let currency = [ISOCurrencyInfo.EUR]
        let encoder = JSONEncoder()
        encoder.userInfo[.currencyEncodingStrategy] = CurrencyEncodingStrategy.numeric
        let result = try encoder.encode(currency)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[\"978\"]")
    }

    // MARK: Decoding

    func testCurrencyFromJSONAsCode() throws {
        let json = "[\"EUR\"]"
        let decoder = JSONDecoder()
        let result = try decoder.decode([ISOCurrencyInfo].self, from: json.data(using: .utf8)!)
        XCTAssertEqual(result, [ISOCurrencyInfo.EUR])
    }

    func testCurrencyFromJSONAsNumeric() throws {
        let json = "[\"978\"]"
        let decoder = JSONDecoder()
        let result = try decoder.decode([ISOCurrencyInfo].self, from: json.data(using: .utf8)!)
        XCTAssertEqual(result, [ISOCurrencyInfo.EUR])
    }

    func testInvalidCurrencyFromJSONNumericString() throws {
        let json = "[\"ABCDEFG\"]"
        let decoder = JSONDecoder()
        XCTAssertThrowsError(
            try decoder.decode([ISOCurrencyInfo].self, from: json.data(using: .utf8)!)
        )
    }

    func testInvalidCurrencyFromJSONCodeString() throws {
        let json = "[\"99999\"]"
        let decoder = JSONDecoder()
        XCTAssertThrowsError(
            try decoder.decode([ISOCurrencyInfo].self, from: json.data(using: .utf8)!)
        )
    }

    // MARK: Roundtrip

    func testRoundtripAllCurrencysThroughJSONWithCode() throws {
        for currency in ISOCurrencies.all {
            let encoder = JSONEncoder()
            encoder.userInfo[.currencyEncodingStrategy] = CurrencyEncodingStrategy.code
            let json = try encoder.encode([currency])
            let decoder = JSONDecoder()
            let result = try decoder.decode([ISOCurrencyInfo].self, from: json)
            XCTAssertEqual([currency], result, "JSON Roundtrip of \(currency.name) using code \(currency.code) failed!")
        }
    }

    func testRoundtripAllCurrencysThroughJSONWithNumeric() throws {
        for currency in ISOCurrencies.all {
            let encoder = JSONEncoder()
            encoder.userInfo[.currencyEncodingStrategy] = CurrencyEncodingStrategy.numeric
            let json = try encoder.encode([currency])
            let decoder = JSONDecoder()
            let result = try decoder.decode([ISOCurrencyInfo].self, from: json)
            XCTAssertEqual([currency], result, "JSON Roundtrip of \(currency.name) using numeric code: \(currency.numeric) failed!")
        }
    }
}
