//
//  Model.IDs.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import Foundation
import SwiftData
import JetEmail_Foundation

// MARK: - Model + StringID

public extension String {
    var googleID: ID {
        .init(rawValue: self)
    }
}

public enum Account {}

public typealias ID = StringID<Account>

public extension MailFolder {
    typealias ID = StringID<MailFolder>
}

public extension Message {
    typealias ID = StringID<Message>
}

// MARK: Google -> Google.ID

public extension GTMSession {
    var accountID: Google.ID {
        get throws {
            guard let stringID = userID else { throw Google.AuthError.accountNoIDOrUsername }
            return .init(rawValue: stringID)
        }
    }
    
    var accountIDAndUsername: (id: Google.ID, username: String) {
        get throws {
            guard let stringID = userID, let username = userEmail else { throw Google.AuthError.accountNoIDOrUsername }
            return (.init(rawValue: stringID), username)
        }
    }
}



