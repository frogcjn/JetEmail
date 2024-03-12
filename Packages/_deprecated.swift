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
/*
// MARK: - Account.ID

// public typealias ID = MicrosoftAccountID

public extension MicrosoftAccount {
    //typealias ID = MicrosoftAccountID
}

// MARK: - MailFolder.ID

public extension Inner {
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

*/

//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/8/24.
//


/*
// MARK: - Convenience
extension MailFolder {
    init?(gtlrGmailLabel: GTLRGmail_Label) {
        /*guard let name = gmailFolder.name else { return nil }
        guard let id = gmailFolder.identifier else {
            assertionFailure("Gmail folder \(gmailFolder) doesn't have identifier")
            return nil
        }
        // folder.identifier is missing for hidden GTLRGmail_Labels
        if path.isEmpty {
            return nil
        }

        if GeneralConstants.Gmail.standardGmailPaths.contains(path) {
            name = "folder_\(name.replacingOccurrences(of: " ", with: "_"))"
        }*/
        
       
       //  let image: Data?
        // let backgroundColor: String? //?
        //let isHidden: Bool? //?
        //var itemType: String? = FolderViewModel.ItemType.folder.rawValue //?
        
    }
}

 init(path: String, name: String, image: Data? = nil, backgroundColor: String? = nil, isHidden: Bool? = nil, itemType: String? = nil) {
     self.path = path
     self.name = name
     self.image = image
     self.backgroundColor = backgroundColor
     self.isHidden = isHidden
     self.itemType = itemType
 }
 
*/

/*
@MainActor
public extension Session {
    static subscript(id: ID) -> Session? {
        get {
            guard let session = SessionStore[id] else { return nil }
            return session
        }
        set { SessionStore[id] = newValue }
    }
}
*/



// GTMSession -> Keychain
/*
fileprivate extension GTMSession {
    func insertTo(keychain: Keychain) async throws -> Keychain.SessionItem {
        try await keychain.insertItem(gtmSession: self)
    }
}
*/

// Session -> Keychain


// KeyChain -> Session
/*
@MainActor
extension Keychain.SessionItem {
    var lazySession: Session {
        if let session = SessionStore.shared[accountID] {
            assert(session.keychainItem == keychainItem)
            return session
        }
        return newSession
    }
    
    var newSession: Session {
        let session = Session(accountID: accountID, username: username, gtmSession: gtmSession, keychainItem: keychainItem)
        SessionStore.shared[accountID]  = session
        return session
    }
    
    /*var lazyReplacementSession: Session {
        if let session = Session[id] {
            session.gtmSession = gtmSession
            assert(session.keychainItem === keychainItem)
            return session
        }
        return newSession
    }*/
    
}

*/
//
//  StringID.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//


/*
public protocol AccountResource : ResourceIDProtocol {
}
extension AccountResource {
    var   type : ResourceType { .account }
    var account: String       { element  }
}

public protocol MailFolderResource : ResourceIDProtocol {
}

extension MailFolderResource {
    var   type : ResourceType { .mailFolder }
}

public protocol MessageResponse : ResourceIDProtocol {
}

extension MessageResponse {
    var   type : ResourceType { .message }
}

public protocol MicrosoftResource : ResourceIDProtocol {
}

extension MicrosoftResource {
    var platform: Platform { .microsoft }
}

public protocol GoogleResource : ResourceIDProtocol {
    
}

extension GoogleResource {
    var platform: Platform { .google }
}*/




/*
public struct StringID<Owner> : IDProtocol, Decodable {
    public let innerID: String
    public init(_ innerID: String) {
        self.innerID = innerID
    }
    
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.innerID = try container.decode(String.self)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.innerID)
    }
    
    public var rawID: String { innerID }
}

public struct AccountModelID<AccountType, Owner> : IDProtocol {
        
    public let accountID: StringID<AccountType>
    public let   innerID: StringID<Owner>
    
    public init(accountID: StringID<AccountType>, _ innerID: StringID<Owner>) {
        self.accountID = accountID
        self  .innerID = innerID
    }
    
    public var rawID: String { "\(accountID)/\(innerID)" }
}
/*
public protocol PlatformAccountModelIDProtocol<OwnerType> : IDProtocol /*where*PlatformType : CodableValueType, AccountID : CodableValueType, InnerID : CodableValueType*/  {
    associatedtype PlatformType : CodableValueType
    associatedtype AccountID    : CodableValueType
    associatedtype InnerID      : CodableValueType
    var  platform: PlatformType { get }
    var accountID: AccountID { get }
    var   innerID: InnerID { get }
    init(platform: PlatformType, accountID: AccountID, _ innerID: InnerID)/* {
        self.platform = platform
        self.accountID = accountID
        self.innerID = innerID
    }*/
}*/



