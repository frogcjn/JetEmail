//
//  Microsoft.Session.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/20/24.
//

// Session -> Account, KeychainItem

import MSAL

public class Session {
    public let accountID   : Microsoft.ID
    public let username    : String
    public let _msalSession: MSALSession
            
    public init(accountID: Microsoft.ID, username: String, msalSession: MSALSession) {
        self.accountID     = accountID
        self.username      = username
        self._msalSession  = msalSession
    }
}



