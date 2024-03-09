//
//  Model.IDs.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import JetEmail_Foundation
import GTMAppAuth

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

// MARK: - Account.ID <- GTM

extension AuthSession {
    var accountID: ID { get throws {
        guard let innerID = userID else { throw AuthError.accountNoIDOrUsername }
        return .init(innerID)
    } }
    
    var accountIDAndUsername: (id: ID, username: String) { get throws {
        guard let innerID = userID, let username = userEmail else { throw AuthError.accountNoIDOrUsername }
        return (.init(innerID), username)
    } }
}

