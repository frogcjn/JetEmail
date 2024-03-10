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
    var rawValue = [GoogleAccountID: Session]()
    
    subscript(id: GoogleAccountID) -> Session? {
        get { rawValue[id] }
        set { rawValue[id] = newValue }
    }
}
