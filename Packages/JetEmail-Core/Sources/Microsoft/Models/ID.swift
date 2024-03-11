//
//  Model.IDs.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import JetEmail_Foundation


// MARK: - Account.ID <- MSAL

extension MSALAccount {
    var id: MicrosoftAccountID { get throws {
        guard let id = identifier else { throw AuthError.accountNoIDOrUsername }
        return .init(innerID: id)
    } }
    
    var idAndUsername: (id: MicrosoftAccountID, username: String) { get throws {
        guard let id = identifier, let username else { throw AuthError.accountNoIDOrUsername }
        return (.init(innerID: id), username)
    } }
}

extension MSALSession {
    var accountID: MicrosoftAccountID { get throws { try account.id } }
    var accountIDAndUsername: (id: MicrosoftAccountID, username: String) { get throws { try account.idAndUsername }}
}
