/*
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
import JetEmailData

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

/*
@MainActor // for @MainActor AttributesStore
extension Message {
    
    var isBusy: Bool {
        get { AttributesStore[id].isBusy }
        set { AttributesStore[id].isBusy = newValue }
    }
    
    var isClassifying: Bool {
        get { AttributesStore[id].isClassifying }
        set { AttributesStore[id].isClassifying = newValue }
    }
    
    var movePlan: MailFolder? {
        get { AttributesStore[id].movePlan }
        set { AttributesStore[id].movePlan = newValue }
    }
    
    /*subscript<Value>(dynamicMember keyPath: KeyPath<Attributes, Value>) -> Value {
        AttributesStore[modelID][keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Attributes, Value>) -> Value {
        _read { yield AttributesStore[modelID][keyPath: keyPath] }
        _modify { yield &AttributesStore[modelID][keyPath: keyPath] }
    }*/
    
    @MainActor // for @MainActor AttributesStore
    @Observable
    class AttributesStore {
        var rawValue = [Message.ID: Message.Attributes]()
        
        static subscript(modelID: Message.ID) -> Message.Attributes {
            get {
                if let properties = shared.rawValue[modelID] { return properties }
                let properties = Message.Attributes()
                shared.rawValue[modelID] = properties
                return properties
            }
            set { shared.rawValue[modelID] = newValue }
        }
    }
    
    struct Attributes {
        var isBusy = false
        var isClassifying = false
        var movePlan: MailFolder? = nil
        var isMoveToVisible = false
    }
}*/
/*
struct Recipient {
    let email: String
    let name: String?
}
*/



/*
@globalActor
public actor BackgroundActor {
    public static let shared = BackgroundActor()
}*/
//
//  Google+Microsoft.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import JetEmailMicrosoft

/*public extension Message {

    var microsoft: MicrosoftMessage? {
        get {
            try? _graph?.decodeJSON(MicrosoftMessage.self)
        }
        set {
            guard let newValue else { return }
            let inner = newValue.inner
            // self.id           = newValue.id.general
            self.subject      = inner.subject?.nilIfEmpty
            
            self.createdDate  = inner.createdDateTime?     .date
            self.modifiedDate = inner.lastModifiedDateTime?.date
            self.receivedDate = inner.receivedDateTime?    .date
            self.sentDate     = inner.sentDateTime?        .date
            self.date         = receivedDate

            self.sender       = inner.sender?.emailAddress.map(\.rawValue)
            self.from         = inner.from?.emailAddress.map(\.rawValue)
            self.to           = inner.toRecipients? .compactMap(\.emailAddress?.rawValue).joined(separator: ", ").nilIfEmpty
            self.replyTo      = inner.replyTo?      .compactMap(\.emailAddress?.rawValue).joined(separator: ", ").nilIfEmpty
            self.cc           = inner.ccRecipients? .compactMap(\.emailAddress?.rawValue).joined(separator: ", ").nilIfEmpty
            self.bcc          = inner.bccRecipients?.compactMap(\.emailAddress?.rawValue).joined(separator: ", ").nilIfEmpty
            
            self.bodyPreview  = inner.bodyPreview?.nilIfEmpty
            
            if let body = inner.body, let contentType = body.contentType, let content = body.content {
                switch contentType {
                case .html: self.body = .init(text: content, html:content)
                case .text: self.body = .init(text: content, html: nil)
                }
            }
            
            if let raw = newValue.raw {
                self.raw = raw
            }

            self._graph = try? newValue.jsonString
        }
    }

}*/




//
//  Message+Google.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import JetEmailGoogle
/*
public extension Message {
    var google: GoogleMessage? {
        get {
            try? _google?.decodeJSON(GoogleMessage.self)
        }
    }
    
    func setGoogle(_ google: GoogleMessage) throws {
        // TODO: id
        let inner = google.inner
        if let internalDate = inner.internalDate       { self.date        = internalDate.milliSecondsTimeIntervalSince1970 }
        if let snippet      = inner.snippet            { self.bodyPreview = snippet                                        }
        if let raw          = inner.raw                { self.raw         = raw                                            }
        
        if let headers = inner.payload?.headers {
            /*
             header fields:
                subject
                from/sender/replyTo/to/cc/bcc
                messageID/inReplyTo/references
             */
            for header in headers {
                let name  = header.name
                let value = header.value
                
                switch name {
                    
                case HeaderFieldName.subject    : subject     = value
                    
                    // Originator Fields
                case HeaderFieldName.from       : from        = value
                case HeaderFieldName.sender     : sender      = value
                case HeaderFieldName.replyTo    : replyTo     = value
                    
                    // Destination Address Fields
                case HeaderFieldName.to         : to          = value
                case HeaderFieldName.cc         : cc          = value
                case HeaderFieldName.bcc        : bcc         = value
                case HeaderFieldName.deliveredTo: deliveredTo = value
                    
                default: break
                }
            }
        }
        
        if let body = try inner.payload?.messageBody {
            self.body = body
        }
        
        self._google = try? google.jsonString
    }
}

fileprivate enum MIMEType: String {
    case textPlain            = "text/plain"
    case textHtml             = "text/html"
    case multipartAlternative = "multipart/alternative"
    case multipartMixed       = "multipart/mixed"
}

fileprivate extension GoogleMessageInner.Part {
    var messageBody: Message.Body? { get throws {
        let html = try firstBodyContent(mimeType: .textHtml)
        let text = try firstBodyContent(mimeType: .textPlain)
        return .init(text: text, html: html)
    } }

    func firstBodyContent(mimeType: MIMEType) throws -> String? {
        if let bodyContent = try nonFileParts.firstPart(mimeType: mimeType)?.body?.data?.string { bodyContent }
        else if let bodyContent = try nonFileParts.firstMultipartPart?.parts?.compactMap({ try $0.firstBodyContent(mimeType: mimeType) }).first { bodyContent }
        else if let body = body { try body.data?.string }
        else { nil }
    }

    var nonFileParts: [GoogleMessageInner.Part] {
        parts?.filter { $0.filename?.nilIfEmpty == nil } ?? []
    }
}

fileprivate extension [GoogleMessageInner.Part] {
    func firstPart(mimeType: MIMEType) -> GoogleMessageInner.Part? {
        first(where: { $0.mimeType == mimeType.rawValue })
    }

    var firstMultipartPart: GoogleMessageInner.Part? {
        first { ([.multipartMixed, .multipartAlternative] as [MIMEType]).map(\.rawValue).map(Optional.init).contains($0.mimeType) }
    }
}

fileprivate enum HeaderFieldName {}

extension HeaderFieldName {
    static let subject     = "Subject"

    static let from        = "From"
    static let sender      = "Sender"
    static let replyTo     = "Reply-To"

    static let to          = "To"
    static let cc          = "Cc"
    static let bcc         = "Bcc"
    static let deliveredTo = "Delivered-To"

    static let date        = "Date"

    static let messageID   = "Message-ID"
    static let inReplyTo   = "In-Reply-To"
    static let references  = "References"
}
*/
//
//  Model.IDs.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import Foundation
import SwiftData
import JetEmailGoogle
import JetEmailMicrosoft
import JetEmailData

// MARK: - MailFolder <-> Google, Microsoft

/*public extension MailFolder {
    convenience init(resource: MailFolderResource, in account: Account) {
        checkBackgroundThread()
        self.init(
            resourceID: resource.id,
            name      : resource.name,
            systemInfo: resource.systemInfo,
            in        : account
        )
        
        switch resource {
        case .microsoft(let microsoft):
            self._graph = try? microsoft.jsonString
        case .google(let google):
            self._google = try? google.jsonString
        }
    }
    
    /*var microsoft: MicrosoftMailFolder? {
        get {
            try? _graph?.decodeJSON(MicrosoftMailFolder.self)
        }
        set {
            guard let microsoft = newValue else { return }
            // self.id   = microsoft.id.general
            self.name = microsoft.inner.displayName ?? ""
            
            self._graph   = try? microsoft.jsonString
            self._google = nil
        }
    }*/
    func update(resource: MailFolderResource?) {
        guard let resource else { return }
        self.resourceID  = resource.id
        self.name        = resource.name
        self.systemInfo  = resource.systemInfo

        switch resource {
        case .microsoft(let microsoft):
            self._graph = try? microsoft.jsonString
        case .google(let google):
            self._google = try? google.jsonString
        }
    }
}*/
//
//  ViewModel_.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import Foundation
import SwiftData



// MARK: - AppModel: Account-MailFolders API

/*extension Account {
 
    
    // Feature: Accounts - Remove Account
    fileprivate func removeAccountForGoogle() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        guard let graphContext = graphID, let modelContext else { return }
        
        do {
            appModel.willSignOutAccount.send(self)
            
            _ = try await graphContext.removeAccount()
            _ = try modelContext.removeAccount(self)
        } catch {
            appModel.logger.error("\(error)")
        }
    }
}*/

/*extension AppModel {
    // Feature: Accounts - Move Accounts
    /// Move accounts to change their orders in `ModelContext`.
    /// - Parameters:
    ///   - accounts: original accounts array.
    ///   - source: An index set representing the offsets of all elements that should be moved.
    ///   - destination: The offset of the element before which to insert the moved elements. destination must be in the closed range 0...count.
    func moveAccounts(_ accounts: [JetEmail.Account], fromOffsets source: IndexSet, toOffset destination: Int) {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            let modelContext = modelContainer.mainContext
            _ = try modelContext.moveAccounts(accounts, fromOffsets: source, toOffset: destination)
        } catch {
            logger.error("\(error)")
        }
    }
}*/





/*
extension Google.Client {
    
   
    /*var session: MicrosoftClient.Session {
        get async throws {
            try await account.session
        }
    }*/
}
*/


//
//
//  Model+GoogleAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/18/24.
//

// MARK: - Model <-> MSGraph
/*
extension Account {
    convenience init(google: Google.Account, orderIndex: Int) throws {
        self.init(
            modelID: google.modelID,
            username: google.username,
            orderIndex: orderIndex
        )
    }
    
    func update(google: Google.Account, deleteMark: Bool = false) {
        if self.modelID == google.modelID && self.username == google.username && self.deleteMark == deleteMark { return }
        self.deleteMark = deleteMark
        self.modelID  = google.modelID
        self.username = google.username
    }
    /*
    var googleAccount: Google.Account? {
        @available(macOS, unavailable, message: "Parse Use graph(_ client: MSGraph) instead.")
        @available(iOS, unavailable, message: "Parse Use graph(_ client: MSGraph) instead.")
        get {
            nil // should use graph(_:)
            // self.graph
        }
        set {
            guard let google = newValue else { return }
            self.modelID  = google.modelID
            self.username = google.username
        }
    }*/
}

*/

/*.onChange(of: account.hasAccount, initial: true) {
    Task {
        await account.updateState()
    }
}
.onChange(of: account.hasSession, initial: true) {
    Task {
        await account.updateState()
    }
}*/


/*// Feature: Accounts - Remove Account
/// Remove an account from `MSGraph.Context` and `ModelContext`.
/// - Parameter account: the account to remove.
@MainActor // for isAppModelBusy, item.isBusy
func removeAccountForGoogle(_ model: Account) async {
    await model.removeAccount()
}*/

/*// Feature: Accounts - Remove Account
/// Remove an account from `MSGraph.Context` and `ModelContext`.
/// - Parameter account: the account to remove.
@MainActor // for isAppModelBusy, item.isBusy
func removeAccount(_ model: Account) async {
    await AppItemModel(context: self, item: model).delete()
}*/



/*func loadMailFolders(account accountPersistentID: Account.PersistentID) async throws {
    BackgroundModelActor.assertIsolated()
    
    let account = self[accountPersistentID]!
    
    switch try await account.refreshedIfExpiredSession {
    case .microsoft(let session):
        let microsoftRoot = try await session.getRootMailFolder()
        let root = try modelContext.setRootMailFolder(microsoft: microsoftRoot, in: account.persistentID)
        
        var queue: [MailFolder] = [root]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            
            let microsofts = try await session.getChildFolders(microsoftID: .init(string: current.platformID))
            let children = try modelContext.setChildrenMailFolders(microsofts: microsofts, parentID: current.persistentID, in: account.persistentID)
            
            queue.append(contentsOf: children)
        }
    case .google(let session):
        let googles = try await session.getMailFolders()
        try modelContext._setMailFolders(googles: googles, in: account)
    default:
        return
    }
}*/

/// Set all messages from graphContext to `ModelContainer`.
/// - Parameters:
///   - elements: Messages from  `MSGraph.Context`.
///   - mailFolder: mai
/// - Returns: Messages from `ModelContainer`.

//
//  Google+Account.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/19/24.
//

