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
import XMLCoder

enum ISO {
    static func currencies() throws -> [CurrencyModel] {
        let xml = try String(contentsOf: URL(string: "https://www.currency-iso.org/dam/downloads/lists/list_one.xml")!)
        let isoInfo = try XMLDecoder().decode(ISO_4217.self, from: Data(xml.utf8))
        
        // filter out all funds and pseudo currencies for now
        let valid: [(name: String, code: String, numeric: String, minor: Int)] = isoInfo.CcyTbl.CcyNtry.compactMap {
            guard let code = $0.Ccy, let minor = $0.CcyMnrUnts.flatMap(Int.init), let numeric = $0.CcyNbr else { return nil }
            return (name: $0.CcyNm, code: code, numeric: numeric, minor: minor)
        }
        // we unique currencies by just keying them on the code
        var unique: [String: (name: String, code: String, numeric: String, minor: Int)] = [:]
        valid.forEach {
            if unique[$0.code] != nil { assert(unique[$0.code]! == $0) }
            unique[$0.code] = $0
        }
        let data: [CurrencyModel] = unique.map {
            let v = $0.value
            return CurrencyModel(code: v.code, numeric: v.numeric, minorUnit: v.minor, name: v.name, usedInLinks: [])
        }
        return data
    }
}

// MARK: - XML

extension ISO {
    // <ISO_4217 Pblshd="2018-08-29">
    //     <CcyTbl>
    //         <CcyNtry>
    //             <CtryNm>ALGERIA</CtryNm>
    //             <CcyNm>Algerian Dinar</CcyNm>
    //             <Ccy>DZD</Ccy>
    //             <CcyNbr>012</CcyNbr>
    //             <CcyMnrUnts>2</CcyMnrUnts>
    //         </CcyNtry>
    //         <CcyNtry>
    //             <CtryNm>AMERICAN SAMOA</CtryNm>
    //             <CcyNm>US Dollar</CcyNm>
    //             <Ccy>USD</Ccy>
    //             <CcyNbr>840</CcyNbr>
    //             <CcyMnrUnts>2</CcyMnrUnts>
    //         </CcyNtry>
    //     </CcyTbl>
    // </ISO_4217>
    
    struct CcyNtry: Codable {
        let CtryNm: String
        let CcyNm: String
        let Ccy: String?
        let CcyNbr: String?
        let CcyMnrUnts: String?
    }
    
    struct CcyTbl: Codable {
        let CcyNtry: [CcyNtry]
    }
    
    struct ISO_4217: Codable {
        let CcyTbl: CcyTbl
    }
}

// TODO
// match the names for countries found in xml to ISO names of countries
