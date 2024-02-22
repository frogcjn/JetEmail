//
//  MSAL.Account.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

// Account = Client + Account.ID

import MSAL // for MSALAccount

extension Microsoft {
    struct Account {
        let client  : Client

        let id         : ID
        let username   : String
        let msalAccount: MSALAccount
        
        fileprivate init(client: Client, id: ID, username: String, msalAccount: MSALAccount) {
            self.client = client
            self.id = id
            self.username = username
            self.msalAccount = msalAccount
        }
    }
}


// Microsoft.Session -> Miccrosoft.Account

extension Microsoft.Session {
    var account: Microsoft.Account {
        .init(client: sessionStore.client, id: id, username: username, msalAccount: msalSession.account)
    }
}

// MSALAccount -> Microsoft.Account

extension MSALAccount {
    func microsoftAccount(client: Microsoft.Client) throws -> Microsoft.Account {
        guard let id = identifier, let username = username else { throw Microsoft.AuthError.accountNoIDOrUsername }
        return Microsoft.Account(client: client, id: .init(string: id), username: username, msalAccount: self)
    }
}

