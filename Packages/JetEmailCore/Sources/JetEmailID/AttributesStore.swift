//
//  AttributesStore.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import Observation

public protocol AttributesProtocol {
    init()
}

@MainActor
@Observable
public final class AttributesStore<ID: Hashable, Attributes: AttributesProtocol> {

    public var rawValue = [ID: Attributes]()
    
    public init() {}
    
    public subscript(modelID: ID) -> Attributes {
        get {
            if let properties = rawValue[modelID] { return properties }
            
            let properties = Attributes()
            rawValue[modelID] = properties
            return properties
        }
        set { rawValue[modelID] = newValue }
    }
}
