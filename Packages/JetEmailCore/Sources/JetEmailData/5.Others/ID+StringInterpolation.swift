//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

import SwiftUI

public extension String.StringInterpolation {
    mutating func appendInterpolation<ID: ResourceIDProtocol>(_ id: ID) {
        appendInterpolation(id.innerID)
    }
}

public extension LocalizedStringKey.StringInterpolation {
    mutating func appendInterpolation<ID: ResourceIDProtocol>(_ id: ID)  {
        appendInterpolation(id.innerID)
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