/*
public struct ModelID<OwnerType> : IDProtocol {
    public let innerID: String
    public init(_ innerID: String) {
        self.innerID = innerID
    }
    
    public var rawValue: String { innerID }
}
*/
*/

//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/7/24.
//
// import SwiftUI

// MARK: - Partial



/*public extension PartialRawRepresentable where Self : Equatable, RawValue : Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}*/
/*
public extension PartialRawRepresentable where Self : Encodable, RawValue : Encodable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}*/

/*public extension PartialRawRepresentable where Self : Hashable, RawValue : Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}*/


/*
// MARK: - Fully

public protocol FullyRawRepresentable<RawValue> : PartialRawRepresentable {
    init(rawValue: RawValue)
}

public extension FullyRawRepresentable where Self : Decodable, RawValue : Decodable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(RawValue.self)
        self.init(rawValue: rawValue)
    }
}*/

// MARK: - StringID Protocol

/*public protocol StringIDProtocol<OwnerType> : PartialRawRepresentable, Decodable where RawValue == String {
    associatedtype OwnerType
}*/



//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/8/24.
//




/*convenience init(graph: MSGraph.Message, in mailFolder: MailFolder) {
    self.init(modelID: graph.modelID, in: mailFolder)
    self.graph = graph
}*/

/*var graph: MSGraph.Message {
    get throws {
        guard let _graph else { throw SwiftDataError.noGraphInstance(model: self) }
        return try _graph.jsonDecode(MSGraph.Message.self)
    }
}*/

/*
 func update(graph: MSGraph.MailFolder, in account: Account) {
     self.modelID  = graph.modelID
     self.name     = graph.displayName ?? ""
     self.account  = account
     
     self._graph   = try? graph.jsonString
 }
 */

/*
// MARK: - Model + StringID

extension String {
    var googleID: Google.ID {
        .init(string: self)
    }
}*/

/*extension Account : Hashable, , Identifiable {
    typealias ID = String
    // var id: String { id }
    
    static func ==(lhs: Account, rhs: Account) -> Bool {
        lhs.modelID == rhs.modelID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(modelID)
    }
}*/


/*extension MailFolder : Hashable, , Identifiable {
    // var id: String { id }

    static func ==(lhs: MailFolder, rhs: MailFolder) -> Bool {
        lhs.persistentID == rhs.persistentID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(persistentID)
    }
}

extension Message : Hashable, Equatable, Identifiable {
    // var id: String { id }

    static func ==(lhs: Message, rhs: Message) -> Bool {
        lhs.persistentID == rhs.persistentID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(persistentID)
    }
}*/













/*
extension Message.ID {

    enum Enum : Codable {
        case microsoft(Microsoft.Message.ID)
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
    public struct ID {
        public let string: String
        public init(string: String) { self.string = string }
    }
}*/

/*extension Message {
    public struct ID {
        public let string: String
        public init(string: String) { self.string = string }
    }
}*/

// MARK: - Microsoft.ID
/*
extension Microsoft {
    public struct ID : RawStringID {
        public let string: String
        public init(string: String) { self.string = string }
    }
}

extension Microsoft.MailFolder {
    public struct ID : RawStringID {
        public let string: String
        public init(string: String) { self.string = string }
    }
}

extension Microsoft.Message {
    public struct ID : RawStringID {
        public let string: String
        public init(string: String) { self.string = string }
    }
}*/
// MARK: - Google.ID
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

// MARK: Microsoft -> Microsoft.ID
/*
extension Microsoft.MSALAccount {
    var id: Microsoft.ID {
        get throws {
            guard let stringID = identifier else { throw Microsoft.AuthError.accountNoIDOrUsername }
            return .init(string: stringID)
        }
    }
    
    var idAndUsername: (id: Microsoft.ID, username: String) {
        get throws {
            guard let stringID = identifier, let username else { throw Microsoft.AuthError.accountNoIDOrUsername }
            return (.init(string: stringID), username)
        }
    }
}

extension Microsoft.MSALSession {
    var id: Microsoft.ID { get throws { try account.id } }
}*/


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