/*

extension Google.Client {
    
    func addAccount() async throws -> Google.Session {
        try await sessionStore.signInSession()
    }
    
    var accounts: [Google.Account] {
        get async throws { try await sessionStore.sessions.map(\.account) }
    }
    
    func deleteAccount(id: Google.ID) async throws -> Google.Account? {
        try await sessionStore.deleteSession(id: id)?.account
    }
    
    func account(id: Google.ID) async throws -> Google.Account {
        guard let account = try await sessionStore.session(id: id)?.account else { throw Google.AuthError.noAccountFound }
        return account
    }
    
    /*func refreshAccount(_ account: Google.Account) async throws -> Google.Session? {
        try await sessionStore.refreshSession(account: account)
    }*/
    
    func hasAccount(id: Google.ID) async -> Bool {
        (try? await account(id: id)) != nil
    }
    
    func hasSession(id: Google.ID) async throws -> Bool {
        (try await sessionStore.session(id: id)) != nil
    }
}


extension Google.Client {
    /*func signInSession() async throws -> Google.SessionKeychainStore.Item {
        let gtmSession = try await _gtmSignIn()
        guard let stringID = gtmSession.userID, let username = gtmSession.userEmail else { throw Google.AuthError.accountNoIDOrUsername }
        let id = Google.ID(string: stringID)
        // add session
        
        // try to find existed session
        if let session = try await session(id: id) {
            // if existed update the gtmSession
            session.gtmSession = gtmSession // trigger update session
            return session
        }
        
        // try to add to keychain
        let item = try await SessionKeychainStore..addItem(id: id, username: username, gtm: gtmSession)
        
        // find duplicated existed keychain item add fail
        guard let item else { throw Google.AuthError.sessionStoreAddFail  }
        
        // add success
        return item
        // return try _storeSession(item: item)
    }*/
}

extension Google {
    
    actor SessionStore {
        unowned let client: Google.Client
        init(client: Google.Client) { self.client = client }
        
        private var _rawValue = [Google.ID: Google.Session]()

        func signInSession() async throws -> Google.Session {
            let gtmSession = try await client._gtmSignIn()
            guard let stringID = gtmSession.userID, let username = gtmSession.userEmail else { throw Google.AuthError.accountNoIDOrUsername }
            let id = Google.ID(string: stringID)
            // add session
            
            // try to find existed session
            if let session = try await session(id: id) {
                // if existed update the gtmSession
                session.gtmSession = gtmSession // trigger update session
                return session
            }
            
            // try to add to keychain
            let item = try await SessionKeychainStore..addItem(id: id, username: username, gtm: gtmSession)
            
            // find duplicated existed keychain item add fail
            guard let item else { throw Google.AuthError.sessionStoreAddFail  }
            
            // add success
            return try _storeSession(item: item)
        }
        
        var sessions: [Google.Session] {
            get async throws {
                // access from keychain
                let items = try await SessionKeychainStore..items()
                
                // map keychain items to existed or creating sessions
                let sessions = try items.map { item throws in
                    if let storeAccount = _rawValue[item.id] {
                        // storeAccount.gtmSession
                        assert(storeAccount.keychain === item.keychain)
                        return storeAccount
                    } else {
                        return try _storeSession(item: item)
                    }
                }
                
                // removing sessions not existed in keychain
                let existedIDs = sessions.map(\.id)
                let removingIDs = _rawValue.keys.filter { !existedIDs.contains($0) }
                for id in removingIDs {
                    _rawValue.removeValue(forKey: id)
                }
                return sessions
            }
        }
        
        fileprivate func deleteSession(id: Google.ID) async throws -> Google.Session? {
            if let item = try await SessionKeychainStore..item(id: id) {
                _ = try await SessionKeychainStore..deleteItem(item)
            }
            
            if let storedSession = _rawValue[id] {
                _rawValue.removeValue(forKey: id)
                return storedSession
            }
            return nil
        }
        
        fileprivate func session(id: Google.ID) async throws -> Google.Session? {
            let item = try await SessionKeychainStore..item(id: id)
            
            guard let item else {
                // Not found item in keychain
                _rawValue.removeValue(forKey: id)
                return nil
            }
            
            // Found item in keychain, and session store
            if let stored = _rawValue[id] {
                // storeAccount.gtm == item.gtm
                assert(stored.keychain === item.keychain)
                return stored
            }
            
            // Found item in keychain, but not session store
            return try _storeSession(item: item)
        }
        

        
        /*private func refreshSession(account: Google.Account) async throws -> Google.Session? {
                                
         }*/
        
        func updateSession(_ session: Session) async throws -> Session {
            let id = session.id
            
            // update keychain
            let item = try await SessionKeychainStore..updateItem(session.keychainItem)
            
            // varify sessionStore
            if let storedSession = _rawValue[id] {
                assert(storedSession === self)
                return storedSession
            } else {
                return try _storeSession(item: item)
            }
        }
        
        /*fileprivate func refreshedSession(account: Microsoft.Account) async throws -> Session {
            if let session = try await session(id: account.id), !session.isExpired { return session }
            return try await refreshSession(account)
        }*/
        
        private func refreshSession(_ session: Session) async throws -> Session {
            _ = try await session._gtmRefresh() // will trgger update session
            return session
        }
        
        private func _storeSession(item: SessionKeychainStore.Item) throws -> Google.Session {
            guard let username = item.gtm.userEmail else { throw Google.AuthError.accountNoIDOrUsername }
            let id = item.id
            let session = try Google.Session(sessionStore: client.sessionStore, id: id, username: username, gtmSession: item.gtm, keychain: item.keychain)
            _rawValue[id] = session
            return session
        }
    }
}
/*

*/
/*
extension Google.Account {
    init(session: Google.Session) {
        self.init(client: session.sessionStore.client, id: session.id, username: session.username)
    }
}*/
*/

//
//  MSALApp.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/31/24.
//
/*

extension Microsoft.Client {
    
    /*func addAccount() async throws -> Microsoft.Session {
        try await sessionStore.signInSession()
    }*/
    
    var accounts: [Microsoft.Account] {
        get throws {
            print("Microsoft.Client.accounts")
            
            // access MSALAcount from keychain
            let msalAccounts = try _msalClient.allAccounts()
            
            // map MSALAccount to Microsoft.Account
            return try msalAccounts.map { try $0.microsoftAccount(client: self) }
        }
    }
    
    /*func deleteAccount(id: Microsoft.ID) async throws -> Microsoft.Account {
        print("Microsoft.Client.deleteAccount")
        let account = try await account(id: id)
        try _msalClient.remove(account.msalAccount)
        return account
        /*
         try await sessionStore.deleteSession(account: account)?.account ?? account
         let parameters = MSALSignoutParameters(webviewParameters: webViewParameters)
         let result = try await _msalClient.signout(with: msalAccount, signoutParameters: parameters)
         return result
         */
    }
    

    func hasAccount(id: Microsoft.ID) async -> Bool {
        (try? await account(id: id)) != nil
    }
    
    func hasSession(id: Microsoft.ID) async throws -> Bool {
        (try await sessionStore.session(id: id)) != nil
    }*/
}

extension Microsoft.Account {
    
    var refreshedSession: Microsoft.Session { get async throws {
        try await client.sessionStore.refreshedSession(account: self)
    } }
    
    var authorizationHeader: String { get async throws {
        try await refreshedSession.msalSession.authorizationHeader
    } }
    
    /*func refreshAccount(_ account: Microsoft.Account) async throws -> Microsoft.Session {
        try await sessionStore.refreshSession(account)
    }*/
}



/*extension Microsoft.Account {
    var session: Microsoft.Session? {
        get async throws { try await client.sessionStore.session(id: id) }
    }*/
    
    /*var refreshedSession: Microsoft.Session {
        get async throws {
            if let session = try await session, !session.isExpired { return session }
            return try await client.refreshAccount(self)
        }
    }
}*/


extension Microsoft {
    actor SessionStore {
        unowned let client: Microsoft.Client
        init(client: Microsoft.Client) { self.client = client }
        
        private var _rawValue = [Microsoft.ID: Session]()

        fileprivate func signInSession() async throws -> Session {
            
            // MSALSession get from sign-in process
            let msalSession = try await client._msalSignin()
            let id = try msalSession.id
            
            // try to find existed session
            if let session = try await session(id: id) {
                // if exists: update the msalSession
                session.msalSession = msalSession
                return session
            }
            
            return try _storeSession(msalSession: msalSession)
        }
        
        fileprivate func refreshedSession(account: Microsoft.Account) async throws -> Session {
            if let session = try await session(id: account.id), !session.isExpired { return session }
            return try await refreshSession(account)
        }

        
        fileprivate func session(id: Microsoft.ID) async throws -> Session? {
            let msalAccount = try client._msalClient.allAccounts().first { $0.identifier == id.string }
            
            guard let msalAccount else {
                // Not found item in keychain
                _rawValue.removeValue(forKey: id)
                return nil
            }
            
            // Found item in keychain, and session store
            if let stored = _rawValue[id] { return stored }
            
            // Found item in keychain, but not session store
            let msalSession = try await client._msalRefresh(msalAccount: msalAccount)
            return try _storeSession(msalSession: msalSession)
        }
        
        private func refreshSession(_ account: Microsoft.Account) async throws -> Session {
            let msalSession = try await client._msalRefresh(msalAccount: account.msalAccount)
            
            // try to find existed session
            if let session = try await session(id: account.id) {
                // if exists: update the msalSession
                session.msalSession = msalSession
                return session
            }
            
            let session = try _storeSession(msalSession: msalSession)
            return session
        }
        
        /*var sessions: [Session] { // session in memory
            /*get async throws {
                // access MSALAccounts from keychain
                let msalAccounts = try client.msalClient.allAccounts()
                

                // map account items to existed or creating sessions
                let sessions = try msalAccounts.map { msalAccount throws in
                    guard let stringID = msalAccount.identifier else { throw Microsoft.AuthError.accountNoIDOrUsername }
                    let id = Microsoft.ID(string: stringID)
                    if let stored = _rawValue[id] {
                        // storeAccount.gtmSession
                        assert(stored.msalSession.account == msalAccount)
                        return stored
                    } else {
                        // access MSALSessions from keychain
                        let msalSessions = msalAccounts.map { client._msalRefreshedRequest(msalAccount: $0) }
                        
                        return try _createAndStoreSession(item: item)
                    }
                }
                
                // removing sessions not existed in keychain
                let existedIDs = sessions.map(\.id)
                let removingIDs = _rawValue.keys.filter { !existedIDs.contains($0) }
                for id in removingIDs {
                    _rawValue.removeValue(forKey: id)
                }
                return sessions
                
                return try items.map { try Microsoft.Account(client: self, msal: $0) }
                _msalRefreshedRequest
                Array(_rawValue.values)
            }*/
            return []
        }*/
        

        

        
        /*func deleteSession(account: Microsoft.Account) async throws -> Session? {
            let id = account.id
            let result = try await client._msalSignoutRequest(msalAccount: account.msalAccount)
            
            if let storedSession = _rawValue[id] {
                _rawValue.removeValue(forKey: id)
                return storedSession
            }
            return nil
        }
        
        func updateSession(_ session: Session) -> Session? {
            _rawValue[session.id] = session
            return session
        }*/
        
        private func _storeSession(msalSession: MSALSession) throws -> Microsoft.Session {
            let id = try msalSession.id
            guard let username = msalSession..username else { throw Microsoft.AuthError.accountNoIDOrUsername }
            
            let session = Microsoft.Session(sessionStore: self, id: id, username: username, msalSession: msalSession)
            _rawValue[id] = session
            return session
        }
    }
}


extension Microsoft.Session {
    fileprivate var isExpired: Bool {
        guard let expiresOn = msalSession.expiresOn else { return false }
        return Date.now >= expiresOn
    }
}

*/

//
//  MSAL.Account.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

// Account = Client + Account.ID

/*
extension Microsoft {
    struct Account {
        let client  : Client

        let id         : ID
        let username   : String
        let msalAccount: MSALAccount
        
        fileprivate init(client: Client, id: ID, username: String, msalAccount: MSALAccount) {
            self.client = client
            self.id = id
            self.username = username
            self.msalAccount = msalAccount
        }
    }
}
*/

// Microsoft.Session -> Miccrosoft.Account

/*extension Microsoft.Session {
    /*func account(client: Microsoft.Client) -> Microsoft.Account {
        .init(client: client, id: id, username: username, msalAccount: msalSession.account)
    }*/
}

// MSALAccount -> Microsoft.Account

extension MSALAccount {
    func microsoftAccount(client: Microsoft.Client) throws -> Microsoft.Account {
        guard let id = identifier, let username = username else { throw Microsoft.AuthError.accountNoIDOrUsername }
        return Microsoft.Account(client: client, id: .init(string: id), username: username, msalAccount: self)
    }
}*/


