//
//  Model.IDs.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import JetEmail_Foundation
import GTMAppAuth

// MARK: - Account.ID

public typealias ID = StringID<Account>

public extension Account {
    typealias ID = Google.ID
}

// MARK: - MailFolder.ID

public extension MailFolder {
    typealias ID = StringID<MailFolder>
}

// MARK: - Message.ID

public extension Message {
    typealias ID = StringID<Message>
}

// MARK: - Account.ID <- GTM

extension AuthSession {
    var accountID: ID { get throws {
        guard let stringID = userID else { throw AuthError.accountNoIDOrUsername }
        return .init(rawValue: stringID)
    } }
    
    var accountIDAndUsername: (id: ID, username: String) { get throws {
        guard let stringID = userID, let username = userEmail else { throw AuthError.accountNoIDOrUsername }
        return (.init(rawValue: stringID), username)
    } }
}
