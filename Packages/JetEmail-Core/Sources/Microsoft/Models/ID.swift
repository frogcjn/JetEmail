//
//  Model.IDs.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import JetEmail_Foundation

// MARK: - Account.ID

public typealias ID = Account.ID

public extension Account {
    typealias ID = ModelID<Account>
}

// MARK: - MailFolder.ID

public extension MailFolder {
    typealias ID = ModelID<MailFolder>
}

// MARK: - Message.ID

public extension Message {
    typealias ID = ModelID<Message>
}

// MARK: - Account.ID <- MSAL

extension MSALAccount {
    var id: ID { get throws {
        guard let innerID = identifier else { throw AuthError.accountNoIDOrUsername }
        return .init(innerID)
    } }
    
    var idAndUsername: (id: ID, username: String) { get throws {
        guard let innerID = identifier, let username else { throw AuthError.accountNoIDOrUsername }
        return (.init(innerID), username)
    } }
}

extension MSALSession {
    var accountID: ID { get throws { try account.id } }
    var accountIDAndUsername: (id: ID, username: String) { get throws { try account.idAndUsername }}
}