//
//  Google.Account.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/20/24.
//

// Account = Client + Account.ID
/*
extension Google {
    struct Account {
        let client  : Client

        let id      : ID
        let username: String
        
        fileprivate init(client: Client, id: ID, username: String) {
            self.client = client
            self.id = id
            self.username = username
        }

    }
}*/
/*
extension Google.Session {
    var account: Google.Account {
        .init(client: sessionStore.client, id: id, username: username)
    }
}
*/
//
//  Google+Message+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

/*set {
    guard let google = newValue else { return }
    
    
    
    self.modelID      = google.modelID
    self.subject      = headerValue(name: "Subject")
    
    /*self.createdDate  = graph.createdDateTime?     .date
    self.modifiedDate = graph.lastModifiedDateTime?.date*/
    //self.receivedDate = headerValue(name: "Date")?.rfc2822
    self.receivedDate = google.internalDate?.milliSecondsTimeIntervalSince1970
    self.date         = self.receivedDate
    //self.sentDate     = headerValue(name: "Date")?.rfc2822
    
    //self.sender       = graph.sender?.emailAddress
    self.from         = headerValue(name: "From")
    //self.to           = graph.toRecipients? .compactMap(\.emailAddress).nilIfEmpty
    //self.replyTo      = graph.replyTo?      .compactMap(\.emailAddress).nilIfEmpty
    ////self.cc           = graph.ccRecipients? .compactMap(\.emailAddress).nilIfEmpty
    // self.bcc          = graph.bccRecipients?.compactMap(\.emailAddress).nilIfEmpty
    
    self.bodyPreview  = google.snippet
    
    
    let firstPart = google.payload?.parts?.first { $0.partID == "1" }
    let firstPartMIME = firstPart?.mimeType
    let firstPartString = try? firstPart?.body?.data?.string
    print(firstPartMIME ?? "nil", firstPartString ?? "nil")
    
    if firstPartMIME == "text/html" {
        self.body  =  .init(content: firstPartString, contentType: .html)
    } else if firstPartMIME == "text/plain" {
        self.body  =  .init(content: firstPartString, contentType: .text)
    } else if firstPartMIME == nil {
        () // self.body  =
    } else {
        fatalError()
    }
    // print(#function, google.payload?.body?.data ?? "nil")
    /*self.uniqueBody   = graph.uniqueBody*/

    self._google = try? google.jsonString
}*/

/*let firstPart = google.payload?.parts?.first { $0.partID == "1" }
let firstPartMIME = firstPart?.mimeType
let firstPartString = try? firstPart?.body?.data?.string
print(firstPartMIME ?? "nil", firstPartString ?? "nil")

if firstPartMIME == "text/html" {
    self.body  =  .init(content: firstPartString, contentType: .html)
} else if firstPartMIME == "text/plain" {
    self.body  =  .init(content: firstPartString, contentType: .text)
} else if firstPartMIME == nil {
    () // self.body  =
} else {
    fatalError()
}*/

/*
 MessageBody
   - text : ""
   - html : nil
   - attachment : nil
 */


/*
    attachments
 */
/*let attachmentsIds = payload.parts?.compactMap { $0.body?.attachmentId } ?? []
var attachments = google.parseAttachments()
if body.hasNoContent, let bodyPartAttachment = google.parseBodyPartAttachment() {
    attachments.append(bodyPartAttachment)
}*/

//self.body = body
// self.size = google.sizeEstimate.flatMap(Int.init)
// self.label = labels
// self.attachmentIds = attachmentIds
// self.attachments = attachments
//self.threadID = google.threadId
//self.rfcu22MegId = rfc822MsgId
//self.raw = google.raw

/*self.init(
    identifier: Identifier(stringId: identifier),
    // convert miliseconds to seconds
    date: Date(timeIntervalSince1970: internalDate / 1000),
    sender: sender,
    subject: subject,
    size: gmailMessage.sizeEstimate.flatMap(Int.init),
    labels: labels,
    attachmentIds: attachmentsIds,
    body: body,
    attachments: attachments,
    threadId: gmailMessage.threadId,
    rfc822MsgId: rfc822MsgId,
    raw: gmailMessage.raw,
    to: to,
    cc: cc,
    bcc: bcc,
    replyTo: replyTo,
    inReplyTo: inReplyTo
)*/




// Gmail string extension identifier




/*
fileprivate extension Google.Message.Full {
var attachmentParts: [Google.Message.Part] {
payload?.parts?.filter { !$0.filename.isEmptyOrNil } ?? []
}

func parseBodyAttachment() -> MessageAttachment? {
guard let part = payload?.body,
      let attachmentId = part.attachmentId
else { return nil }

return MessageAttachment(
    id: attachmentId,
    name: "body",
    estimatedSize: part.size,
    mimeType: "text/plain"
)
}

func parseAttachments() -> [MessageAttachment] {
attachmentParts.compactMap { (part: Google.Message.Part) -> MessageAttachment? in
    guard let body = part.body, let id = body.attachmentId, let name = part.filename
    else { return nil }

    return MessageAttachment(
        id: id,
        name: name,
        estimatedSize: body.size,
        mimeType: part.mimeType,
        data: body.data
    )
}
}

func parseBodyPartAttachment() -> MessageAttachment? {
guard let body = payload?.parts?.first(where: { $0.mimeType == "text/plain" })?.body,
      let attachmentId = body.attachmentId
else { return nil }

return MessageAttachment(
    id: attachmentId,
    name: "encrypted.asc",
    estimatedSize: body.size,
    mimeType: "text/plain"
)
}
}

fileprivate extension MessageBody {
var hasNoContent: Bool {
text.isEmpty && attachment == nil
}
}

fileprivate extension Optional where Wrapped: Collection {
var isEmptyOrNil: Bool {
 self?.isEmpty ?? true
}
}


struct MessageAttachment: Equatable, Hashable, FileType {
let id           : String
let name         : String
let estimatedSize: Int?
let mimeType     : String?

var treatAs      : String?
var data         : Data?
}


protocol FileType {
var name         : String  { get }
var estimatedSize: Int?    { get }
var mimeType     : String? { get }

var treatAs      : String? { get set }
var data         : Data?   { get set }
}

*/
/*
 enum HeaderFieldValue {
     
     // mailbox-list
     struct From: RawRepresentable {
         let rawValue: String
     }
     
     // mailbox
     struct Sender: RawRepresentable {
         let rawValue: String
     }
     
     // address-list
     struct ReplyTo: RawRepresentable {
         let rawValue: String
     }
     
     // address-list
     struct To: RawRepresentable {
         let rawValue: String
     }
     
     // address-list
     struct CC: RawRepresentable {
         let rawValue: String
     }
     
     // address-list / CFWS
     struct BCC: RawRepresentable {
         let rawValue: String
     }
     
     // mailSpec
     struct DeliveredTo: RawRepresentable {
         let rawValue: String
     }
 }

 extension String {
     var headerValueFrom       : HeaderFieldValue.From        { .init(rawValue: self) }
     var headerValueSender     : HeaderFieldValue.Sender      { .init(rawValue: self) }
     var headerValueReplyTo    : HeaderFieldValue.ReplyTo     { .init(rawValue: self) }
     var headerValueTo         : HeaderFieldValue.To          { .init(rawValue: self) }
     var headerValueCC         : HeaderFieldValue.CC          { .init(rawValue: self) }
     var headerValueBCC        : HeaderFieldValue.BCC         { .init(rawValue: self) }
     var headerValueDeliveredTo: HeaderFieldValue.DeliveredTo { .init(rawValue: self) }
 }

 */

// MARK: - AppModel: Account Status
/*
extension AppItemModel<Account> {
    
    var _hasAccount: Bool {
        get async {
            switch item.modelID.enumValue {
            case .microsoft(let id):
                (try? await microsoftClient.account(id: id)) != nil
            case .google(let id):
                (try? await    googleClient.account(id: id)) != nil
            }
        }
    }
    
    var _hasSession: Bool {
        get async throws {
            switch item.modelID.enumValue {
            case .microsoft(let id):
                try await microsoftClient.hasSession(id: id)
            case .google(let id):
                try await googleClient.hasSession(id: id)
            }
        }
    }*/
    
    /*func updateState() async {
        do {
            print("AppItemModel.updateState")
            item.hasAccount = await _hasAccount
            item.hasSession = try await _hasSession
            print(item.state)
        } catch {
            logger.debug("\(error)")
        }
    }
}
     */








/*fileprivate extension AppModel {
    func graphContext(graphID: MicrosoftAPI.Account.ID) async throws -> CombineContext<MicrosoftAPI, MicrosoftAPI.Account> {
        let graphClient = try await MicrosoftAPI.
        return .init(context: graphClient, item: try graphClient.account(graphID: graphID))
    }
}*/



/*func syncFolderTree() async throws {
    guard !self.isLoadingFolderTree else { return }
    self.isLoadingFolderTree = true
    defer { self.isLoadingFolderTree = false }
    
    
    let root  = TargetFolderPaths..root
    let rootFolder = try await self.mailFoldersRequest.getMailFolder(wellKnownFolderName: .msgFolderRoot)
    
    var queue: [(TreeNode<FolderName>, MailFolder)] = [(root, rootFolder)]
    while !queue.isEmpty {
        let (parent, parentFolder) = queue.removeFirst()
        print("<checking: \(parentFolder.displayName)>")
        for child in parent.children {
            let childName = child.element
            var childFolder: MailFolder
            
            switch childName {
            case .special(let specialName):
                childFolder = try await self.mailFoldersRequest.getMailFolder(wellKnownFolderName: specialName.graph)
                // verified existed
                assert(childFolder.parentFolderId == parentFolder.id)
                print("    <exists: \(childFolder.displayName)/>")
            case .display(let displayName):
                let childFolders = try await self.mailFoldersRequest.getChildFolders(id: parentFolder.id)
                if let mailFolder = childFolders.first(where: { $0.displayName == displayName }) {
                    childFolder = mailFolder
                } else {
                    childFolder = try await self.mailFoldersRequest.createChildFolder(id: parentFolder.id, displayName: displayName)
                }
                print("    <created: \(childFolder.displayName)/>")
            }
            queue.append((child, childFolder))
        }
        print("</checking: \(parentFolder.displayName)>")
    }
    
    // var queue: [TreeNode<String>] = [root]
            
    /*while !queue.isEmpty {
        
    }*/
}*/




 
/*
extension Address {
    init(rawValue: String) {
        //guard let address = MCOAddress(nonEncodedRFC822String: string) else {
        /*let b = try! MimeEmailParser().parseAddressList(addresses: rawValue)
            self.name = nil
            self.email = string
            return
         //}*/
        self.name = ""  //address.displayName
        self.email = "" //address.mailbox
    }
}*/
/*
extension Microsoft.EmailAddress {
    var recipient: Address {
        Address(email: address!, name: name)
    }
}
 
 extension Microsoft.EmailAddress {
     var mailbox: MailBox {
         .init(addrSpec: address, displayName: name)
     }
 }
*/



// Microsoft.MSALAccount -> MSALSession
/*extension Microsoft.MSALAccount {
    func msalSession(client: Microsoft.Client) async throws -> Microsoft.MSALSession {
        try await client._msalRefresh(msalAccount: self)
    }
}*/
/*
extension Microsoft.ID {
    var refreshSession: Microsoft.MSALSession {
        get async throws {
            let client = try await Microsoft.Client.
            return try await client._msalClient.account(forIdentifier: string).refreshMSALSession
        }
    }
}*/


    
    /*var lazyMSALSession: Microsoft.MSALSession {
        get async throws {
            if let session = try Microsoft.MSALSession[self] { return session }
            return  try await refreshMSALSession
        }
    }*/

/*
extension Microsoft.MSALSession {
    var refresh: Microsoft.MSALSession {
        get async throws {
            try await account._msalRefreshMSALSession
        }
    }
}
*/

/*extension Microsoft.Session {
    var refresh: Microsoft.Session { get async throws {
        _msalSession = try await _msalSession.refresh
        return self
    } }
}*/

