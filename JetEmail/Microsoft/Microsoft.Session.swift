//
//  Microsoft.Session.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/20/24.
//

// Session -> Account, KeychainItem

import MSAL

extension Microsoft {
    class Session {
       
        unowned
        let sessionStore: SessionStore
        
        let id         : Microsoft.Account.ID
        let username   : String
        var msalSession: MSALSession
       // { didSet { if msalSession != oldValue { Task { _ = await sessionStore.updateSession(self) } } } }
        
        init(sessionStore: SessionStore, id: Microsoft.Account.ID, username: String, msalSession: MSALSession) {
            self.sessionStore = sessionStore
            self.id           = id
            self.username     = username
            self.msalSession  = msalSession
        }
    }
}
