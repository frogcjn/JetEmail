//
//  Session.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/21/24.
//

import Observation
import Google
import Microsoft

enum Session {
    case microsoft(Microsoft.Session)
    case google(Google.Session)
}

extension Account {
    
    var session: Session? {
        get {
            switch self.modelID {
            case .microsoft(let id): MicrosoftSessionStore[id].map(Session.microsoft)
            case .google(let id): GoogleSessionStore[id].map(Session.google)
            }
        }
        set {
            switch newValue {
            case .microsoft(let ms): MicrosoftSessionStore[ms.accountID] = ms
            case .google(let google): GoogleSessionStore[google.accountID] = google
            case nil:
                switch self.modelID {
                case .microsoft(let id): MicrosoftSessionStore[id] = nil
                case .google(let id): GoogleSessionStore[id] = nil
                }
            }
        }
    }
}