/*
 //
 //  GoogleAPI.Account.swift
 //  JetEmail
 //
 //  Created by Cao, Jiannan on 2/17/24.
 //

 import Security
 import JetEmailGoogle

 /*
 Google.Session = Google.Account + GTMAuthSession
 */
 /*
 extension Google {
     class Session: SessionProtocol {
                 let  accountID         : Google.ID
                 let  username   : String
                 let  gtmSession : GTMSession
         // { didSet { if gtmSession != oldValue { Task { _ = try await updateKeychainItem() } } } }
           
                 let keychainItem: SecKeychainItem
          
         
         init(accountID: Google.ID, username: String, gtmSession: GTMSession, keychainItem: SecKeychainItem) {
             self.accountID    = accountID
             self.username     = username
             self.gtmSession   = gtmSession
             self.keychainItem = keychainItem
             super.init()
             
             gtmSession.delegate = self
             gtmSession.authState.stateChangeDelegate = self
             gtmSession.authState.errorDelegate = self
         }
         
         func additionalTokenRefreshParameters(forAuthSession gtmSession: GTMSession) -> [String : String]? {
             return nil
         }
         
         func updateError(forAuthSession gtmSession: GTMSession, originalError: Error, completion: @escaping (Error?) -> Void) {
             completion(originalError)
         }
         
         func didChange(_ state: OpenIDState) {
             Task { _ = try await updateKeychainItem() }
         }
         
         func authState(_ state: OpenIDState, didEncounterAuthorizationError error: Error) {
             print(#function, state)
         }
         
         func authState(_ state: OpenIDState, didEncounterTransientError error: Error) {
             print(#function, state)
         }
         
         fileprivate func updateKeychainItem() async throws {
             _ = try await Google.Client.sared.keychain.updateItem(item)
         }
         
         func refresh() async throws {
             _ = try await gtmSession.refresh()
         }
     }
 }




 // Google.GTMSession -> Google.SessionKeychain.Item
 extension Google.GTMSession {
     func insertTo(keychain: Google.Keychain) async throws -> Google.Keychain.SessionItem {
         try await keychain.insertItem(gtmSession: self)
     }
     
     
 }


 extension Google.Keychain.SessionItem {
     
     func deleteFrom(keychain: Google.Keychain) async throws -> Google.Keychain.SessionItem {
         try await keychain.deleteItem(self)
     }
 }
*/*/


/*
protocol AppStorage {
    func setSessions(_ sessions: [Session]) async throws -> [Account.PersistentID]
    nonisolated var modelContainer: ModelContainer { get }
}

extension AppStorage {
    public var context: ModelContext { fatalError() }
    
    
}*/

extension ModelStore {
    
    /*func moveAccounts(_ accounts: [Account], fromOffsets source: IndexSet, toOffset destination: Int) throws -> [Account] {
        try modelContext.moveAccounts(accounts, fromOffsets: source, toOffset: destination)
    }*/

    /*func setRootMailFolder(microsoft: Microsoft.MailFolder, in accountID: Account.ID) async throws -> MailFolder.ID {
        try await modelContext.setRootMailFolder(microsoft: microsoft, in: accountID)
    }
    
    func setChildrenMailFolders(microsofts: [Microsoft.MailFolder], parentID: MailFolder.ID, in accountID: Account.ID) async throws -> [MailFolder.ID] {
        try await modelContext.setChildrenMailFolders(microsofts: microsofts, parentID: parentID, in: accountID)
    }
    
    func setMessages(microsofts: [Microsoft.Message], in mailFolderID: MailFolder.ID) async throws -> [Message.ID] {
        try await modelContext.setMessages(microsofts: microsofts, in: mailFolderID)
    }
    
    func setMessage(microsoft: Microsoft.Message, to messageID: Message.ID) async throws -> Message.ID {
        try await modelContext.setMessage(microsoft: microsoft, to: messageID)
    }*/
    
}

/*
extension ModelContext {
    func _fetchAccount(modelID: Account.ID) throws -> Account? {
        let rawID = modelID.rawValue
        return try fetch(.init(predicate: #Predicate<Account> { $0.rawID == rawID })).first
    }
    
    func _fetchMailFolder(modelID: MailFolder.ID) throws -> MailFolder? {
        let rawID = modelID.rawValue
        return try fetch(.init(predicate: #Predicate<MailFolder> { $0.rawID == rawID })).first
    }
    
    func _fetchMessage(modelID: Message.ID) throws -> Message? {
        let rawID = modelID.rawValue
        return try fetch(.init(predicate: #Predicate<Message> { $0.rawID == rawID })).first
    }
}

*/
// MA




/*func _insertMailFolder(google: Google.MailFolder, parent: MailFolder, in account: Account) throws -> MailFolder {
    // check account.root
    guard account.root != nil else { throw TreeError.accountDoNotHaveRootFolder }
    
    // insert before check relationship
    let folderID = try _insertMailFolder(google: google, in: account)
    let folder = try _fetchMailFolder(modelID: folderID.modelID)!

    // check parent and folder account
    guard parent.account == account else { throw TreeError.parentMailFolderNotInThisAccount }
    guard folder.account == account else { throw TreeError.mailFolderNotInThisAccount }
    
    // check node.parent
    if folder.parent != nil && folder.parent != parent { throw TreeError.mailFolderAlreadyHaveParent }
    folder.parent = parent
    
    // check node.children
    // guard node.children.isEmpty else { throw TreeError.alreadyHaveChild }
    
    return folder
}*/

/*func setAccounts(microsofts: [Microsoft.Account]) async throws -> [Account.PersistentID] {
 MainActor.assertIsolated()
 do {
 // insert
 var inserts: [Account] = []
 for microsoft in microsofts {
 try inserts.append(_insertAccount(microsoft: microsoft))
 }
 
 /* do not delete, just keep it to show status
  // delete*/
 let otherAccounts = try _fetchAccountNotIn(inserts, in: .microsoft)
 // update state
 
 await Task { @MainActor [inserts, otherAccounts]  in
 //inserts.forEach { $0.platformState = .hasAccount(nil) }
 //otherAccounts.forEach { $0.platformState = .noAccount }
 }.value
 
 
 print("modelContext.save")
 try save()
 return inserts.map(\.persistentID)
 } catch {
 rollback()
 throw error
 }
 }*/

/*func setAccounts(googles: [Google.Account]) throws -> [Account.PersistentID] {
 MainActor.assertIsolated()
 do {
 // insert
 var inserts: [Account] = []
 for google in googles {
 try inserts.append(_insertAccount(google: google))
 }
 
 /* do not delete, just keep it to show status
  // delete
  let removing = try _fetchAccountNotIn(inserts, in: .google)
  try removing.forEach { _ = try _deleteAccount($0) }
  */
 
 try save()
 return inserts.map(\.persistentID)
 } catch {
 rollback()
 throw error
 }
 }*/
/*func setChildrenMailFolders(googles: [GoogleMailFolder], parent parentID: MailFolder.ID, in accountID: Account.ID) throws -> [ MailFolder.ID] {
    let parent = try self[parentID]!
    let account = try self[accountID]!
    do {
        var inserts: [MailFolder] = []
        for google in googles {
            try inserts.append(modelContext._insertMailFolder(google: google, parent: parent, in: account))
        }
        
        // delete
        let removings = try modelContext._fetchMailFolderNotIn(inserts, in: parent)
        try removings.forEach { _ = try modelContext._deleteMailFolder($0) }
        
        try modelContext.save()
        return inserts.map { ($0.id) }
    } catch {
        modelContext.rollback()
        throw error
    }
}*/

    
/*func insertMailFolder(platform: MicrosoftMailFolder, in accountID: Account.ID) throws -> MailFolderID {
    let account = try self[accountID]!
    do {
        let root = try modelContext._insertMailFolder(microsoft: microsoft, in: account)
        try modelContext.save()
        return root.id
    } catch {
        modelContext.rollback()
        throw error
    }
}

func setRootMailFolder(google: GoogleMailFolder, in accountID: Account.ID) throws -> MailFolderID {
    let account = try self[accountID]!
    do {
        if let root = account.root { return root.id }
        let root = try modelContext._insertMailFolder(google: google, in: account)
        account.root = root
        try modelContext.save()
        return root.id
    } catch {
        print(error)
        modelContext.rollback()
        throw error
    }
}*/

/*func setMessagesInsertPart(googles messages: [GoogleMessage], in mailFolderID: MailFolderID) throws -> [MessageID] {
    checkBackgroundThread()
    let mailFolder = try self[mailFolderID]!
    do {
        // insert
        var inserts: [Message] = []
        for message in messages {
            try inserts.append(modelContext._insertMessage(google: message, in: mailFolder))
        }
        try modelContext.save()
        return inserts.map(\.resourceID)
    } catch {
        modelContext.rollback()
        throw error
    }
}*/



//let batchSize = 1
/*func setMessages(microsofts messages: [MicrosoftMessage], in mailFolderID: MailFolderID) throws -> [Message.PersistentID] {
    checkBackgroundThread()
    let mailFolder = try self[mailFolderID]!
    do {
        
        // insert
        var inserts: [Message] = []
        for message in messages {
            try inserts.append(modelContext._insertMessage(microsoft: message, in: mailFolder))
        }
        
        // delete
        let removings = try modelContext._fetchMessageNotIn(inserts, in: mailFolder)
        try removings.forEach { _ = try modelContext._deleteMessage($0) }
        
        try modelContext.save()
        return inserts.map(\.persistentID)
    } catch {
        modelContext.rollback()
        throw error
    }
}*/
/*
    SwiftData.ModelContext:
    insert()
 
    if insert a new instance has a value of an unique property that is a duplicated with an old instance in the container:
        before saving, it has a temperary persistantID.
        after manual-saving or auto-saving (which is unkown time),
            the old instance is updated to the new instance's properties.
            the new instance is deleted.
    *It is unsafe to keep the new instance and access its properties. Developer should refetch to get the right instance after saving.*
 */


extension ModelStore {
    
    
    
    
    /*func addAccount(microsoft: Microsoft.Account) throws -> Account.PersistentID {
     BackgroundModelActor.assertIsolated()
     do {
     // insert
     let account = try modelContext._insertAccount(microsoft: microsoft)
     try modelContext.save()
     return account.persistentID
     } catch {
     modelContext.rollback()
     throw error
     }
     }
     
     func addAccount(google: Google.Account) throws -> Account.PersistentID {
     BackgroundModelActor.assertIsolated()
     do {
     // insert
     let account = try modelContext._insertAccount(google: google)
     try modelContext.save()
     return account.persistentID
     } catch {
     modelContext.rollback()
     throw error
     }
     }*/
    
    
    
    
    
    
    

}
    



//extension MessageContext {
    
    /*func classify() async {
        guard !self.isClassifying else { return }
        self.isClassifying = true
        defer { self.isClassifying = false }
        
        guard let tree = self.tree else { return }
        let message = _message
        do {
            
            let root = tree.root
            let accountContext = self._accountContext
            
            let archiveMailFolder = try await accountContext.mailFoldersRequest.getMailFolder(wellKnownFolderName: .archive)
            let junkMailFolder = try await accountContext.mailFoldersRequest.getMailFolder(wellKnownFolderName: .junkEmail)
            guard let archiveNode = root.children.first(where: { $0.id == archiveMailFolder.id }), let junkNode = root.children.first(where: { $0.id == junkMailFolder.id }) else {
                throw ClassifyError.noArchiveFolder
            }
            
            classifyResultText = try await Agent.classify(archiveNode: archiveNode, junkNode: junkNode, message: message) ?? "nil"
        } catch {
            classifyResultText = String(describing: error)
        }
    }*/
    
    
//}
/*func _insertAccount(microsoft: Microsoft.Account) throws -> Account {
    let modelID = microsoft.modelID
    
    // find existed
    if let model = try _fetchAccount(modelID: modelID) {
        
        // If found: update
        model.update(microsoft: microsoft)
        return model
    }
        
    // If not found: create
    let count = try _fetchAccountCount()
    let model = try Account(microsoft: microsoft, orderIndex: count)
    insert(model)
    return model
}

func _insertAccount(google: Google.Account) throws -> Account {
    let modelID = google.modelID
    
    // find existed
    if let model = try _fetchAccount(modelID: modelID) {
        
        // If found: update
        model.update(google: google)
        return model
    }
        
    // If not found: create
    let count = try _fetchAccountCount()
    let model = try Account(google: google, orderIndex: count)
    insert(model)
    return model
}*/






/*func setMessages(resources: [MessageResource], mailFolderID: MailFolderID, accountID: AccountID) throws -> [Message.PersistentID] {
    checkBackgroundThread()
    let mailFolder = try modelContext[mailFolderID]
    let account = try modelContext[accountID]
    do {
        
        // insert
        var inserts: [Message] = []
        for resource in resources {
            try inserts.append(modelContext._insertMessage(resource: resource, mailFolder: mailFolder, account: account))
        }
        
        // delete
        let removings = try modelContext._fetchMessageNotIn(inserts.map(\.resourceID), in: mailFolder.resourceID)
        try removings.forEach { _ = try modelContext._deleteMessage($0) }
        
        try modelContext.save()
        return inserts.map(\.persistentID)
    } catch {
        modelContext.rollback()
        throw error
    }
}*/

