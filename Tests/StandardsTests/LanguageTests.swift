import XCTest
@testable import Standards

final class LanguageTests: XCTestCase {
    func testAllLanguagesHaveLocalizedNames() {
        for language in ISOLanguages.all {
            // Skip these, as they are known to have no localized name
            guard !["bh"].contains(language.code1) else { continue }
            XCTAssertNotNil(language.localizedName(), "Language '\(language.name)' has no localized name")
        }
    }

//    func testEveryLocaleHasLanguage() {
//        for id in Locale.availableIdentifiers {
//            let locale = Locale(identifier: id)
//            if let code = locale.languageCode {
//                XCTAssertNotNil(ISOLanguages.find(byKey: code), "Locale '\(locale.description)' has unknown language code: '\(code)'")
//            }
//        }
//    }

    func testAllLanguageCode1AreUnique() {
        let all = ISOLanguages.all.map { $0.code1 }
        let allSet = Set(all)
        XCTAssertEqual(all.count, allSet.count, "There are duplicate ISO639-1 codes.")
    }

    func testAllLanguageCode2TAreUnique() {
        let all = ISOLanguages.all.map { $0.code2T }
        let allSet = Set(all)
        XCTAssertEqual(all.count, allSet.count, "There are duplicate ISO639-2/T codes.")
    }

    func testAllLanguageCode2BAreUnique() {
        let all = ISOLanguages.all.map { $0.code2B }
        let allSet = Set(all)
        XCTAssertEqual(all.count, allSet.count, "There are duplicate ISO639-2/B codes.")
    }

    func testAllLanguageCode3AreUnique() {
        let all = ISOLanguages.all.map { $0.code3 }
        let allSet = Set(all)
        XCTAssertEqual(all.count, allSet.count, "There are duplicate ISO639-3 codes.")
    }

    func testNoCode1MatchesAnyOtherCode() {
        let all = ISOLanguages.all.map { $0.code1 }
        for l in all {
            let matchCode2B = ISOLanguages.find(byCode2B: l)
            XCTAssertNil(matchCode2B, "Code1 '\(l)' matched code2B code of '\(matchCode2B!)'")
            let matchCode2T = ISOLanguages.find(byCode2T: l)
            XCTAssertNil(matchCode2T, "Code1 '\(l)' matched code2T code of '\(matchCode2T!)'")
            let matchCode3 = ISOLanguages.find(byCode3: l)
            XCTAssertNil(matchCode3, "Code1 '\(l)' matched code3 code of '\(matchCode3!)'")
        }
    }

    func testNoCode2BMatchesAnyOtherLanguage() {
        for l in ISOLanguages.all {
            let matchCode1 = ISOLanguages.find(byCode1: l.code2B)
            XCTAssertTrue((matchCode1 == l) || matchCode1 == nil, "Code2B of '\(l)' matched code1 code of '\(matchCode1?.name ?? "")'")

            let matchCode2T = ISOLanguages.find(byCode2T: l.code2B)
            XCTAssertTrue((matchCode2T == l) || matchCode2T == nil, "Code2B of '\(l)' matched code2T code of '\(matchCode2T?.name ?? "")'")

            let matchCode3 = ISOLanguages.find(byCode3: l.code2B)
            XCTAssertTrue((matchCode3 == l) || matchCode3 == nil, "Code2B of '\(l)' matched code3 code of '\(matchCode3?.name ?? "")'")
        }
    }

    func testNoCode2TMatchesAnyOtherLanguage() {
        for l in ISOLanguages.all {
            let matchCode1 = ISOLanguages.find(byCode1: l.code2T)
            XCTAssertTrue((matchCode1 == l) || matchCode1 == nil, "Code2T of '\(l)' matched code1 code of '\(matchCode1?.name ?? "")'")

            let matchCode2B = ISOLanguages.find(byCode2B: l.code2T)
            XCTAssertTrue((matchCode2B == l) || matchCode2B == nil, "Code2T of '\(l)' matched code2B code of '\(matchCode2B?.name ?? "")'")

            let matchCode3 = ISOLanguages.find(byCode3: l.code2T)
            XCTAssertTrue((matchCode3 == l) || matchCode3 == nil, "Code2T of '\(l)' matched code3 code of '\(matchCode3?.name ?? "")'")
        }
    }

    func testNoCode3MatchesAnyOtherLanguage() {
        for l in ISOLanguages.all {
            let matchCode1 = ISOLanguages.find(byCode1: l.code3)
            XCTAssertTrue((matchCode1 == l) || matchCode1 == nil, "Code3 of '\(l)' matched code1 code of '\(matchCode1?.name ?? "")'")

            let matchCode2B = ISOLanguages.find(byCode2B: l.code3)
            XCTAssertTrue((matchCode2B == l) || matchCode2B == nil, "Code3 of '\(l)' matched code2B code of '\(matchCode2B?.name ?? "")'")

            let matchCode2T = ISOLanguages.find(byCode2T: l.code3)
            XCTAssertTrue((matchCode2T == l) || matchCode2T == nil, "Code3 of '\(l)' matched code2T code of '\(matchCode2T?.name ?? "")'")
        }
    }

    // MARK: - JSON -

    // MARK: Encoding

    func testLanguageToJSONAsCode1() throws {
        let language = [ISOLanguageInfo.DE]
        let encoder = JSONEncoder()
        encoder.userInfo[.languageEncodingStrategy] = LanguageEncodingStrategy.code1
        let result = try encoder.encode(language)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[\"de\"]")
    }

    func testLanguageToJSONAsCode1ByDefault() throws {
        let language = [ISOLanguageInfo.DE]
        let encoder = JSONEncoder()
        let result = try encoder.encode(language)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[\"de\"]")
    }

