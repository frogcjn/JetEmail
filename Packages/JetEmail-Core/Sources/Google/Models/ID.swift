//
//  Model.IDs.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import GTMAppAuth
import JetEmail_ID

// MARK: - Account.ID


/*public extension Account {
}*/

// MARK: - MailFolder.ID

/*public extension MailFolder {
}*/

// MARK: - Message.ID

/*public extension GoogleMessageData {
    func resourceID(accountID: GoogleAccountID) -> GoogleMessageID {
        .init(platform: .google, accountID: accountID, innerID: id)
    }
}*/


//public typealias GoogleAccountID    = AccountID
//public typealias GoogleMessageID    = MessageID<AccountID>
//public typealias GoogleMailFolderID = MailFolderID<AccountID>



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

