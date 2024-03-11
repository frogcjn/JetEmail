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
        .init(string: self)
    }
}

public struct ID : RawStringID {
    public let string: String
    public init(string: String) { self.string = string }
}

public extension MailFolder {
    struct ID : RawStringID {
        public let string: String
        public init(string: String) { self.string = string }
    }
}



// MARK: Google -> Google.ID

public extension GTMSession {
    var id: Google.ID {
        get throws {
            guard let stringID = userID else { throw Google.AuthError.accountNoIDOrUsername }
            return .init(string: stringID)
        }
    }
    
    var idAndUsername: (id: Google.ID, username: String) {
        get throws {
            guard let stringID = userID, let username = userEmail else { throw Google.AuthError.accountNoIDOrUsername }
            return (.init(string: stringID), username)
        }
    }
}