    func testLanguageToJSONAsCode2B() throws {
        let language = [ISOLanguageInfo.DE]
        let encoder = JSONEncoder()
        encoder.userInfo[.languageEncodingStrategy] = LanguageEncodingStrategy.code2B
        let result = try encoder.encode(language)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[\"ger\"]")
    }

    func testLanguageToJSONAsCode2T() throws {
        let language = [ISOLanguageInfo.DE]
        let encoder = JSONEncoder()
        encoder.userInfo[.languageEncodingStrategy] = LanguageEncodingStrategy.code2T
        let result = try encoder.encode(language)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[\"deu\"]")
    }

    func testLanguageToJSONAsCode3() throws {
        let language = [ISOLanguageInfo.DE]
        let encoder = JSONEncoder()
        encoder.userInfo[.languageEncodingStrategy] = LanguageEncodingStrategy.code3
        let result = try encoder.encode(language)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[\"deu\"]")
    }

    func testLanguageToJSONAsName() throws {
        let language = [ISOLanguageInfo.DE]
        let encoder = JSONEncoder()
        encoder.userInfo[.languageEncodingStrategy] = LanguageEncodingStrategy.name
        let result = try encoder.encode(language)
        XCTAssertEqual(String(data: result, encoding: .utf8), "[\"German\"]")
    }

    // MARK: Decoding

    func testLanguageFromJSONAsCode1() throws {
        let json = "[\"de\"]"
        let decoder = JSONDecoder()
        let result = try decoder.decode([ISOLanguageInfo].self, from: json.data(using: .utf8)!)
        XCTAssertEqual(result, [ISOLanguageInfo.DE])
    }

    func testLanguageFromJSONAsCode2B() throws {
        let json = "[\"ger\"]"
        let decoder = JSONDecoder()
        let result = try decoder.decode([ISOLanguageInfo].self, from: json.data(using: .utf8)!)
        XCTAssertEqual(result, [ISOLanguageInfo.DE])
    }

    func testLanguageFromJSONAsCode2T() throws {
        let json = "[\"deu\"]"
        let decoder = JSONDecoder()
        let result = try decoder.decode([ISOLanguageInfo].self, from: json.data(using: .utf8)!)
        XCTAssertEqual(result, [ISOLanguageInfo.DE])
    }

    func testLanguageFromJSONAsCode3() throws {
        let json = "[\"deu\"]"
        let decoder = JSONDecoder()
        let result = try decoder.decode([ISOLanguageInfo].self, from: json.data(using: .utf8)!)
        XCTAssertEqual(result, [ISOLanguageInfo.DE])
    }

    func testLanguageFromJSONAsName() throws {
        let json = "[\"German\"]"
        let decoder = JSONDecoder()
        let result = try decoder.decode([ISOLanguageInfo].self, from: json.data(using: .utf8)!)
        XCTAssertEqual(result, [ISOLanguageInfo.DE])
    }

    func testInvalidLanguageFromJSONString() throws {
        let json = "[\"Klingon\"]"
        let decoder = JSONDecoder()
        XCTAssertThrowsError(
            try decoder.decode([ISOLanguageInfo].self, from: json.data(using: .utf8)!)
        )
    }

    // MARK: Roundtrip

    func testRoundtripAllLanguagesThroughJSONWithCode1() throws {
        for language in ISOLanguages.all {
            let encoder = JSONEncoder()
            encoder.userInfo[.languageEncodingStrategy] = LanguageEncodingStrategy.code1
            let json = try encoder.encode([language])
            let decoder = JSONDecoder()
            let result = try decoder.decode([ISOLanguageInfo].self, from: json)
            XCTAssertEqual([language], result, "JSON Roundtrip of \(language.code1) failed!")
        }
    }

    func testRoundtripAllLanguagesThroughJSONWithCode2B() throws {
        for language in ISOLanguages.all {
            let encoder = JSONEncoder()
            encoder.userInfo[.languageEncodingStrategy] = LanguageEncodingStrategy.code2B
            let json = try encoder.encode([language])
            let decoder = JSONDecoder()
            let result = try decoder.decode([ISOLanguageInfo].self, from: json)
            XCTAssertEqual([language], result, "JSON Roundtrip of \(language.code2B) failed!")
        }
    }

    func testRoundtripAllLanguagesThroughJSONWithCode2T() throws {
        for language in ISOLanguages.all {
            let encoder = JSONEncoder()
            encoder.userInfo[.languageEncodingStrategy] = LanguageEncodingStrategy.code2T
            let json = try encoder.encode([language])
            let decoder = JSONDecoder()
            let result = try decoder.decode([ISOLanguageInfo].self, from: json)
            XCTAssertEqual([language], result, "JSON Roundtrip of \(language.code2T) failed!")
        }
    }

    func testRoundtripAllLanguagesThroughJSONWithCode3() throws {
        for language in ISOLanguages.all {
            let encoder = JSONEncoder()
            encoder.userInfo[.languageEncodingStrategy] = LanguageEncodingStrategy.code3
            let json = try encoder.encode([language])
            let decoder = JSONDecoder()
            let result = try decoder.decode([ISOLanguageInfo].self, from: json)
            XCTAssertEqual([language], result, "JSON Roundtrip of \(language.code3) failed!")
        }
    }

    func testRoundtripAllLanguagesThroughJSONWithName() throws {
        for language in ISOLanguages.all {
            let encoder = JSONEncoder()
            encoder.userInfo[.languageEncodingStrategy] = LanguageEncodingStrategy.name
            let json = try encoder.encode([language])
            let decoder = JSONDecoder()
            let result = try decoder.decode([ISOLanguageInfo].self, from: json)
            XCTAssertEqual([language], result, "JSON Roundtrip of \(language.name) failed!")
        }
    }
}