// MARK: - Model <-> MSGraph
/*
extension Account {
    convenience init(microsoft: Microsoft.Account) throws {
        self.init(
            modelID: microsoft.modelID,
            username: microsoft.username
        )
    }
    
    var graph: Microsoft.Account? {
        @available(macOS, unavailable, message: "Parse Use graph(_ client: MSGraph) instead.")
        @available(iOS, unavailable, message: "Parse Use graph(_ client: MSGraph) instead.")
        get {
            nil // should use graph(_:)
        }
        set {
            guard let graph = newValue else { return }
            self.modelID  = graph.modelID
            self.username = graph.username
        }
    }
    
    func update(microsoft: Microsoft.Account, deleteMark: Bool = false) {
        if self.modelID == microsoft.modelID && self.username == microsoft.username && self.deleteMark == deleteMark { return }
        self.deleteMark = deleteMark
        self.modelID  = microsoft.modelID
        self.username = microsoft.username
    }
}
*/
//
//  UnifiedID+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import JetEmailMicrosoft
import JetEmailGoogle


    
/*    /*var platformID: String {
        switch self {
        case .microsoft(let platformID): platformID.rawValue
        case .google   (let platformID): platformID.rawValue
        }
    }
    

    init(platform: Platform, platformID: String) {
        self = switch platform {
        case .microsoft: .microsoft(.init(rawValue: platformID))
        case .google   : .google   (.init(rawValue: platformID))
        }
    }*/
}*/

//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/7/24.
//

import JetEmailGoogle
import JetEmailMicrosoft
import JetEmailFoundation

// MARK: - Account.ID <- Google, Microsoft

/*public extension MicrosoftAccountID {
    var unifiedAccountID: JetEmail_Data.Account.ID { self }
}*/

/*public extension Microsoft.MSALAccount {
    var unifiedAccountID: JetEmail_Data.Account.ID { get throws { try id.unifiedAccountID } }
}

public extension Microsoft.MSALSession {
    var unifiedAccountID: JetEmail_Data.Account.ID { get throws { try account.unifiedAccountID } }
}*/

/*public extension Microsoft.Session {
    var unifiedAccountID: JetEmail_Data.Account.ID { accountID.unifiedAccountID }
}*/

/*public extension GoogleAccountID {
    var unifiedAccountID: JetEmail_Data.Account.ID { self }
}*/

/*public extension Google.GTMSession {
    var unifiedAccountID: JetEmail_Data.Account.ID { get throws { try accountID.unifiedAccountID } }
}*/

/*public extension Google.Session {
    var unifiedAccountID: JetEmail_Data.Account.ID { accountID.unifiedAccountID }
}*/

// MARK: - MailFolder.ID <- Google, Microsoft

/*public extension MicrosoftMailFolderID {
    var unifiedID: JetEmail_Data.MailFolder.ID {
        self
    }
}*/

/*public extension Microsoft.MailFolder {
    var unifiedID: JetEmail_Data.MailFolder.ID {
        id.unifiedID
    }
}*/

/*public extension GoogleMailFolderID {
    var unifiedID: JetEmail_Data.MailFolder.ID {
        self
    }
}*/

/*public extension Google.MailFolder {
    var unifiedID: JetEmail_Data.MailFolder.ID {
        id.unifiedID
    }
}*/

// MARK: - Message.ID <- Google, Microsoft

/*public extension MicrosoftMessageID {
    var unifiedID: JetEmail_Data.Message.ID {
        self
    }
}*/

/*public extension Microsoft.Message {
    var unifiedID: JetEmail_Data.Message.ID {
        id.unifiedID
    }
}*/

/*public extension GoogleMessageID {
    var unifiedID: JetEmail_Data.Message.ID {
        self
    }
}*/

/*public extension Google.Message {
    var unifiedID: JetEmail_Data.Message.ID {
        id.unifiedID
    }
}*/

// MARK: - Account|MailFolder|Message -> Google, Microsoft

/*public extension JetEmail_Data.UnifiedID {
    var microsoftID: Owner.MicrosoftID? {
        guard case .microsoft(let microsoftID) = self else { return nil }
        return microsoftID
    }
    
    var googleID: Owner.GoogleID? {
        guard case .google(let googleID) = self else { return nil }
        return googleID
    }
}

public extension UnifiedModel where ID == UnifiedID<Self> {
    var microsoftID: MicrosoftID? { id.microsoftID }
    var    googleID:    GoogleID? { id.googleID    }
}*/

