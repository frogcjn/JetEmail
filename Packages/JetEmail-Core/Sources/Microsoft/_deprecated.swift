//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

/*
// MARK: - Model + StringID

extension String {
    var googleID: Google.ID {
        .init(string: self)
    }
}*/

/*extension Account : Hashable, Equatable, Identifiable {
    typealias ID = String
    // var id: String { id }
    
    static func ==(lhs: Account, rhs: Account) -> Bool {
        lhs.modelID == rhs.modelID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(modelID)
    }
}*/


/*func _msalRefreshSession(msalAccount: MSALAccount) async throws -> MSALSession {
    let parameters = MSALSilentTokenParameters(scopes: scopes.map(\.rawValue), account: msalAccount)
    return try await _msalClient.acquireTokenSilent(with: parameters)
    /*
     if let error = error as? MSALSilentTokenAcquisitionError, error == .interactionRequired {
                     self.acquireTokenInteractively()
                 } else if let result = result {
                     // Use the access token from result.accessToken
                 } else {
                     print("Unhandled error: \(error?.localizedDescription ?? "Unknown error")")
                 }
     */
}*/

/*var _msalSessions: [MSALSession] { get async throws {
    try await _msalAccounts.asyncMap{ try await $0.lazyMSALSession }
} }*/


/*func refreshedSession(msalAccount: MSALAccount) async throws -> Session {
    if let session = try Session[msalAccount] { return session }
    return try await _msalRefreshSession(msalAccount: msalAccount).session
}*/


/*
extension Message.ID {

    enum Enum : Codable {
        case microsoft(Message.ID)
        //case google(Google.Message.ID)
    }
    
    var enumValue: Enum {
        switch platform {
        case .microsoft: .microsoft(.init(string: platformID))
        case  .google: fatalError()
        //case .google   : .google   (.init(string: platformID))
        }
    }
    
    init(enumValue: Enum) {
        (platform, platformID) = switch enumValue {
        case .microsoft(let platformID): (.microsoft, platformID.string)
        //case .google   (let platformID): (.google   , platformID.string)
        }
    }
}

*/







/*extension MailFolder {
    public struct ID : StringID {
        public let string: String
        public init(string: String) { self.string = string }
    }
}*/

/*extension Message {
    public struct ID : StringID {
        public let string: String
        public init(string: String) { self.string = string }
    }
}*/
/*
extension Google {
    public struct ID : RawStringID {
        public let string: String
        public init(string: String) { self.string = string }
    }
}

extension Google.MailFolder {
    public struct ID : RawStringID {
        public let string: String
        public init(string: String) { self.string = string }
    }
}
*/

// MARK: - MSGraph.Account + Identifiable

/*
extension MSGraph.Account : Identifiable {
    public var id: ID {
        ID(rawValue: identifier ?? "")
    }
}
*/


// MARK: Google -> Google.ID
/*
extension Google.GTMSession {
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

*/

/*// https://learn.microsoft.com/en-us/graph/api/resources/followupFlag

public struct FollowupFlag : Equatable, Hashable, Codable, Sendable {
    // The date and time that the follow-up was finished.
    public let completedDateTime: DateTimeTimeZone?
    /**
     * The date and time that the follow-up is to be finished. Note: To set the due date, you must also specify the
     * startDateTime; otherwise, you get a 400 Bad Request response.
     */
    public let dueDateTime: DateTimeTimeZone?
    // The status for follow-up for an item. Possible values are notFlagged, complete, and flagged.
    public let flagStatus: FollowupFlagStatus
    // The date and time that the follow-up is to begin.
    public let startDateTime: DateTimeTimeZone?
    
    public enum FollowupFlagStatus : String, Codable {
        case notFlagged, complete, and
    }
}*/

// https://learn.microsoft.com/en-us/graph/api/resources/datetimetimezone

/*public struct DateTimeTimeZone : Equatable, Hashable, Codable, Sendable {
    public let dataTime: String
    public let timeZone: String
}

public struct Importance : Codable {
    
}

public struct InferenceClassificationType : Codable {
    
}

public struct InternetMessageHeader : Codable {
    
}*/


/*extension EmailAddress : Equatable, Hashable, Codable, Sendable {
    
}*/

