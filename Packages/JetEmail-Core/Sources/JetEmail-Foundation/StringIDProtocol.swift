//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/7/24.
//
import SwiftUI

// MARK: - Partial

public protocol PartialRawRepresentable<RawValue> {
    associatedtype RawValue
    var rawValue: RawValue { get }
}

public extension PartialRawRepresentable where Self : Equatable, RawValue : Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}
   
public extension PartialRawRepresentable where Self : Encodable, RawValue : Encodable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

public extension PartialRawRepresentable where Self : Hashable, RawValue : Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

public extension String.StringInterpolation {
    mutating func appendInterpolation<ID: PartialRawRepresentable<String>>(_ id: ID) {
        appendInterpolation(id.rawValue)
    }
}

public extension LocalizedStringKey.StringInterpolation {
    mutating func appendInterpolation<ID: PartialRawRepresentable<String>>(_ id: ID)  {
        appendInterpolation(id.rawValue)
    }
}

// MARK: - Normal

public extension String.StringInterpolation {
    mutating func appendInterpolation<ID: RawRepresentable<String>>(_ id: ID) {
        appendInterpolation(id.rawValue)
    }
}

public extension LocalizedStringKey.StringInterpolation {
    mutating func appendInterpolation<ID: RawRepresentable<String>>(_ id: ID)  {
        appendInterpolation(id.rawValue)
    }
}

// MARK: - Fully

public protocol FullyRawRepresentable<RawValue> : PartialRawRepresentable {
    init(rawValue: RawValue)
}

public extension FullyRawRepresentable where Self : Decodable, RawValue : Decodable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(RawValue.self)
        self.init(rawValue: rawValue)
    }
}

// MARK: - StringID Protocol

public typealias StringIDProtocol = FullyRawRepresentable<String>
