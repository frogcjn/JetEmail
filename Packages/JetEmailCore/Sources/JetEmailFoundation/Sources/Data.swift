//
//  JSON.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import struct Foundation.Data

// MARK: Data

public extension String {
    var data: Data { get throws {
        guard let data = data(using: .utf8) else { throw FoudnationError.stringToData }
        return data
    } }
}

public extension Data {
    // // String(decoding: self, as: UTF8.self)
    var string: String { get throws {
        guard let string = String(data: self, encoding: .utf8) else { throw FoudnationError.dataToString }
        return string
    } }
}
