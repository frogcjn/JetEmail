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
public class SessionStore {
    public var rawValue = [ID: Session]()
    
    public subscript(id: ID) -> Session? {
        get { rawValue[id] }
        set { rawValue[id] = newValue }
    }
}

/*
@MainActor
public extension Google.Session {
    static subscript(id: Google.ID) -> Google.Session? {
        get {
            guard let session = SessionStore[id] else { return nil }
            return session
        }
        set { SessionStore[id] = newValue }
    }
}
*/
