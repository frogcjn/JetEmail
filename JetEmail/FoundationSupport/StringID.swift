//
//  StringID.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

// MARK: - StringID

protocol StringID : Equatable, Codable, Hashable, ExpressibleByStringLiteral , RawRepresentable where RawValue == String, StringLiteralType == String {
    init(_ : String)
    var string: String { get }
}

extension StringID {
    init(stringLiteral value: StringLiteralType) { self.init(value) }
    init(rawValue: RawValue) { self.init(rawValue) }
    var rawValue: String { string }
}


/*public extension DefaultStringInterpolation {
    mutating func appendInterpolation<ID: StringID>(_ id: ID) {
        appendInterpolation(id.rawValue)
    }
}*/

/*extension String.StringInterpolation {
    mutating func appendInterpolation<T>(_ value: T) where T: StringID {
        appendInterpolation(value.rawValue)
    }
}*/


import SwiftUI
extension LocalizedStringKey.StringInterpolation {
    mutating func appendInterpolation<ID: StringID>(_ id: ID)  {
        appendInterpolation(id.string)
    }
}

extension String.StringInterpolation {
    mutating func appendInterpolation<ID: StringID>(_ id: ID) {
        appendInterpolation(id.string)
    }
}