/*func setMessagesDeletePart(keep: [MessageID], in mailFolderID: MailFolderID) throws -> [MessageID] {
    checkBackgroundThread()
    let mailFolder = try modelContext[mailFolderID]
    do {
        // delete
        let removings = try modelContext._fetchMessageNotIn(keep, in: mailFolder.resourceID)
        try removings.forEach { _ = try modelContext._deleteMessage($0) }
        
        try modelContext.save()
        return removings.map(\.resourceID)
    } catch {
        modelContext.rollback()
        throw error
    }
}*/

/*func rootGoogleMailFolder(in accountID: AccountID) throws -> GoogleMailFolder? {
    let account = try modelContext[accountID]
    if account.root != nil, let accountID = accountID.google {
        return GoogleMailFolder.all(accountID: accountID)
    } else {
        return nil
    }
}*/

/*func _fetchMessageNotIn(_ messages: [MessageID], mailFolderID: MailFolderID) throws -> [Message] {
    let rawIDs = messages.map(\.uniqueID)
    //let mailFolderUniqueID = mailFolder.uniqueID
    let mailFolder = try self[mailFolderID]
    let uniqueIDs = mailFolder._messages.map(\.uniqueID)
    return try fetch(.init(predicate: #Predicate<Message> { !$0.deleteMark && uniqueIDs.contains($0.uniqueID) && !rawIDs.contains($0.uniqueID) }))
}*/

/*func _fetchMessages(mailFolderID: MailFolderID) throws -> [Message] {
    let mailFolderUniqueID = mailFolderID.uniqueID
    return try fetch(.init(predicate: #Predicate<Message> { !$0.deleteMark && $0.mailFolders.map(\.uniqueID).contains(mailFolderUniqueID) }))
}*/

/*func insertMailFolder(resource: MailFolderResource, accountID: AccountID) throws -> MailFolderID {
    let account = try modelContext[accountID]
    var mailFolder: MailFolder!
    try modelContext.transaction {
        mailFolder = try modelContext._insertMailFolder(resource: resource, account: account)
    }
    return mailFolder.resourceID
}*/
//
//  Clients+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/22/24.
//

import SwiftData









/*extension Google.Client {
    func loadAccountMailFolders() async {
        
            [service executeQuery:query completionHandler:^(GTLRServiceTicket *ticket, GTLRGmail_ListLabelsResponse *response, NSError *error) {
                if (error == nil) {
                    completion(response.labels, nil);
                } else {
                    completion(nil, error);
                }
            }];
    }
}*/


/*// MARK: - Update Session
extension Microsoft.Client {
    func session(id: Microsoft.ID) async throws -> Session {
        try await .microsoft(_msalRefreshSession(id: id).session)
    }
}*/












/*

extension Tree<Google.MailFolder> {
    func element(forPath path: [String]) -> Google.MailFolder? {
        var current: TreeNode<Google.MailFolder>? = root
        var currentPath = path
        
        while let unwrappedCurrent = current {
            unwrappedCurrent.children.first { $0.path ==  }
        }
    }
}
*/

//
//  Session.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/21/24.
//

import JetEmailGoogle
import JetEmailMicrosoft
import JetEmailData


public extension Session {
    /*var accountID: AccountID {
        switch self {
        case .microsoft(let microsoftSession): microsoftSession.account.id.general
        case .google   (let googleSession   ):    googleSession.account.id.general
        }
    }*/
}

public extension Session {
    /*var username: String {
        switch self {
        case .microsoft(let microsoftSession): microsoftSession.username
        case    .google(let    googleSession):    googleSession.username
        }
    }*/
}

public extension Session {
    /*var microsoft: MicrosoftSession? {
        guard case .microsoft(let microsoft) = self else { return nil }
        return microsoft
    }
    
    var google: GoogleSession? {
        guard case .google(let google) = self else { return nil }
        return google
    }*/
}
//
//  Model+Graph.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import JetEmailData
import SwiftData
import os
import JetEmailData

// typealias AppItemModel<Item> = CombineContext<AppModel, Item>

/*extension AppModel {
    func callAsFunction<Item: UnifiedModel>(_ item: Item) -> AppItemModel<Item> {
        AppItemModel(context: self, item: item)
    }
    
    func callAsFunction<Item: ResourceIDProtocol>(_ item: Item) -> AppItemModel<Item> {
        AppItemModel(context: self, item: item)
    }
    
    /*func callAsFunction<Item: DataModel>(_ persistentID: Item.ID) -> AppItemModel<Item>? {
     guard let item = ModelContainer.shared.mainContext[persistentID] else { return nil }
     return AppItemModel(context: self, item: item)
     }*/
}

extension AppModel {
    /*func callAsFunction<Item: DataModel>(_ id: Item.ID) -> AppItemModel<Item>? {
        guard let item = try ModelContainer.shared.mainContext[id] else { return nil }
        return AppItemModel(context: self, item: item)
    }*/
    
    func callAsFunction(_ persistentID: AccountID) throws -> AppItemModel<Account> {
        let item = try mainContext[persistentID]
        return AppItemModel(context: self, item: item)
    }
    
    func callAsFunction(_ persistentID: MailFolderID) throws -> AppItemModel<MailFolder>? {
        let item = try mainContext[persistentID]
        return AppItemModel(context: self, item: item)
    }
    
    func callAsFunction(_ persistentID: MessageID) throws -> AppItemModel<Message>? {
        let item = try mainContext[persistentID]
        return AppItemModel(context: self, item: item)
    }
}*/



/*extension AccountID {
    @MainActor
    var mainContext: ModelContext {
        ModelContainer.shared.mainContext
    }
}

extension AppItemModel where Context == AppModel {
    var mainContext: ModelContext {
        context.mainContext
    }
}*/

//
//  Google+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

import JetEmailGoogle
import JetEmailMicrosoft
import os
import JetEmailData

/*@MainActor
extension AppItemModel where Context == AppModel, Item : UnifiedModel {
    var appModel: AppModel { context }
    var logger: Logger { appModel.logger }
    /*var isBusy: Bool {
        get { item.isBusy }
        set { item.isBusy = newValue }
    }*/
}*/
//
//  ViewModifiers.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import SwiftUI
import JetEmailData
import JetEmailData


/*extension View {
    /*func appModel(_ appModel: AppModel) -> some View {
        modifier(AppModelResultModifier(appModel: appModel))
    }*/
    
    func itemModel<Item : UnifiedModel>(_ item: Item) -> some View {
        modifier(ItemModelModifier(item: item))
    }
}

// MARK: - Modifier: AppModel.Init

/*fileprivate struct AppModelResultModifier : ViewModifier {
    let appModel: AppModel
    func body(content: Content) -> some View {
        content
            .environment(appModel)
            .modelContainer(.shared)
    }
}*/

// MARK: - Modifier: AppModel.Item

fileprivate struct ItemModelModifier<Item: UnifiedModel> : ViewModifier {
    
    @Environment(AppModel.self)
    var appModel
    
    let item: Item
    
    func body(content: Content) -> some View {
        content
            .environment(appModel(item))
            .environment(appModel(item.resourceID))
            .environment(item)
    }
}*/

/*
@MainActor
extension Scene {
    func appModel(_ appModel: AppModel) -> some Scene {
    }
    
    func settingsModel(_ settingsModel: SettingsModel) -> some Scene {
        environment(settingsModel)
    }
}
*/
/*
@ -1,81 +0,0 @@
//
//  Localizatino.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/12/24.
//

import JetEmailMicrosoft
import Foundation

fileprivate extension MicrosoftWellKnownFolderName {
    var systemOrder: Int? {
        switch self {
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
        
    var nameLocalizedKey: String? {
        switch self {
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
    
    var systemImage: String? {
        switch self {
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
*/
//
//  VC.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/31/24.
//
/*
 
 
 
 struct MyViewRepresentable : NSViewControllerRepresentable {
     func makeNSViewController(context: Context) -> NSViewController {
         MyVC()
     }
     
     func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
         
     }
         
     
 }

class MyVC: NSViewController {
    
    let endPoint = OutlookGraphEndPoint()
    
    var callGraphButton: NSButton!
    var loggingText: NSTextView!
    var signOutButton: NSButton!

    var usernameLabel: NSTextField!

    /*func initUI() {

        usernameLabel = NSTextField()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.stringValue = ""
        usernameLabel.isEditable = false
        usernameLabel.isBezeled = false
        self.view.addSubview(usernameLabel)

        usernameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30.0).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0).isActive = true

        // Add call Graph button
        callGraphButton  = NSButton()
        callGraphButton.translatesAutoresizingMaskIntoConstraints = false
        callGraphButton.title = "Call Microsoft Graph API"
        callGraphButton.target = self
        callGraphButton.action = #selector(callGraphAPI(_:))
        callGraphButton.bezelStyle = .rounded
        self.view.addSubview(callGraphButton)

        callGraphButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        callGraphButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50.0).isActive = true
        callGraphButton.heightAnchor.constraint(equalToConstant: 34.0).isActive = true

        // Add sign out button
        signOutButton = NSButton()
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.title = "Sign Out"
        signOutButton.target = self
        signOutButton.action = #selector(signOut(_:))
        signOutButton.bezelStyle = .texturedRounded
        self.view.addSubview(signOutButton)

        signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signOutButton.topAnchor.constraint(equalTo: callGraphButton.bottomAnchor, constant: 10.0).isActive = true
        signOutButton.heightAnchor.constraint(equalToConstant: 34.0).isActive = true
        signOutButton.isEnabled = false

        // Add logging textfield
        loggingText = NSTextView()
        loggingText.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(loggingText)

        loggingText.topAnchor.constraint(equalTo: signOutButton.bottomAnchor, constant: 10.0).isActive = true
        loggingText.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10.0).isActive = true
        loggingText.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10.0).isActive = true
        loggingText.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10.0).isActive = true
        loggingText.widthAnchor.constraint(equalToConstant: 500.0).isActive = true
        loggingText.heightAnchor.constraint(equalToConstant: 300.0).isActive = true
    }*/

    func platformViewDidLoadSetup() {}
    
    override func viewDidLoad() {

        super.viewDidLoad()

        //initUI()

        /*do {
            //try self.initMSAL()
        } catch let error {
            self.updateLogging(text: "Unable to create Application Context \(error)")
        }*/

        // self.loadCurrentAccount()
        // self.platformViewDidLoadSetup()
    }
    
    /*func initMSAL() throws {

        guard let authorityURL = URL(string: endPoint.kAuthority) else {
            self.updateLogging(text: "Unable to create authority URL")
            return
        }

        let authority = try MSALAADAuthority(url: authorityURL)

        let msalConfiguration = MSALPublicClientApplicationConfig(clientId: endPoint.kClientID, redirectUri: nil, authority: authority)
        endPoint.applicationContext = try MSALPublicClientApplication(configuration: msalConfiguration)
        self.initWebViewParams()
    }
    
    func initWebViewParams() {
        endPoint.webViewParameters = MSALWebviewParameters()
        }*/

    /*@objc func callGraphAPI(_ sender: AnyObject) {

        self.loadCurrentAccount { (account) in

            guard let currentAccount = account else {

                // We check to see if we have a current logged in account.
                // If we don't, then we need to sign someone in.
                self.acquireTokenInteractively()
                return
            }

            self.acquireTokenSilently(currentAccount)
        }
    }*/

    typealias AccountCompletion = (MSGraph.Account?) -> Void

    /*func loadCurrentAccount(completion: AccountCompletion? = nil) {

        guard let applicationContext = endPoint.applicationContext else { return }

        let msalParameters = MSALParameters()
        msalParameters.completionBlockQueue = DispatchQueue.main

        applicationContext.getCurrentAccount(with: msalParameters, completionBlock: { [endPoint] (currentAccount, previousAccount, error) in

            if let error = error {
                self.updateLogging(text: "Couldn't query current account with error: \(error)")
                return
            }

            if let currentAccount = currentAccount {

                self.updateLogging(text: "Found a signed in account \(String(describing: currentAccount.username)). Updating data for that account...")

                endPoint.currentAccount = currentAccount

                if let completion = completion {
                    completion(endPoint.currentAccount)
                }

                return
            }

            self.updateLogging(text: "Account signed out. Updating UX")
            endPoint.accessToken = ""
            endPoint.currentAccount = nil

            if let completion = completion {
                completion(nil)
            }
        })
    }*/
    
    /*func acquireTokenInteractively() {

        guard let applicationContext = endPoint.applicationContext else { return }
        guard let webViewParameters = endPoint.webViewParameters else { return }

        // #1
        let parameters = MSALInteractiveTokenParameters(scopes: endPoint.kScopes, webviewParameters: webViewParameters)
        parameters.promptType = .selectAccount

        // #2
        applicationContext.acquireToken(with: parameters) { [endPoint] (result, error) in

            // #3
            if let error = error {

                self.updateLogging(text: "Could not acquire token: \(error)")
                return
            }

            guard let result = result else {

                self.updateLogging(text: "Could not acquire token: No result returned")
                return
            }

            // #4
            endPoint.accessToken = result.accessToken
            self.updateLogging(text: "Access token is \(endPoint.accessToken)")
            endPoint.currentAccount = result.account
            endPoint.getContentWithToken()
        }
    }
    
    
    func acquireTokenSilently(_ account : MSGraph.Account!) {

        guard let applicationContext = endPoint.applicationContext else { return }

        /**

         Acquire a token for an existing account silently

         - forScopes:           Permissions you want included in the access token received
         in the result in the completionBlock. Not all scopes are
         guaranteed to be included in the access token returned.
         - account:             An account object that we retrieved from the application object before that the
         authentication flow will be locked down to.
         - completionBlock:     The completion block that will be called when the authentication
         flow completes, or encounters an error.
         */

        let parameters = MSALSilentTokenParameters(scopes: endPoint.kScopes, account: account)

        applicationContext.acquireTokenSilent(with: parameters) { [endPoint] (result, error) in

            if let error = error {

                let nsError = error as NSError

                // interactionRequired means we need to ask the user to sign-in. This usually happens
                // when the user's Refresh Token is expired or if the user has changed their password
                // among other possible reasons.

                if (nsError.domain == MSALErrorDomain) {

                    if (nsError.code == MSALError.interactionRequired.rawValue) {

                        DispatchQueue.main.async {
                            self.acquireTokenInteractively()
                        }
                        return
                    }
                }

                self.updateLogging(text: "Could not acquire token silently: \(error)")
                return
            }

            guard let result = result else {

                self.updateLogging(text: "Could not acquire token: No result returned")
                return
            }

            endPoint.accessToken = result.accessToken
            self.updateLogging(text: "Refreshed Access token is \(endPoint.accessToken)")
            //? self.updateSignOutButton(enabled: true)
            endPoint.getContentWithToken()
        }
    }*/
    
    /*func getContentWithToken() {

        // Specify the Graph API endpoint
        let graphURI = endPoint.grapEndPointMe()
        let url = URL(string: graphURI + "mailFolders")
        
        var request = URLRequest(url: url!)

        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.setValue("Bearer \(endPoint.accessToken)", forHTTPHeaderField: "Authorization")
        print(endPoint.accessToken)

        URLSession..dataTask(with: request) { data, response, error in

            if let error = error {
                self.updateLogging(text: "Couldn't get graph result: \(error)")
                return
            }

            guard let result = try? JSONSerialization.jsonObject(with: data!, options: []) else {

                self.updateLogging(text: "Couldn't deserialize result JSON")
                return
            }

            self.updateLogging(text: "Result from Graph: \(result))")

            }.resume()
    }*/
    
    /*@objc func signOut(_ sender: AnyObject) {

            guard let applicationContext = endPoint.applicationContext else { return }

            guard let account = endPoint.currentAccount else { return }

            do {

                /**
                 Removes all tokens from the cache for this application for the provided account

                 - account:    The account to remove from the cache
                 */

                let signoutParameters = MSALSignoutParameters(webviewParameters: endPoint.webViewParameters!)
                signoutParameters.signoutFromBrowser = false // set this to true if you also want to signout from browser or webview

                applicationContext.signout(with: account, signoutParameters: signoutParameters, completionBlock: {[endPoint] (success, error) in

                    if let error = error {
                        self.updateLogging(text: "Couldn't sign out account with error: \(error)")
                        return
                    }

                    self.updateLogging(text: "Sign out completed successfully")
                    endPoint.accessToken = ""
                    endPoint.currentAccount = nil
                })

            }
        }*/
    
    func updateLogging(text : String) {

        if Thread.isMainThread {
            self.loggingText.string = text
        } else {
            DispatchQueue.main.async {
                self.loggingText.string = text
            }
        }
    }

    /*func updateSignOutButton(enabled : Bool) {
        if Thread.isMainThread {
            self.signOutButton.isEnabled = enabled
        } else {
            DispatchQueue.main.async {
                self.signOutButton.isEnabled = enabled
            }
        }
    }*/

     /*func updateAccountLabel() {

         guard let currentAccount = endPoint.currentAccount else {
            self.usernameLabel.stringValue = "Signed out"
            return
        }

        self.usernameLabel.stringValue = currentAccount.username ?? ""
        self.usernameLabel.sizeToFit()
     }*/

     /*func updateCurrentAccount(account: MSGraph.Account?) {
         endPoint.currentAccount = account
        self.updateAccountLabel()
        self.updateSignOutButton(enabled: account != nil)
    }*/
}
*/

