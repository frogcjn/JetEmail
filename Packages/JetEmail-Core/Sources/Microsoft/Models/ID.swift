//
//  Model.IDs.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import JetEmail_Foundation

// MARK: - Account.ID

// public typealias ID = MicrosoftAccountID

public extension MicrosoftAccount {
    //typealias ID = MicrosoftAccountID
}

// MARK: - MailFolder.ID

public extension MailFolder {
    //typealias ID = MicrosoftMailFolderID
}

// MARK: - Message.ID

//public typealias MicrosoftAccountID    = AccountID
//public typealias MicrosoftMessageID    = MessageID<AccountID>
//public typealias MicrosoftMailFolderID = MailFolderID<AccountID>


/*public extension Message {
    //typealias ID = StringID<Message>
    func resourceID(accountID: MicrosoftAccountID) -> MicrosoftMessageID {
        .init(platform: .microsoft, accountID: accountID, innerID: id)
    }
}*/





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
