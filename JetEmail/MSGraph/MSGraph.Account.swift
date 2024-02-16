//
//  MSAL.Account.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import MSAL // for MSALAccount

extension MSGraph {
    struct Account {
        let id           : ID
        let username     : String
        let msal         : MSALAccount
    }
}

extension MSGraph.Account {
    init(_ msal: MSALAccount) throws {
        guard let id = msal.identifier, let username = msal.username else { throw MSGraphError.accountNoIDOrUsername }
        self.id            = ID(id)
        self.username      = username
        self.msal          = msal
    }
}