/*// get "archive", "junk" mail folders
let archiveMailFolder = try await getMailFolder(wellKnownFolderName: Microsoft.MailFolder.WellKnownFolderName.archive)
let junkMailFolder = try await getMailFolder(wellKnownFolderName: .junkEmail)

guard
    let archiveNode = root.children.first(where: { $0.element.id == archiveMailFolder.unifiedID }),
    let junkNode = root.children.first(where: { $0.element.id == junkMailFolder.unifiedID })
else {
    throw ClassifyError.noArchiveFolder
}*/
//
//  FolderList.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//
/*
import Foundation
import AppKit

struct TargetFolderPaths {
    
}

extension TargetFolderPaths {
    static var shared: [[FolderName]] = {
        let asset = NSDataAsset(name: "TargetFolderPaths", bundle: Bundle.main)!
        return try! asset.data.jsonDecode([[FolderName]].self)
    }()
    static var sharedTree: Tree<FolderName> = {
        let folders = shared
        let tree = Tree<FolderName>(rootValue: .special(.root))
        for path in folders {
            var current = tree.root
            for name in path {
                if let node = current.children.first(where: { $0.element == name }) {
                    current = node
                    continue
                } else {
                    let child = TreeNode(value: name)
                    current.children.append(child)
                    current = child
                }
            }
        }
        return tree
    }()
}
*/
/*
enum SpecialFolderName: String {
    case root = "root"
    case archive = "archive"
    case junkEmail = "junkemail"
    
    var graph: MSGraph.MailFolder.WellKnownFolderName {
        switch self {
        case .root: .msgFolderRoot
        case .archive: .archive
        case .junkEmail: .junkEmail
        }
    }
}

enum FolderName : Codable, RawRepresentable {
    
    case display(String)
    case special(SpecialFolderName)
    
    /*init(from decoder: Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(String.self)
        self.init(rawValue: rawValue)!
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }*/
    
    init?(rawValue: String) {
        if rawValue.starts(with: "$") {
            let rawValue = String(rawValue.dropFirst())
            self = .special(.init(rawValue: rawValue)!)
        } else {
            self = .display(rawValue)
        }
    }
    
    var rawValue: String {
        switch self {
        case .display(let name): name
        case .special(let specialName): "$" + specialName.rawValue
        }
    }
}
*/

//
//  HStack.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//
/*
import SwiftUI

struct MyEqualWidthHStack: Layout {
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        // Return a size.
        guard !subviews.isEmpty else { return .zero }

        let maxSize = maxSize(subviews: subviews)
        let spacing = spacing(subviews: subviews)
        let totalSpacing = spacing.reduce(0) { $0 + $1 }

        return CGSize(
            width: maxSize.width * CGFloat(subviews.count) + totalSpacing,
            height: maxSize.height)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        // Place child views.
        guard !subviews.isEmpty else { return }
      
        let maxSize = maxSize(subviews: subviews)
        let spacing = spacing(subviews: subviews)

        let placementProposal = ProposedViewSize(width: maxSize.width, height: maxSize.height)
        var x = bounds.minX + maxSize.width / 2
      
        for index in subviews.indices {
            subviews[index].place(
                at: CGPoint(x: x, y: bounds.midY),
                anchor: .center,
                proposal: placementProposal)
            
            x += maxSize.width + spacing[index]
        }
    }
    
    private func maxSize(subviews: Subviews) -> CGSize {
        let subviewSizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let maxSize: CGSize = subviewSizes.reduce(.zero) { currentMax, subviewSize in
            CGSize(
                width: max(currentMax.width, subviewSize.width),
                height: max(currentMax.height, subviewSize.height))
        }

        return maxSize
    }
    
    private func spacing(subviews: Subviews) -> [CGFloat] {
        subviews.indices.map { index in
            guard index < subviews.count - 1 else { return 0 }
            return subviews[index].spacing.distance(
                to: subviews[index + 1].spacing,
                along: .horizontal)
        }
    }
}
*/


/*extension PlatformEnum: ResourceProtocol where Microsoft : PlatformSpecificDataProtocol, Google : PlatformSpecificDataProtocol, Microsoft.ID == ID, Google.ID == ID {
    
}*/
 // ResourceSpecificProtocol
/*
 enum GeneralConstants {
     enum Gmail {
         static let clientID = "679326713487-5r16ir2f57bpmuh2d6dal1bcm9m1ffqc.apps.googleusercontent.com"
         static let redirectURL = URL(string: "com.googleusercontent.apps.679326713487-5r16ir2f57bpmuh2d6dal1bcm9m1ffqc:/oauthredirect")!
         //static let mailScope: [GoogleScope] = [.userInfo, .userEmail, .mail]
         //static let contactsScope: [GoogleScope] = mailScope + [.contacts, .otherContacts]
         static let trashLabelPath = "TRASH"
         // Empty pass is For All MAIL
         static let standardGmailPaths = ["INBOX", "CHAT", "SENT", "IMPORTANT", trashLabelPath, "DRAFT", "SPAM", "STARRED", "UNREAD", ""]
         static let gmailRecoveryEmailSubjects = [
             "Your FlowCrypt Backup",
             "Your CryptUp Backup",
             "All you need to know about CryptUP (contains a backup)",
             "CryptUP Account Backup"
         ]
     }

     enum Global {
         static let attachmentSizeLimit = 10_000_000
         static let signatureSeparator = "______"
     }

     enum Mock {
         static let backendUrl = "https://127.0.0.1:8001"
         static let userEmail = "e2e.enterprise.test@flowcrypt.com"
     }

     enum EmailConstant {
         static let recoverAccountSearchSubject = [
             "Your FlowCrypt Backup",
             "Your CryptUp Backup",
             "Your CryptUP Backup",
             "CryptUP Account Backup",
             "All you need to know about CryptUP (contains a backup)"
         ]
     }
 }

 */

// import GoogleAPIClientForREST_Gmail
/*extension Client {
    func loadAccountMailFolders() async {
        
            [service executeQuery:query completionHandler:^(GTLRServiceTicket *ticket, GTLRGmail_ListLabelsResponse *response, NSError *error) {
                if (error == nil) {
                    completion(response.labels, nil);
                } else {
                    completion(nil, error);
                }
            }];
    }
}*/




/*fileprivate struct FolderViewModel {
    enum ItemType: String {
        case folder, settings, separator, logOut
    }
}*/
/*

extension Microsoft {
    struct Session {
        let endpointURL         : URL
        let accessToken         : String
        let authorizationHeader : String
        let authenticationScheme: String
        let expiresOn           : Date?
    }
    
}



extension Session {
    init(endpointURL: URL, result: MSALResult) {
        self.init(
            endpointURL         : endpointURL,
            accessToken         : result.accessToken,
            authorizationHeader : result.authorizationHeader,
            authenticationScheme: result.authenticationScheme,
            expiresOn           : result.expiresOn
        )
        
        
        /*
         print(result.authority.url) // https://login.microsoftonline.com/9188040d-6c67-4c5b-b112-36a304b66dad
         print(result.tenantProfile.environment) // login.windows.net
         print(result.tenantProfile.identifier) // 00000000-0000-0000-6a55-0f478222bc8f
         print(result.tenantProfile.tenantId) // 9188040d-6c67-4c5b-b112-36a304b66dad
         print(result.tenantProfile.isHomeTenantProfile)
         */
    }
}

*/
//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/11/24.
//

import Foundation

/*public struct MailFolderSystemInfo : CodableValueType, Sendable {
    public let               order: Int?
    public let    nameLocalizedKey: String?
    public let         systemImage: String?
    
    public init(systemOrder: Int?, nameLocalizedKey: String?, systemImage: String?) {
        self.order            = systemOrder
        self.nameLocalizedKey = nameLocalizedKey
        self.systemImage      = systemImage
    }
    
    public static func localizedName(name: String?, localizedKey: String?) -> String {
        if let localizedKey {
            let localizedName = String(localized: .init(localizedKey), bundle: .module)
            
            // found localized key
            if localizedName != localizedKey {
                return localizedName
            }
        }
        
        return name?.nilIfEmpty ?? String(localized: "(MailFolder.NoName)", defaultValue: .init(name ?? ""))
    }
}*/
//
//  File.swift
//
//

