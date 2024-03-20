//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

import Observation
import JetEmailData

@MainActor
@Observable
class SessionStore {
    var rawValue = [GoogleAccountID: GoogleSession]()
    
    subscript(id: GoogleAccountID) -> GoogleSession? {
        get { rawValue[id] }
        set { rawValue[id] = newValue }
    }
}
