//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

import JetEmailFoundation

public enum Platform : RawRepresentable, CodableValueType {
    case microsoft
    case google
    case other(String)
    
    public init(rawValue: String) {
        self = switch rawValue {
        case "microsoft": .microsoft
           case "google": .google
                 default: .other(rawValue)
        }
    }
    public var rawValue: RawValue {
        switch self {
        case .microsoft: "microsoft"
        case .google   : "google"
        case .other(let rawValue): rawValue
        }
    }
}