import JetEmailData

/*@MainActor
extension PlatformEnum<MicrosoftAccountID, GoogleAccountID> {
    public func storedSession() -> Session? {
        switch self {
        case .microsoft(let id): id.storedSession.map(Session.microsoft)
        case    .google(let id): id.storedSession.map(Session.google)
        }
    }
    
    public func removeSession() -> Session? {
        switch self {
        case .microsoft(let id): id.removeSession().map(Session.microsoft)
        case    .google(let id): id.removeSession().map(Session.google)
        }
    }
    
    public func refreshSession() async throws -> Session? {
        switch self {
        case .microsoft(let id): try await .microsoft(id.refreshSession())
        case    .google(let id): try await .google(id.refreshSession())
        }
    }
}*/

/*@MainActor
extension AccountID {
    public func storedSession() -> Session? {
        platformCase?.storedSession()
    }
    
    public func removeSession() -> Session? {
        platformCase?.removeSession()
    }
    
    public func refreshSession() async throws -> Session? {
        try await platformCase?.refreshSession()
    }
}*/

 //
 //  File.swift
 //
 //
 //  Created by Cao, Jiannan on 3/7/24.
 //
 /*
 import JetEmailData

 extension ModelStore {
     
     //@ModelStoreActor
     static var _shared: ModelStore?
     
     //@ModelStoreActor
     public static var shared: ModelStore { get async {
         if let _shared { return _shared }
         let modelStore = await ModelStore(modelContainer: .shared)
         _shared = modelStore
         return modelStore
     } }
 }
 /*
 @globalActor
 public actor ModelStoreActor : Actor {
     public static let shared = ModelStoreActor()
 }
 */
 */



*/
/*
 extension MicrosoftSession : SessionAPIProtocol {
     public typealias  SessionType = MicrosoftSession
     //public typealias MailFolderType = MicrosoftMailFolder
     //public typealias    MessageType = MicrosoftMessage
     
     /*@MainActor // for SessionStore
     static public func sessions(client: MicrosoftClient) async throws -> [MicrosoftSession] { // the sessions should be refresh before using to fetch
         try await client.sessions()
     }

     
     @MainActor
     static public func signIn(client: MicrosoftClient) async throws -> MicrosoftSession {
         try await client.signIn()
     }
     
     @MainActor
     public func signOut() async throws -> MicrosoftSession {
         try await client.signOut(session: self)
     }*/
     
     public var refresh: MicrosoftSession { get async throws {
         try await client._refresh(session: self)
     } }
     
     @MainActor
     public func signOut() async throws -> MicrosoftSession {
         try await client._signOut(session: self)
     }
 }
 */
/*
// MARK: - Session API

extension GoogleSession : SessionProtocol, SessionAPIProtocol {
    public typealias     ClientType = GoogleClient
    public typealias  AccountIDType = GoogleAccountID
    public typealias    AccountType = GoogleAccount
    public typealias MailFolderType = GoogleMailFolder
    public typealias    MessageType = GoogleMessage
    
    
    /* @MainActor // for SessionStore
     public static func sessions(client: GoogleClient) async throws -> [GoogleSession] { // the sessions should be refresh before using to fetch
     try await client.sessions()
     }
     
     @MainActor // for WebAuthenticationSession
     public static func signIn(client: GoogleClient) async throws -> GoogleSession {
     try await client.signIn()
     }
     
     public func signOut() async throws -> GoogleSession {
     try await client.signOut(session: self)
     }*/
    
    // used for request, refresh if neccessary
    
    public var refresh: GoogleSession { get async throws {
        try await client._refresh(session: self)
    } }
    
    @MainActor
    public func signOut() async throws -> GoogleSession {
        _ = try await client.keychain.deleteItem(_item)
        _ = account.id.removeSession()
        return self
    }
}
*/
/*
public protocol ClientSessionAPI {
    associatedtype SessionType : Sendable

    @MainActor
    var sessions : [SessionType] { get async throws }
    
    @MainActor
    func        signIn (                                    ) async throws -> SessionType
    
    /*@MainActor
    func        signOut(session  : SessionType              ) async throws -> SessionType*/
    
    /*@MainActor
    func  removeSession(accountID: SessionType.AccountIDType)       throws -> SessionType?

    @MainActor
    func  storedSession(accountID: SessionType.AccountIDType)       throws -> SessionType?
    
    @MainActor
    func refreshSession(accountID: SessionType.AccountIDType) async throws -> SessionType*/
}
*/

/*
extension PlatformEnum: SessionProtocol where
    Microsoft : SessionProtocol,
       Google : SessionProtocol
    //Microsoft  .AccountType.GeneralID == AccountID,
      // Google  .AccountType.GeneralID == AccountID
//Microsoft.ModelStoreType == Google.ModelStoreType
{
    public var client: PlatformEnum<Microsoft.ClientType, Google.ClientType> {
        switch self {
        case .microsoft(let session): .microsoft(session.client)
        case    .google(let session):    .google(session.client)
        }
    }
    
    public var account: AccountType {
        switch self {
        case .microsoft(let session): .microsoft(session.account)
        case    .google(let session):    .google(session.account)
        }
    }
    
    public typealias     ClientType = PlatformEnum<Microsoft .ClientType, Google .ClientType>
    public typealias    AccountType = PlatformEnum<Microsoft.AccountType, Google.AccountType>
    
    // sessions
    /*
     @MainActor
     public static func sessions(client: ClientType) async throws -> [Self] {
     switch client {
     case .microsoft(let client): try await Microsoft.sessions(client: client).map(Self.microsoft)
     case    .google(let client): try await    Google.sessions(client: client).map(Self.google   )
     }
     }
     
     @MainActor
     public static func signIn(client: ClientType) async throws -> Self {
     switch client {
     case .microsoft(let client): try await .microsoft(Microsoft.signIn(client: client))
     case    .google(let client): try await    .google(   Google.signIn(client: client))
     }
     }*/
}
*/

/*@MainActor
public func storedSession(accountID: SessionType.AccountIDType) throws -> SessionType? {
    switch self {
    case .microsoft(let client):
        guard let accountID = accountID.microsoft else { throw SessionError.idNotForThePlatform }
        return try client.storedSession(accountID: accountID).map(SessionType.microsoft)
    case    .google(let client):
        guard let accountID = accountID.google else { throw SessionError.idNotForThePlatform }
        return try client.storedSession(accountID: accountID).map(SessionType.google)
    }
}

public func refreshSession(accountID: SessionType.AccountIDType) async throws -> SessionType {
    switch self {
    case .microsoft(let client):
        guard let accountID = accountID.microsoft else { throw SessionError.idNotForThePlatform }
        return try await .microsoft(client.refreshSession(accountID: accountID))
    case    .google(let client):
        guard let accountID = accountID.google else { throw SessionError.idNotForThePlatform }
        return try await    .google(client.refreshSession(accountID: accountID))
    }
}

public func removeSession(accountID: SessionType.AccountIDType) throws -> SessionType? {
    switch self {
    case .microsoft(let client):
        guard let accountID = accountID.microsoft else { throw SessionError.idNotForThePlatform }
        return try client.removeSession(accountID: accountID).map(SessionType.microsoft)
    case    .google(let client):
        guard let accountID = accountID.google else { throw SessionError.idNotForThePlatform }
        return try client.removeSession(accountID: accountID).map(SessionType.google)
    }
}*/
/*
 extension PlatformEnum: SessionRESTProtocol where
     Microsoft : SessionRESTProtocol,
        Google : SessionRESTProtocol,
     Microsoft.MailFolderType.ID == MicrosoftMailFolderID,
        Google.MailFolderType.ID ==    GoogleMailFolderID,
     Microsoft   .MessageType.ID ==    MicrosoftMessageID,
        Google   .MessageType.ID ==       GoogleMessageID
 //Microsoft.ModelStoreType == Google.ModelStoreType
 {
     public typealias MailFolderType = PlatformEnum<Microsoft   .MailFolderType,  Google      .MailFolderType>
     
     public typealias MessageType = PlatformEnum<Microsoft   .MessageType,  Google      .MessageType>
     
     
     
     // account - mailFolders
     
     public func rootMailFolder() async throws -> MailFolderType {
         checkBackgroundThread()
         switch self {
         case .microsoft(let session): return .microsoft(try await session.rootMailFolder())
         case    .google(let session): return    .google(try await session.rootMailFolder())
         }
     }
     
     //@SessionActor
     /*public func loadMailFolders(modelStore: ModelStore) async throws -> MailFolderType {
         checkBackgroundThread()
         let rootMailFolder = try await getRootMailFolder()                                  // Session
         _ = try await modelStore.setRootMailFolder(resource: rootMailFolder, accountID: account.id)  // ModelStore
         
         try await loadMailFoldersUnderRoot(root: rootMailFolder, modelStore: modelStore)
         return rootMailFolder
     }*/
     
     public func loadMailFoldersUnderRoot(root: MailFolderType, modelStore: ModelStore) async throws {
         checkBackgroundThread()
         switch self {
         case .microsoft(let session): try await session.loadMailFoldersUnderRoot(root: root.microsoft, modelStore: modelStore)
         case    .google(let session): try await session.loadMailFoldersUnderRoot(root: root.google   , modelStore: modelStore)
         }
     }
     
     // mailFolder - messages

     public func syncMessages(mailFolderID: MailFolderID, modelStore: ModelStore) async throws {
         checkBackgroundThread()
         switch self {
         case .microsoft(let session): try await session.syncMessages(mailFolderID: mailFolderID.microsoft, modelStore: modelStore)
         case    .google(let session): try await session.syncMessages(mailFolderID: mailFolderID.google   , modelStore: modelStore)
         }
     }
     
     /*@MainActor
     public func loadMessagesMain(mailFolderID: MailFolderID, modelContext: ModelContext) async throws {
         checkBackgroundThread()
         switch self {
         case .microsoft(let session):
             guard let mailFolderID = mailFolderID.microsoft else { return }
             try await session.loadMessagesMain(mailFolderID: mailFolderID, modelContext: modelContext)
         case    .google(let session):
             guard let mailFolderID = mailFolderID.google else { return }
             try await session.loadMessagesMain(mailFolderID: mailFolderID, modelContext: modelContext)
         }
     }*/
     
     public func moveMessage(messageID: MessageID, fromID: MailFolderID, toID: MailFolderID) async throws -> MessageType {
         checkBackgroundThread()
         return switch self {
         case .microsoft(let session): .microsoft(try await session.moveMessage(messageID: messageID.microsoft, fromID: fromID.microsoft, toID: toID.microsoft))
         case    .google(let session): .google(try await session.moveMessage(messageID: messageID.google   , fromID: fromID.google   , toID: toID.google   ))
         }
     }
     
     // message

     public func messageBody(messageID: MessageID) async throws -> MessageType {
         checkBackgroundThread()
         return switch self {
         case .microsoft(let session): .microsoft(try await session.messageBody(messageID: messageID.microsoft))
         case    .google(let session):    .google(try await session.messageBody(messageID: messageID.google   ))
         }
     }
 }
 */
/*
@MainActor
extension GoogleAccountID : AccountSessionAPI {

    public var storedSession: GoogleSession? { SessionStore.shared[self] }
    public var refreshSession: GoogleSession? { get async throws {
        try await SessionStore.shared.session(id: self, forceRefresh: false)?.refresh
    } }
    public func removeSession() -> GoogleSession? { SessionStore.shared.remove(id: self) }
}
*/

/*@MainActor // for id.loadingMessageState
func loadMessagesMain(mailFolderID: GoogleMailFolderID, modelContext: ModelContext) async throws {
    
    let newMessageIDs: [MessageID] = try await getMessagesID(in: mailFolderID).map { $0.generalID }
    
    // remove
    let shouldInsertMessageIDs = try await modelContext.setMessagesDeletePart(newMessageIDs: newMessageIDs, mailFolderID: mailFolderID.generalID).compactMap(\.element.google)
    
    
    if !shouldInsertMessageIDs.isEmpty  {
        // do {
        let stream = try await getMessagesStream(ids: shouldInsertMessageIDs, format: .metadata)
        //}
        /* catch let error as URLError where error.code == .badURL {
         (total, stream) = try await session.getMessagesStream(id: innerID)
         }*/
        let total = newMessageIDs.count
        var value = total - shouldInsertMessageIDs.count
        
        mailFolderID.generalID.loadingMessageState = .loading(value: value, total: total)
        for try await messages in stream {
            value += try modelContext.setMessagesInsertPart(resources: messages, mailFolderID: mailFolderID.generalID).count // MSAL to SwiftData
            mailFolderID.generalID.loadingMessageState = .loading(value: value, total: total)
        }
    }
}*/