//
//  ID.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import JetEmailFoundation

/*public enum UnifiedID<Owner : UnifiedModel> : IDProtocol {
    case microsoft(Owner.MicrosoftID)
    case    google(Owner.GoogleID)
}

public extension UnifiedID {

    var platform: Platform {
        switch self {
        case .microsoft: .microsoft
        case .google   : .google
        }
    }
    
    var resourceID: String {
        switch self {
        case .microsoft(let platformID): platformID.resourceID
        case .google   (let platformID): platformID.resourceID
        }
    }
}*/






/*
extension UnifiedID : PartialRawRepresentable {
    public var rawValue: String { "\(platform.rawValue)/\(platformID)" }
}

extension UnifiedID : Sendable where MicrosoftID : Sendable, GoogleID : Sendable {}
extension UnifiedID : Hashable, Equatable, Encodable/* where Model.MicrosoftID : StringIDProtocol, Model.GoogleID: StringIDProtocol*/ {}
*/

//
//  Platform.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import JetEmailFoundation



//public typealias MicrosoftID = MicrosoftAccountID
// public typealias    GoogleID =    GoogleAccountID
// public typealias ID = UnifiedID<Account>

//public typealias MicrosoftID = MicrosoftMailFolderID
//public typealias    GoogleID =    GoogleMailFolderID
// public typealias ID = UnifiedID<MailFolder>

//public typealias MicrosoftID = MicrosoftMessageID
//public typealias    GoogleID =    GoogleMessageID
//public typealias ID = UnifiedID<Message>
/*
public extension UnifiedID<Account> {
    var innerID: String {
        switch self {
        case .microsoft(let id): id.innerID
        case    .google(let id): id.innerID
        }
    }
}

public extension UnifiedID<MailFolder> {
    var innerID: String {
        switch self {
        case .microsoft(let id): id.innerID
        case    .google(let id): id.innerID
        }
    }
    
    var innerAccountID : String {
        switch self {
        case .microsoft(let id): id.accountID.innerID
        case    .google(let id): id.accountID.innerID
        }
    }
}

public extension UnifiedID<Message> {
    var innerID: String {
        switch self {
        case .microsoft(let id): id.innerID
        case    .google(let id): id.innerID
        }
    }
    
    var innerAccountID : String {
        switch self {
        case .microsoft(let id): id.accountID.innerID
        case    .google(let id): id.accountID.innerID
        }
    }
}
*/
//
//  ModelItem.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import SwiftData
import JetEmailFoundation




// MicrosoftID : CodableValueType & PartialRawRepresentable<String>, GoogleID : CodableValueType & PartialRawRepresentable<String>


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


/*public extension ResourceIDProtocol {
    var resourceID: String { "\(ResourceType.resourceType)/\(platform)/\(accountID.innerID)/\(innerID)" }  // combined all information to be the unique ID on the platform
}*/

/*

public struct GoogleMailFolderID<Owner> : ResourceIDProtocol, GoogleType {

    public typealias ResourceType = MailFolderType

    public var accountID: String
    public var   innerID: String
    
    public init<Account>(accountID: GoogleAccountID<Account>, innerID: String) {
        self.accountID = accountID
        self.innerID = innerID
    }
}

public struct GoogleMessageID<Owner> : ResourceIDProtocol, GoogleType {

    public typealias ResourceType = MessageType

    public var accountID: String
    public var   innerID: String
    
    public init(accountID: GoogleAccountID, innerID: String) {
        self.accountID = accountID
        self.innerID   = innerID
    }
}





public struct MicrosoftMailFolderID<Owner> : ResourceIDProtocol, MicrosoftType {

    public typealias ResourceType = MailFolderType

    public var accountID: MicrosoftAccountID
    public var   innerID: String
    
    public init(accountID: MicrosoftAccountID, innerID: String) {
        self.accountID = accountID
        self.innerID = innerID
    }
}

public struct MicrosoftMessageID<Owner> : ResourceIDProtocol, MicrosoftType {

    public typealias ResourceType = MessageType

    public var accountID: MicrosoftAccountID
    public var   innerID: String
    
    public init(accountID: MicrosoftAccountID, innerID: String) {
        self.accountID = accountID
        self.innerID      = innerID
    }
}
*/



