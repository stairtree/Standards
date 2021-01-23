import XCTest
@testable import Standards

final class ContinentTests: XCTestCase {
    func testAllContinentCodesAreUnique() {
        let all = ISOContinents.all.map { $0.code }
        let allSet = Set(all)
        XCTAssertEqual(all.count, allSet.count, "There are duplicate Continent codes.")
    }

    func testCountriesFromContinent() {
        let continent = ContinentInfo.SouthAmerica
        let countries = continent.countries
        XCTAssertEqual(countries.count, 14)
    }

    // MARK: - JSON -

    // MARK: Encoding

    func testContinentToJSONAsCode() throws {
        let g = [ContinentInfo.Europe]
        let encoder = JSONEncoder()
        encoder.userInfo[.continentEncodingStrategy] = ContinentEncodingStrategy.code
        let result = try encoder.encode(g)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[\"EU\"]")
    }

    func testContinentToJSONAsCodeByDefault() throws {
        let g = [ContinentInfo.Europe]
        let encoder = JSONEncoder()
        let result = try encoder.encode(g)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[\"EU\"]")
    }

    func testContinentToJSONAsName() throws {
        let g = [ContinentInfo.Europe]
        let encoder = JSONEncoder()
        encoder.userInfo[.continentEncodingStrategy] = ContinentEncodingStrategy.name
        let result = try encoder.encode(g)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[\"Europe\"]")
    }

    // MARK: Decoding

    func testContinentFromJSONAsCode() throws {
        let json = "[\"EU\"]"
        let decoder = JSONDecoder()
        let result = try decoder.decode([ContinentInfo].self, from: json.data(using: .utf8)!)
        XCTAssertEqual(result, [ContinentInfo.Europe])
    }

    func testContinentFromJSONAsName() throws {
        let json = "[\"Europe\"]"
        let decoder = JSONDecoder()
        let result = try decoder.decode([ContinentInfo].self, from: json.data(using: .utf8)!)
        XCTAssertEqual(result, [ContinentInfo.Europe])
    }

    func testInvalidContinentFromJSONString() throws {
        let json = "[\"Moon\"]"
        let decoder = JSONDecoder()
        XCTAssertThrowsError(
            try decoder.decode([ContinentInfo].self, from: json.data(using: .utf8)!)
        )
    }

    func testInvalidContinentFromJSONCode() throws {
        let json = "[\"XX\"]"
        let decoder = JSONDecoder()
        XCTAssertThrowsError(
            try decoder.decode([ContinentInfo].self, from: json.data(using: .utf8)!)
        )
    }

    // MARK: Roundtrip

    func testRoundtripAllContinentsThroughJSONWithCode() throws {
        for continent in ISOContinents.all {
            let encoder = JSONEncoder()
            encoder.userInfo[.continentEncodingStrategy] = ContinentEncodingStrategy.code
            let json = try encoder.encode([continent])
            let decoder = JSONDecoder()
            let result = try decoder.decode([ContinentInfo].self, from: json)
            XCTAssertEqual([continent], result, "JSON Roundtrip of \(continent.code) failed!")
        }
    }

    func testRoundtripAllContinentsThroughJSONWithName() throws {
        for continent in ISOContinents.all {
            let encoder = JSONEncoder()
            encoder.userInfo[.continentEncodingStrategy] = ContinentEncodingStrategy.name
            let json = try encoder.encode([continent])
            let decoder = JSONDecoder()
            let result = try decoder.decode([ContinentInfo].self, from: json)
            XCTAssertEqual([continent], result, "JSON Roundtrip of \(continent.name) failed!")
        }
    }
}