/*func getMessages(ids: [GoogleMessageID]) async throws -> [GoogleMessage] {
    return try await getMessages(ids: ids, format: .metadata).map { try $0.with(accountID: account.id) }
}*/


// https://developers.google.com/gmail/api/reference/rest/v1/users.messages/get
/*private func getMessages(ids: [GoogleMessageID], fields: String? = nil, format: GetMessageFormat) async throws -> [GoogleMessageInner] {
    if ids.count > 100 {
        let first100 = ids.prefix(100)
        let rest = ids.dropFirst(100)
        let result = try await getMessages(ids: Array(first100), fields: fields, format: format) + getMessages(ids: Array(rest), fields: fields, format: format)
        return result
    }
    
    let batchResult = try await service.execute(GTLRBatchResult.self) {
        GTLRBatchQuery(queries: ids.map { [accountID = account.id.innerID] in
            let query = GTLRGmailQuery_UsersMessagesGet.query(withUserId: accountID, identifier: $0.innerID)
            query.fields = fields
            query.format = format.rawValue
            return query
        })
    }
    
    return if let messagesDict = batchResult.successes as? [String: GTLRGmail_Message] {
        try messagesDict.values.map { try $0.messageInner }
    } else {
        fatalError()
    }
}*/


// https://developers.google.com/gmail/api/reference/rest/v1/users.messages/get
/*func getMessages(mailFolderID: MailFolder.ID) async throws -> [Message] {
    try await getItems("mailFolders", "\(microsoftID)", "messages", queryItems: [
        .orderBy(name: "receivedDateTime", .descending),
        .select(
            "id",
            "subject",
            "createdDateTime",
            "lastModifiedDateTime",
            "receivedDateTime",
            "sentDateTime",
            "sender",
            "from",
            "toRecipients",
            "replyTo",
            "ccRecipients",
            "bccRecipients",
            "bodyPreview"
        )
    ])
}*/

/*
 
 extension MicrosoftSession : RestAPIProtocol {
     
     // MARK: - Account-MailFolders
     
     public func rootMailFolder() async throws -> MicrosoftMailFolder {
         try await getMailFolder(systemName: .msgFolderRoot)
     }
     
     public func loadMailFoldersUnderRoot(root: MicrosoftMailFolder, modelStore: ModelStore) async throws {
         var queue: [MicrosoftMailFolderID] = [root.id]
         while !queue.isEmpty {
             let current = queue.removeFirst()
             let childrenMailFolders = try await getChildFolders(mailFolderID: current)
             let children = try await modelStore.setChildrenMailFolders(resources: childrenMailFolders, parentID: current.generalID, accountID: account.generalID).map { try $0.microsoft }
             queue.append(contentsOf: children)
         }
     }
     
     // MARK: - MailFolder-Messages
     /*
     // https://learn.microsoft.com/en-us/graph/delta-query-messages#example-1-synchronize-messages-in-a-folder
     func _loadMessages(mailFolderID: MicrosoftMailFolderID, modelStore: ModelStore) async throws {
         if let deltaLink = await mailFolderID.deltaLink{
             // let currentMessageIDs = try await modelStore.messageIDs(mailFolderID: mailFolderID.generalID)
             let stream = try await messagesDeltaStream(deltaLink: deltaLink, maxPageSize: nil)
             for try await delta in stream {
                 let deltaInserts = delta.values.filter { $0.inner.removed == nil }
                 let deltaDeletes = delta.values.filter { $0.inner.removed != nil }.map { $0.generalID }
                 
                 _ = try await modelStore.insertMessages(sources   : deltaInserts, mailFolderID: mailFolderID.generalID) // MSAL to SwiftData
                 _ = try await modelStore.deleteMessages(messageIDs: deltaDeletes, mailFolderID: mailFolderID.generalID) // MSAL to SwiftData
             }
         } else {
             let count = Int(try await messagesCount(mailFolderID: mailFolderID))
             
             var inserts = [MicrosoftMessage]()
             
             await MainActor.run {
                 mailFolderID.generalID.loadingMessageState = .loading(value: 0, total: count)
             }
             
             let stream = try await messagesDeltaStream(mailFolderID: mailFolderID, maxPageSize: nil)
             for try await delta in stream {
                 let deltaInserts = delta.values.filter { $0.inner.removed == nil }
                 let deltaDeletes = delta.values.filter { $0.inner.removed != nil }.map { $0.generalID }
                 
                 _ = try await modelStore.insertMessages(sources   : deltaInserts, mailFolderID: mailFolderID.generalID) // MSAL to SwiftData
                 _ = try await modelStore.deleteMessages(messageIDs: deltaDeletes, mailFolderID: mailFolderID.generalID) // MSAL to SwiftData

                 
                 inserts.append(contentsOf: deltaInserts)
                 
                 await MainActor.run { [value = inserts.count] in
                     mailFolderID.generalID.loadingMessageState = .loading(value: value, total: count)
                     mailFolderID.deltaLink = delta.deltaLink
                 }
             }
         }
     }*/
     
     
     public func syncMessages(mailFolderID: MicrosoftMailFolderID, modelStore: ModelStore) async throws {
         let checkingPageSize: Int? = 100 // max: 1000, default: 100
         let loadingBatchSize: Int  =  10 // max: 20
         
         // checking
         var newMessageIDs = [MicrosoftMessageID]()
         let (count, idStream) = try await checkMessageIDs(mailFolderID: mailFolderID, pageSize: checkingPageSize)
         for try await ids in idStream {
             newMessageIDs.append(contentsOf: ids)
             await MainActor.run { [value = newMessageIDs.count] in
                 mailFolderID.generalID.loadingMessageState = .checking(value: value, total: count)
             }
         }

         // remove
         let shouldInsertMessageIDs = try await modelStore.setMessagesDeletePart(newMessageIDs: newMessageIDs.map(\.generalID), mailFolderID: mailFolderID.generalID).map { try $0.element.microsoft }
         
         // loading
         guard !shouldInsertMessageIDs.isEmpty else { return }
         let stream = try await loadMessagesStream(mailFolderID: mailFolderID, messageIDs: shouldInsertMessageIDs, batchSize: loadingBatchSize)
         let total = newMessageIDs.count
         var value = total - shouldInsertMessageIDs.count
         for try await messages in stream {
             value += try await modelStore.insertMessages(sources: messages, mailFolderID: mailFolderID.generalID).count // MSAL to SwiftData
             await MainActor.run { [value] in
                 mailFolderID.generalID.loadingMessageState = .loading(value: value, total: total)
             }
         }
     }
     
     /*func loadMessages(mailFolderID: MicrosoftMailFolderID, modelStore: ModelStore) async throws {
         
         let newMessageIDs: [MessageID] = try await getMessagesID(in: mailFolderID).map { $0.generalID }

         // remove
         let firstIndexToLoad = try await modelStore.setMessagesDeletePart(newMessageIDs: newMessageIDs, mailFolderID: mailFolderID.generalID).first?.offset
         
         
         //let (total, stream): (total: Int, stream: some AsyncSequenceOf<[MicrosoftMessage]>)
         
         if let firstIndexToLoad {
            // do {
             let (total, stream) = try await getMessagesStream(id: mailFolderID, skip: firstIndexToLoad)
             //}
             /* catch let error as URLError where error.code == .badURL {
                 (total, stream) = try await session.getMessagesStream(id: innerID)
             }*/
             var value = firstIndexToLoad
             await MainActor.run { [value] in
                 mailFolderID.generalID.loadingMessageState = .loading(value: value, total: total)
             }
             
             for try await messages in stream {
                 value += try await modelStore.setMessagesInsertPart(resources: messages, mailFolderID: mailFolderID.generalID).count // MSAL to SwiftData
                 await MainActor.run { [value] in
                     mailFolderID.generalID.loadingMessageState = .loading(value: value, total: total)
                 }
             }
         }
     }*/
     
     /*@MainActor // for id.loadingMessageState
     func loadMessagesMain(mailFolderID: MicrosoftMailFolderID, modelContext: ModelContext) async throws {
         
         let newMessageIDs: [MessageID] = try await getMessagesID(in: mailFolderID).map { $0.generalID }

         // remove
         let firstIndexToLoad = try await modelContext.setMessagesDeletePart(newMessageIDs: newMessageIDs, mailFolderID: mailFolderID.generalID).first?.offset
         
         
         let (total, stream): (total: Int, stream: AsyncThrowingStream<[MicrosoftMessage], Error>)
         
         if let firstIndexToLoad {
            // do {
             (total, stream) = try await getMessagesStream(id: mailFolderID, skip: firstIndexToLoad)
             //}
             /* catch let error as URLError where error.code == .badURL {
                 (total, stream) = try await session.getMessagesStream(id: innerID)
             }*/
             var value = firstIndexToLoad
             mailFolderID.generalID.loadingMessageState = .loading(value: value, total: total)
             for try await messages in stream {
                 value += try modelContext.setMessagesInsertPart(resources: messages, mailFolderID: mailFolderID.generalID).count // MSAL to SwiftData
                 mailFolderID.generalID.loadingMessageState = .loading(value: value, total: total)
             }
         }
     }*/
         
     // MARK: - Message

     // https://learn.microsoft.com/en-us/graph/api/message-move
     public func moveMessage(messageID: MicrosoftMessageID, fromID: MicrosoftMailFolderID, toID: MicrosoftMailFolderID) async throws -> MicrosoftMessage {
         struct MessageMoveRequestBody : Encodable {
             let destinationId: String
         }
         return try await postItem(
             url: client.endpoint(pathComponents: "me", "mailFolders", fromID.innerID, "messages", messageID.innerID, "move"),
             body: MessageMoveRequestBody(destinationId: toID.innerID),
             responseType: _MicrosoftAPI.MicrosoftMessageInner.self).outer(accountID: account.id, raw: nil)
     }
     
     
     // https://learn.microsoft.com/en-us/graph/api/message-get
     public func messageBody(messageID: MicrosoftMessageID) async throws -> MicrosoftMessage {
         let inner: _MicrosoftAPI.MicrosoftMessageInner = try await getValue(
             url: client.endpoint(pathComponents: "me", "messages", messageID.innerID, queryItems: .selectForMessageBody)
         )
         let raw = try await getMultipartData(url: client.endpoint(pathComponents: "me", "messages", messageID.innerID, "$value"))
         return inner.outer(accountID: account.id, raw: raw)
     }
 }



 // used for checking status
 /*
 import JetEmailData

 @MainActor
 extension MicrosoftAccountID : AccountSessionAPI {
     public var storedSession: MicrosoftSession? { SessionStore.shared[self] }
     public var refreshSession: MicrosoftSession? { get async throws {
         let session = try await SessionStore.shared.session(id: self, forceRefresh: false)
         return try await session.refresh
     } }
     public func removeSession() -> MicrosoftSession? { SessionStore.shared.remove(id: self) }
 }
 */

 */


/*// https://developers.google.com/gmail/api/reference/rest/v1/users.messages/list
func messageIDs(mailFolderID: GoogleMailFolderID) async throws -> [GoogleMessageID] {
    let query = GTLRGmailQuery_UsersMessagesList.query(withUserId: account.id.innerID)
    query.labelIds = [mailFolderID.innerID]
    query.maxResults = 500 // maxResults: 1-500, default: 100
    // service.shouldFetchNextPages == true
    
    let response: GTLRGmail_ListMessagesResponse = try await service.execute(query)
    let messages = response.messages ?? []
    return try messages.map { try $0.messageInner.id(accountID: account.id) }
}*/
/*
 
 // pageSize => $top: 1-1000, default: nil (10)
 func messagesCount(mailFolderID: MicrosoftMailFolderID) async throws -> Int32 {
     let count = try await getValue(
         url: client.endpoint(
             pathComponents: "me", "mailFolders", mailFolderID.innerID,
             queryItems: .selectTotalItemCount
         ),
         responseType: _MicrosoftAPI.MicrosoftMailFolderInner.self
     ).totalItemCount
     
     guard let count else { throw MicrosoftAuthError.collectionResponseNoCount }
     return count
 }
 */
//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/8/24.
//
/*
import MSAL // for  MSALInteractiveTokenParameters, MSALSignoutParameters
import JetEmailData

extension MicrosoftClient {
    
    /*@MainActor // for webViewParameters
    var webViewParameters: MSALWebviewParameters { get throws {
        MainActor.assertIsolated()
        // TODO:
#if !os(macOS)
        guard let window = UIApplication.sharedKeyWindow, let viewController = window.rootViewController else { throw AuthError.authorizeNoMainWindow }
#else
        guard let window = NSApplication.sharedKeyWindow, let viewController = window.contentViewController else { throw AuthError.authorizeNoMainWindow }
#endif
        return .init(authPresentationViewController: viewController)
    } }*/
    
    

}

*/