/*

protocol MicrosoftGraphEntity {
    // The unique identifier for an entity. Read-only.
    var id: MSGraph.Message.ID { get }
}

protocol MicrosoftOutlookItem : MicrosoftGraphEntity {
    // The categories associated with the item
    var categories: [String]? { get }
    /**
     * Identifies the version of the item. Every time the item is changed, changeKey changes as well. This allows Exchange to
     * apply changes to the correct version of the object. Read-only.
     */
    var changeKey: String? { get }
    /**
     * The Timestamp type represents date and time information using ISO 8601 format and is always in UTC time. For example,
     * midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z
     */
    var createdDateTime: Date? { get }
    /**
     * The Timestamp type represents date and time information using ISO 8601 format and is always in UTC time. For example,
     * midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z
     */
    var lastModifiedDateTime: Date? { get }
}
*/
/*
public extension Client {
    // account for request
    /*func account(id: ID) async throws -> Account {
        
        // access MSALAcount from keychain
        let msalAccount = try _msalClient.account(forIdentifier: id.string)
        
        // map MSALAccount to Account
        return try msalAccount.microsoftAccount(client: self)
        /*let parameters = MSALAccountEnumerationParameters(identifier: id.rawValue)
         // parameters.returnOnlySignedInAccounts = true
         guard let account = try await client.accountsFromDevice(for: parameters).first else {
         throw MSGraphError.noAccountFound
         }
         return try .init(account)*/
    }*/
    
}
*/
/*
extension Google {
    /*struct AuthError: LocalizedError {
        var message: String
    }*/
    
    enum AuthError : LocalizedError {
        case accountNoIDOrUsername
        case currentAuthorizationFlowIsExisted
        
        case sessionStoreAddFail
        case accountStoreExistedWhenAddNewToKeychain(Google.Session)
        case accountStoreNotExistedWhenAddDuplicatedFound(Google.ID)
        case accountStoreNotExistedWhenDelete(Google.ID)
        case accountStoreNotExistedWhenUpdate(Google.ID)

        case authorizeNoMainWindow
        case message(String)
        case decodeFromKeychainError
        case noAccountFound
    }
    
    enum ResponseError : Error {
        case format
    }
}
*/
/*
@MainActor
public extension MSALSession {
    /*var lazySession: Session { get async throws {
        if let session = try SessionStore.shared[account.id] { session }
        else { try await account.refreshSession }
    } }*/
    
    /*var newSession: Session { get async throws {
        try await account.refreshSession
        /*let (id, username) = try account.idAndUsername
        let session = Session(accountID: id, username: username, msalSession: self)
        SessionStore.shared[id]  = session
        return session*/
    } }*/
    
    /*var lazyReplacementSession: Session { get throws {
        if let session = try Session[account] {
            session._msalSession = self
            return session
        }
        return try newSession
    } }*/
}*/

/*func refreshAccount(_ account: Account) async throws -> Session {
    try await sessionStore.refreshSession(account)
}*/
//_msalSession = try await _msalSession.refresh
// may need interaction
//return self

//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/8/24.
//

/*
extension MSALAccount {
    
    @MainActor
    var _forceRefreshSession: Session { get async throws {
        let (id, username) = try idAndUsername
        
        let session = Session(accountID: id, username: username, msalSession: try await Client.shared._forceRefresh(msalAccount: self))
        SessionStore.shared[id]  = session
        return session
    } }
    
    @MainActor
    var _lazySession: Session { get async throws {
        if let session = try SessionStore.shared[id] {
            session
        } else {
            try await _forceRefreshSession
        }
    } }
}*/

/*@MainActor
static func add(msalSession: MSALSession, isLazy: Bool = true) throws -> Session {
    let (id, username) = try msalSession.accountIDAndUsername
    
    if isLazy {
        if let session = SessionStore.shared[id] { return session }
    }
    
    let session = Session(accountID: id, username: username, msalSession: msalSession)
    SessionStore.shared[id] = session
    return session
}*/



// }



// Keychain -> Keychain

/*public extension Keychain.SessionItem {
    func deleteFrom(keychain: Keychain) async throws -> Keychain.SessionItem {
        try await keychain.deleteItem(self)
    }
}*/

/*
extension Google.Message {
    /*func _print() {
        print("id:", id) // 18dd9dd6644cb062
        print("threadId:", threadId ?? "nil") // nil
        print("labelIds:", labelIds ?? "nil") // nil
        print("historyId:", historyId ?? "nil") // nil
        print("internalDate:", internalDate ?? "nil") // 1708757181000
        print("sizeEstimate:", sizeEstimate ?? "nil") // nil
        print("snippet:", snippet ?? "nil") // Google Voice &lt;#&gt;BofA: DO NOT share this code. We will NEVER call you or text you for it. Code 484154. Reply HELP if you didn&#39;t request it. 如要回复此消息，请在移动设备或计算机上启动 Google Voice (https://voice.
        print("raw:", raw ?? "nil") // nil
        
        if let payload = payload {
            print("====payload====")
            payload._print()
        }
    }*/
}

extension Google.Message.Part {
    /*func _print() {
        print("partID:", partID ?? "nil") // nil
        print("mimeType:", mimeType ?? "nil") // nil
        print("filename:", filename ?? "nil") // nil
        print("headers:", headers?.map { $0.name } ?? "nil") // ["Delivered-To", "Received", "X-Received", "ARC-Seal", "ARC-Message-Signature", "ARC-Authentication-Results", "Return-Path", "Received", "Received-SPF", "Authentication-Results", "DKIM-Signature", "X-Google-DKIM-Signature", "X-Gm-Message-State", "X-Google-Smtp-Source", "MIME-Version", "X-Received", "Message-ID", "Date", "Subject", "From", "To", "Content-Type"]
        print("body:", body ?? "nil") // nil
        
        if let parts = parts {
            for (id, part) in parts.enumerated() {
                print("====part[\(id)]====")
                part._print()
            }
        }
    }*/
}
*/
