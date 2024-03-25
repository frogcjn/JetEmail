//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

public enum Platform : RawRepresentable, CodableValueType, Sendable {
    case microsoft
    case google
    case other(String)
    
    public init(rawValue: String) {
        switch rawValue {
        case "microsoft": self = .microsoft
           case "google": self = .google
                 default: self = .other(rawValue)
        }
    }
    public var rawValue: String {
        switch self {
        case .microsoft          : "microsoft"
        case .google             : "google"
        case .other(let rawValue): rawValue
        }
    }
}
