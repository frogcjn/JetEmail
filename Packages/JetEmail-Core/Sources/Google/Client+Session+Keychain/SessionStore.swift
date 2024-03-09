//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

import Observation
import JetEmail_Foundation

@MainActor
@Observable
class SessionStore {
    var rawValue = [ID: Session]()
    
    subscript(id: ID) -> Session? {
        get { rawValue[id] }
        set { rawValue[id] = newValue }
    }
}
