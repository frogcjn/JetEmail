//
//  StringID.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

// MARK: - StringID

public protocol StringID : Equatable, Codable, Hashable {
    var string: String { get }
    init(string: String) throws // may throws
}

public protocol RawStringID : StringID, RawRepresentable {}
public extension RawStringID {
    init(rawValue: String) { try! self.init(string: rawValue) }
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
public extension LocalizedStringKey.StringInterpolation {
    mutating func appendInterpolation<ID: StringID>(_ id: ID)  {
        appendInterpolation(id.string)
    }
}

public extension String.StringInterpolation {
    mutating func appendInterpolation<ID: StringID>(_ id: ID) {
        appendInterpolation(id.string)
    }
}