// MARK: - ID Protocols

// protocol IDProtocol : CodableValueType {}

//
//  MailFolder+UI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//
/*
// isSystemFolder
// systemOrder
// localized: LocalizedStringResource
// systemImage
import JetEmailGoogle
import JetEmailMicrosoft
import Foundation
import JetEmailID

public extension PlatformCase<MicrosoftMailFolder, GoogleMailFolder> {
    var isSystemFolder: Bool {
        switch self {
        case .google(let google):
            guard let type = google.inner.type else { return false }
            return type == .system
        case .microsoft(let microsoft):
            return microsoft. != nil
        }
    }
    
    var systemOrder: Int? {
        guard isSystemFolder else { return nil }
        switch self {
        case .google(let google):
            switch google.inner.name {
            case "INBOX"              : return 0
            case "STARRED"            : return 1
            case "SNOOZED"            : return 2 // ?
            case "IMPORTANT"          : return 3
            case "CHAT"               : return 4
            case "SENT"               : return 5
            case "SCHEDULED"          : return 6 // ?
            case "DRAFT"              : return 7
            case ""                   : return 8
            case "SPAM"               : return 9
            case "TRASH"              : return 10
            case "UNREAD"             : return 11 //?
                
            case "CATEGORY_SOCIAL"    : return 100
            case "CATEGORY_FORUMS"    : return 101
            case "CATEGORY_UPDATES"   : return 102
            case "CATEGORY_PROMOTIONS": return 103
            case "CATEGORY_PERSONAL"  : return 104
            
            default: return nil
            }
            
        case .microsoft(let microsoft):
            guard let wellKnownFolderName = microsoft. else { return nil }
            switch wellKnownFolderName {
            case .inbox                    : return 0
            case .drafts                   : return 1
            case .archive                  : return 2
            case .sentItems                : return 3
            case .deletedItems             : return 4
            case .junkEmail                : return 5
            case .outbox                   : return 6
            case .scheduled                : return 7
            case .clutter                  : return 8
                // 便笺
            case .conversationHistory      : return Int.max
            default: return nil
            }
                
            /* return String(localized: "Microsoft.MailFolder.clutter")
            case .conflicts                : return String(localized: "Microsoft.MailFolder.conflicts")
            case .localFailures            : return String(localized: "Microsoft.MailFolder.localFailures")
            case .msgFolderRoot            : return String(localized: "Microsoft.MailFolder.msgFolderRoot")
            case .recoverableItemsDeletions: return String(localized: "Microsoft.MailFolder.recoverableItemsDeletions")
            case .searchFolders            : return String(localized: "Microsoft.MailFolder.searchFolders")
            case .serverFailures           : return String(localized: "Microsoft.MailFolder.serverFailures")
            case .syncIssues               : return String(localized: "Microsoft.MailFolder.syncIssues")*/
                
        }
    }
    
    var nameLocalizedKey: String? {
        switch self {
        case .google(let google):
            guard let type = google.inner.type else { return nil }
            switch type {
            case .system:
                // https://developers.google.com/gmail/api/guides/labels
                switch google.inner.name {
                    
                case "INBOX"              : return LocalizedStringResource("Google.MailFolder.INBOX").key
                case "STARRED"            : return LocalizedStringResource("Google.MailFolder.STARRED").key
                case "SNOOZED"            : return LocalizedStringResource("Google.MailFolder.SNOOZED").key
                case "IMPORTANT"          : return LocalizedStringResource("Google.MailFolder.IMPORTANT").key
                case "CHAT"               : return LocalizedStringResource("Google.MailFolder.CHAT").key
                case "SENT"               : return LocalizedStringResource("Google.MailFolder.SENT").key
                case "SCHEDULED"          : return LocalizedStringResource("Google.MailFolder.SCHEDULED").key
                case "DRAFT"              : return LocalizedStringResource("Google.MailFolder.DRAFT").key
                case ""                   : return LocalizedStringResource("Google.MailFolder.").key
                case "SPAM"               : return LocalizedStringResource("Google.MailFolder.SPAM").key
                case "TRASH"              : return LocalizedStringResource("Google.MailFolder.TRASH").key
                case "UNREAD"             : return LocalizedStringResource("Google.MailFolder.UNREAD").key

                case "CATEGORY_PERSONAL"  : return LocalizedStringResource("Google.MailFolder.CATEGORY_PERSONAL").key
                case "CATEGORY_SOCIAL"    : return LocalizedStringResource("Google.MailFolder.CATEGORY_SOCIAL").key
                case "CATEGORY_PROMOTIONS": return LocalizedStringResource("Google.MailFolder.CATEGORY_PROMOTIONS").key
                case "CATEGORY_UPDATES"   : return LocalizedStringResource("Google.MailFolder.CATEGORY_UPDATES").key
                case "CATEGORY_FORUMS"    : return LocalizedStringResource("Google.MailFolder.CATEGORY_FORUMS").key
                default:
                    return nil
                }
            case .user:
                return nil
            }
        case .microsoft(let microsoft):
            guard let wellKnownFolderName = microsoft. else { return nil }
            switch wellKnownFolderName {
            case .archive                  : return LocalizedStringResource("Microsoft.MailFolder.archive").key
            case .clutter                  : return LocalizedStringResource("Microsoft.MailFolder.clutter").key
            case .conflicts                : return LocalizedStringResource("Microsoft.MailFolder.conflicts").key
            case .conversationHistory      : return LocalizedStringResource("Microsoft.MailFolder.conversationHistory").key
            case .deletedItems             : return LocalizedStringResource("Microsoft.MailFolder.deletedItems").key
            case .drafts                   : return LocalizedStringResource("Microsoft.MailFolder.drafts").key
            case .inbox                    : return LocalizedStringResource("Microsoft.MailFolder.inbox").key
            case .junkEmail                : return LocalizedStringResource("Microsoft.MailFolder.junkEmail").key
            case .localFailures            : return LocalizedStringResource("Microsoft.MailFolder.localFailures").key
            case .msgFolderRoot            : return LocalizedStringResource("Microsoft.MailFolder.msgFolderRoot").key
            case .outbox                   : return LocalizedStringResource("Microsoft.MailFolder.outbox").key
            case .recoverableItemsDeletions: return LocalizedStringResource("Microsoft.MailFolder.recoverableItemsDeletions").key
            case .scheduled                : return LocalizedStringResource("Microsoft.MailFolder.scheduled").key
            case .searchFolders            : return LocalizedStringResource("Microsoft.MailFolder.searchFolders").key
            case .sentItems                : return LocalizedStringResource("Microsoft.MailFolder.sentItems").key
            case .serverFailures           : return LocalizedStringResource("Microsoft.MailFolder.serverFailures").key
            case .syncIssues               : return LocalizedStringResource("Microsoft.MailFolder.syncIssues").key
            }
        }
    }
    
    var systemImage: String? {
        switch self {
        case .google(let google):
            guard let type = google.inner.type else { return nil }
            switch type {
            case .system:
                // https://developers.google.com/gmail/api/guides/labels
                switch google.id.innerID {
                case "INBOX"              : return "tray"
                case "SPAM"               : return "xmark.bin"
                case "TRASH"              : return "trash"
                case "UNREAD"             : return "envelope.badge"
                case "STARRED"            : return "star"
                case "IMPORTANT"          : return "bookmark"
                case "SENT"               : return "paperplane"
                case "DRAFT"              : return "doc"
                case "CHAT"               : return "bubble"
                case "CATEGORY_PERSONAL"  : return "person"
                case "CATEGORY_SOCIAL"    : return "person.2"
                case "CATEGORY_PROMOTIONS": return "tag"
                case "CATEGORY_UPDATES"   : return "info.circle"
                case "CATEGORY_FORUMS"    : return "bubble.left.and.bubble.right"
                default:
                    return nil
                }
            case .user:
                return nil
            }
        case .microsoft(let microsoft):
            guard let wellKnownFolderName = microsoft.
 else { return nil }
            switch wellKnownFolderName {
            case .archive                  : return "archivebox"
            case .clutter                  : return "shippingbox"
            case .conflicts                : return "bolt.trianglebadge.exclamationmark"
            case .conversationHistory      : return "bubble"
            case .deletedItems             : return "trash"
            case .drafts                   : return "doc"
            case .inbox                    : return "tray"
            case .junkEmail                : return "xmark.bin"
            case .localFailures            : return "exclamationmark.triangle"
            case .msgFolderRoot            : return "tree"
            case .outbox                   : return "tray.and.arrow.up"
            case .recoverableItemsDeletions: return "arrow.triangle.2.circlepath"
            case .scheduled                : return "clock"
            case .searchFolders            : return "magnifyingglass"
            case .sentItems                : return "paperplane"
            case .serverFailures           : return "server.rack"
            case .syncIssues               : return "exclamationmark.arrow.triangle.2.circlepath"
            }
        }
    }
}
*/
//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/11/24.
//
/*
import JetEmailFoundation

public enum ResourceType: String, CodableValueType, Sendable {
    case account
    case mailFolder
    case message
}

*/
//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/11/24.
//
/*
public protocol ResourceSpecific {
    static var resourceType: ResourceType { get }
}

public enum    AccountResourceSpecific : ResourceSpecific {
    public static var resourceType : ResourceType { .account    }
}
public enum MailFolderResourceSpecific : ResourceSpecific {
    public static var resourceType : ResourceType { .mailFolder }
}
public enum    MessageResourceSpecific : ResourceSpecific {
    public static var resourceType : ResourceType { .message    }
}
*/

