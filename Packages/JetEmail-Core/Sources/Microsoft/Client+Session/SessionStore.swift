//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/7/24.
//

import Observation
import JetEmail_ID

@MainActor
@Observable
class SessionStore {
    var rawValue = [MicrosoftAccountID: Session]()
    
    subscript(id: MicrosoftAccountID) -> Session? {
        get { rawValue[id] }
        set { rawValue[id] = newValue }
    }
}



/*
@MainActor
public extension Session {
    static subscript(id: ID) -> Session? {
        get {
            guard let session = SessionStore.shared[id] else { return nil }
            return session
        }
        set { SessionStore.shared[id] = newValue }
    }
}*/
