//
//  Model.IDs.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import GTMAppAuth
import JetEmailData

// MARK: - Account.ID <- GTM

extension AuthSession {
    var accountID: GoogleAccountID { get throws {
        guard let innerID = userID else { throw AuthError.accountNoIDOrUsername }
        return .init(innerID: innerID)
    } }
    
    var accountIDAndUsername: (id: GoogleAccountID, username: String) { get throws {
        guard let innerID = userID, let username = userEmail else { throw AuthError.accountNoIDOrUsername }
        return (.init(innerID: innerID), username)
    } }
}
