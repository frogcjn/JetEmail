//
//  Model.IDs.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import JetEmail_Foundation

// MARK: - Account.ID

public typealias ID = StringID<Account>

public extension Account {
    typealias ID = Microsoft.ID
}

// MARK: - MailFolder.ID

public extension MailFolder {
    typealias ID = StringID<MailFolder>
}

// MARK: - Message.ID

public extension Message {
    typealias ID = StringID<Message>
}

// MARK: - Account.ID <- MSAL

extension MSALAccount {
    var id: ID { get throws {
        guard let stringID = identifier else { throw AuthError.accountNoIDOrUsername }
        return .init(rawValue: stringID)
    } }
    
    var idAndUsername: (id: ID, username: String) { get throws {
        guard let stringID = identifier, let username else { throw AuthError.accountNoIDOrUsername }
        return (.init(rawValue: stringID), username)
    } }
}

extension MSALSession {
    var accountID: ID { get throws { try account.id } }
    var accountIDAndUsername: (id: ID, username: String) { get throws { try account.idAndUsername }}
}
