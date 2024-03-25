//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/25/24.
//

import struct Foundation.Data
import  class Foundation.JSONDecoder
import  class Foundation.JSONEncoder

// MARK: Codable <-> JSONString, JSONData


public extension String {
    func decodeJSON<T: Decodable>(_ type: T.Type) throws -> T {
        return try data.decodeJSON(type)
    }
}


public extension Data {
    func decodeJSON<T: Decodable>(_ type: T.Type) throws -> T {
        try JSONDecoder().decode(T.self, from: self)
    }
}

public extension Encodable {
    var jsonString: String { get throws {
        try jsonData.string
    } }
}

public extension Encodable {
    var jsonData: Data { get throws {
        try JSONEncoder().encode(self)
    } }
}
