import XCTest
@testable import Standards

final class HumanSexTests: XCTestCase {
    func testAllHumanSexCodesAreUnique() {
        let all = ISOHumanSexes.all.map { $0.code }
        let allSet = Set(all)
        XCTAssertEqual(all.count, allSet.count, "There are duplicate ISO5218 codes.")
    }

    // MARK: - JSON -

    // MARK: Encoding

    func testHumanSexToJSONAsCode() throws {
        let sex = [ISOHumanSexInfo.Male]
        let encoder = JSONEncoder()
        encoder.userInfo[.sexEncodingStrategy] = SexEncodingStrategy.code
        let result = try encoder.encode(sex)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[1]")
    }

    func testHumanSexToJSONAsCodeByDefault() throws {
        let sex = [ISOHumanSexInfo.Male]
        let encoder = JSONEncoder()
        let result = try encoder.encode(sex)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[1]")
    }

    func testHumanSexToJSONAsName() throws {
        let sex = [ISOHumanSexInfo.Male]
        let encoder = JSONEncoder()
        encoder.userInfo[.sexEncodingStrategy] = SexEncodingStrategy.name
        let result = try encoder.encode(sex)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[\"Male\"]")
    }

    // MARK: Decoding

    func testHumanSexFromJSONAsCode() throws {
        let json = "[1]"
        let decoder = JSONDecoder()
        let result = try decoder.decode([ISOHumanSexInfo].self, from: json.data(using: .utf8)!)
        XCTAssertEqual(result, [ISOHumanSexInfo.Male])
    }

    func testHumanSexFromJSONAsName() throws {
        let json = "[\"Male\"]"
        let decoder = JSONDecoder()
        let result = try decoder.decode([ISOHumanSexInfo].self, from: json.data(using: .utf8)!)
        XCTAssertEqual(result, [ISOHumanSexInfo.Male])
    }

    func testInvalidHumanSexFromJSONString() throws {
        let json = "[\"Mule\"]"
        let decoder = JSONDecoder()
        XCTAssertThrowsError(
            try decoder.decode([ISOHumanSexInfo].self, from: json.data(using: .utf8)!)
        )
    }

    func testInvalidHumanSexFromJSONCode() throws {
        let json = "[99]"
        let decoder = JSONDecoder()
        XCTAssertThrowsError(
            try decoder.decode([ISOHumanSexInfo].self, from: json.data(using: .utf8)!)
        )
    }

    // MARK: Roundtrip

    func testRoundtripAllHumanSexsThroughJSONWithCode() throws {
        for sex in ISOHumanSexes.all {
            let encoder = JSONEncoder()
            encoder.userInfo[.sexEncodingStrategy] = SexEncodingStrategy.code
            let json = try encoder.encode([sex])
            let decoder = JSONDecoder()
            let result = try decoder.decode([ISOHumanSexInfo].self, from: json)
            XCTAssertEqual([sex], result, "JSON Roundtrip of \(sex.code) failed!")
        }
    }

    func testRoundtripAllHumanSexsThroughJSONWithName() throws {
        for sex in ISOHumanSexes.all {
            let encoder = JSONEncoder()
            encoder.userInfo[.sexEncodingStrategy] = SexEncodingStrategy.name
            let json = try encoder.encode([sex])
            let decoder = JSONDecoder()
            let result = try decoder.decode([ISOHumanSexInfo].self, from: json)
            XCTAssertEqual([sex], result, "JSON Roundtrip of \(sex.name) failed!")
        }
    }
}