/*
public enum MailFolderPlatformCase<Microsoft : PlatformResourceProtocol & MailFolderResourceProtocol, Google : PlatformResourceProtocol & MailFolderResourceProtocol> : MailFolderResourceProtocol where Microsoft.ID == MicrosoftMailFolderID, Google.ID == GoogleMailFolderID {
    
    case microsoft(Microsoft)
    case    google(Google)
    
    public var name: String? {
        switch self {
        case .microsoft(let platform): platform.name
        case .google(let platform): platform.name
        }
    }
    
    public var systemInfo: MailFolderSystemInfo? {
        switch self {
        case .microsoft(let platform): platform.systemInfo
        case .google(let platform): platform.systemInfo
        }
    }
    
    public var id: MailFolderID {
        switch self {
        case .microsoft(let platform): platform.id.general
        case .google(let platform): platform.id.general
        }
    }
}*/

/*

public enum MailFolderPlatform<Microsoft : Sendable, Google : Sendable> : Sendable {
    case microsoft(Microsoft)
    case    google(Google)
}


extension MailFolderPlatform : Equatable where Microsoft : Equatable,  Google : Equatable {}
extension MailFolderPlatform : CodableValueType  where Microsoft : CodableValueType,  Google : CodableValueType {}


extension MailFolderPlatform: Identifiable where Microsoft : PlatformResourceProtocol & MailFolderResourceProtocol, Google : PlatformResourceProtocol & MailFolderResourceProtocol, Microsoft.ID == MicrosoftMailFolderID, Google.ID == GoogleMailFolderID {
    
}

extension MailFolderPlatform: ResourceProtocol where Microsoft : PlatformResourceProtocol & MailFolderResourceProtocol, Google : PlatformResourceProtocol & MailFolderResourceProtocol, Microsoft.ID == MicrosoftMailFolderID, Google.ID == GoogleMailFolderID {
    
}

extension MailFolderPlatform : MailFolderResourceProtocol where Microsoft : PlatformResourceProtocol & MailFolderResourceProtocol, Google : PlatformResourceProtocol & MailFolderResourceProtocol, Microsoft.ID == MicrosoftMailFolderID, Google.ID == GoogleMailFolderID {
*/
    
    /*
     public var name: String? {
         self[platform: \.name]
     }
     
     public var systemInfo: MailFolderSystemInfo? {
         self[platform: \.systemInfo]
     }
     
     /*public subscript<Value>(platform keyPath: KeyPath<any PlatformResourceProtocol & MailFolderProtocol, Value>) -> Value {
         switch self {
         case .microsoft(let platform): platform[keyPath: keyPath]
         case    .google(let platform): platform[keyPath: keyPath]
         }
     }*/
     */

/*
public enum MessagePlatformCase<Microsoft : PlatformResourceProtocol & MessageResourceProtocol, Google : PlatformResourceProtocol & MessageResourceProtocol> : MessageResourceProtocol where Microsoft.ID == MicrosoftMessageID, Google.ID == GoogleMessageID {
    
    case microsoft(Microsoft)
    case    google(Google)
    
    /*public var name: String? {
        switch self {
        case .microsoft(let platform): platform.name
        case .google(let platform): platform.name
        }
    }*/
    
    public var id: MessageID {
        switch self {
        case .microsoft(let platform): platform.id.general
        case .google(let platform): platform.id.general
        }
    }
    
   
}
*/
