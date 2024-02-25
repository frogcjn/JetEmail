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
                let id          : Microsoft.ID
                let username    : String
                let _msalSession: MSALSession
                
        init(id: Microsoft.ID, username: String, msalSession: MSALSession) {
            self.id            = id
            self.username      = username
            self._msalSession  = msalSession
        }
    }
}

