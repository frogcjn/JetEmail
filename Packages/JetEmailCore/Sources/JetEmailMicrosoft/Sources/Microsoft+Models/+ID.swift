//
//  Model.IDs.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import JetEmailData

// MARK: - Account.ID <- MSAL

extension MSALAccount {
    var id: MicrosoftAccountID { get throws {
        guard let id = identifier else { throw AuthError.accountNoIDOrUsername }
        return .init(innerID: id)
    } }
    
    var outer: MicrosoftAccount { get throws {
        guard let id = identifier, let username else { throw AuthError.accountNoIDOrUsername }
        return .init(id: .init(innerID: id), username: username)
    } }
}

extension MSALSession {
    var accountID: MicrosoftAccountID { get throws { try account.id } }
    var outerAccount: MicrosoftAccount { get throws { try account.outer }}
}
