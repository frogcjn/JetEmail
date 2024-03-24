//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//


import struct Foundation.Data
import struct Foundation.Date
import   func JetEmailFoundation.checkBackgroundThread

public enum PlatformEnum<Microsoft, Google> {
    case microsoft(Microsoft)
    case    google(Google   )
}

public extension PlatformEnum {
    var microsoft: Microsoft { get throws {
        guard case .microsoft(let microsoft) = self else { throw PlatformEnumError.noPlatform(.microsoft) }
        return microsoft
    } }
    
    var google   : Google    { get throws {
        guard case .google   (let google   ) = self else { throw PlatformEnumError.noPlatform(.google) }
        return google
    } }
}

extension PlatformEnum:  Sendable where Microsoft :  Sendable, Google :  Sendable {}
extension PlatformEnum: Equatable where Microsoft : Equatable, Google : Equatable {}
extension PlatformEnum:  Hashable where Microsoft :  Hashable, Google :  Hashable {}
extension PlatformEnum:   Codable where Microsoft :   Codable, Google :   Codable {}

// MARK: - GeneralIdentifiable

extension PlatformEnum : Identifiable, GeneralIdentifiable where
    Microsoft : GeneralIdentifiable,
    Google    : GeneralIdentifiable,
    Microsoft.GeneralID == Google.GeneralID
{
    public var id: GeneralID { generalID }
    
    public typealias GeneralID = Microsoft.GeneralID
    
    public var generalID: GeneralID {
        switch self {
        case .microsoft(let platform): platform.generalID
        case    .google(let platform): platform.generalID
        }
    }
}



// MARK: - AccountID

extension PlatformEnum : ResourceSpecificIDProtocol, ResourceIDProtocol, AccountIDProtocol where
Microsoft : PlatformSpecificAccountIDProtocol,
   Google : PlatformSpecificAccountIDProtocol,
Microsoft.GeneralID == Self,
   Google.GeneralID == Self
{
    public typealias AccountIDType = Self
    
    public var platform: Platform {
        switch self {
        case .microsoft(let id): id.platform
        case    .google(let id): id.platform
        }
    }
    
    public var innerID: String {
        switch self {
        case .microsoft(let id): id.innerID
        case    .google(let id): id.innerID
        }
    }
}

public extension AccountID {
    var platformCase: PlatformEnum<MicrosoftAccountID, GoogleAccountID> { get throws {
        switch platform {
        case .microsoft: .microsoft(.init(innerID: innerID))
        case    .google:    .google(.init(innerID: innerID))
        default        : throw PlatformEnumError.noPlatform(platform)
        }
    } }
    
    var microsoft: MicrosoftAccountID { get throws { try platformCase.microsoft } }
    var google   : GoogleAccountID    { get throws { try platformCase.google    } }
}

// MARK: - MailFolderID

public extension MailFolderID {
    var platformCase: PlatformEnum<MicrosoftMailFolderID, GoogleMailFolderID> { get throws {
        switch try accountID.platformCase {
        case .microsoft(let accountID): .microsoft(.init(accountID: accountID, innerID: innerID))
        case    .google(let accountID):    .google(.init(accountID: accountID, innerID: innerID))
        // default                       : throw PlatformEnumError.noPlatform(platform)
        }
    } }
    
    var microsoft: MicrosoftMailFolderID { get throws { try platformCase.microsoft } }
    var google   : GoogleMailFolderID    { get throws { try platformCase.google    } }
}


// MARK: - MessageID

public extension MessageID {
    var platformCase: PlatformEnum<MicrosoftMessageID, GoogleMessageID> { get throws {
        switch try accountID.platformCase {
        case .microsoft(let accountID): .microsoft(.init(accountID: accountID, innerID: innerID))
        case    .google(let accountID):    .google(.init(accountID: accountID, innerID: innerID))
        // default                       : throw PlatformEnumError.noPlatform(platform)
        }
    } }
    
    var microsoft: MicrosoftMessageID { get throws { try platformCase.microsoft } }
    var google   : GoogleMessageID    { get throws { try platformCase.google    } }
}

// MARK: - Account

extension PlatformEnum: AccountProtocol where
    Microsoft : AccountProtocol,
       Google : AccountProtocol,
    Microsoft.GeneralID == AccountID,
       Google.GeneralID == AccountID
{
    public var username: String {
        switch self {
        case .microsoft(let account): account.username
        case    .google(let account): account.username
        }
    }
}

// MARK: - Session

extension PlatformEnum: SessionProtocol where
    Microsoft : SessionProtocol,
       Google : SessionProtocol
{
    public typealias     ClientType = PlatformEnum<Microsoft .ClientType, Google .ClientType>
    public typealias    AccountType = PlatformEnum<Microsoft.AccountType, Google.AccountType>
    
    public var client: ClientType {
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
}

// MARK: - MailFolder

extension PlatformEnum : MailFolderProtocol where
    Microsoft : MailFolderProtocol,
       Google : MailFolderProtocol,
    Microsoft.GeneralID == MailFolderID,
       Google.GeneralID == MailFolderID
{
    public var name: String? {
        switch self {
        case .microsoft(let platform): platform.name
        case    .google(let platform): platform.name
        }
    }
    
    public var systemName: MailFolderSystemName? {
        switch self {
        case .microsoft(let platform): platform.systemName
        case    .google(let platform): platform.systemName
        }
    }
}


// MARK: - Message

extension PlatformEnum : MessageProtocol where
    Microsoft : MessageProtocol,
       Google : MessageProtocol,
    Microsoft.GeneralID == MessageID,
       Google.GeneralID == MessageID
{
    
    private subscript<Value>(platform keyPath: KeyPath<any MessageProtocol, Value>) -> Value {
        switch self {
        case .microsoft(let platform): platform[keyPath: keyPath]
        case    .google(let platform): platform[keyPath: keyPath]
        }
    }
    
    public var      subject: String?      { self[platform: \.subject     ] }
    
    public var         from: String?      { self[platform: \.from        ] }
    public var       sender: String?      { self[platform: \.sender      ] }
    public var      replyTo: String?      { self[platform: \.replyTo     ] }
    
    // MARK: Resource - Destination Address Fields

    public var           to: String?      { self[platform: \.to          ] }
    public var           cc: String?      { self[platform: \.cc          ] }
    public var          bcc: String?      { self[platform: \.bcc         ] }

    // MARK: Resource - Date

    public var         date: Date?        { self[platform: \.date        ] }

    // MARK: Resource - Headers

    public var      headers: [MessageHeader]? { self[platform: \.headers      ] }
    
    // MARK: Resource - Body & Raw
    
    public var  bodyPreview: String?          { self[platform: \.bodyPreview ] }
    public var         body: MessageBody?     { self[platform: \.body        ] }
    public var          raw: Data?            { self[platform: \.raw         ] }
}

// MARK: - Session API

extension PlatformEnum : ClientSessionAPI where 
    Microsoft : ClientSessionAPI,
       Google : ClientSessionAPI
{
    public typealias ClientSessionType = PlatformEnum<Microsoft.ClientSessionType, Google.ClientSessionType>
    
    public var sessions: [ClientSessionType] { get async throws {
        switch self {
        case .microsoft(let client): try await client.sessions.map(ClientSessionType.microsoft)
        case    .google(let client): try await client.sessions.map(ClientSessionType.google   )
        }
    } }
    
    public func signIn() async throws -> ClientSessionType  {
        switch self {
        case .microsoft(let client): try await .microsoft(client.signIn())
        case    .google(let client): try await    .google(client.signIn())
       
        }
    }
}

extension PlatformEnum: SessionAPIProtocol where
    Microsoft : SessionAPIProtocol,
       Google : SessionAPIProtocol
//Microsoft.ModelStoreType == Google.ModelStoreType
{
    @MainActor
    public func signOut() async throws -> Self {
        switch self {
        case .microsoft(let session): return try await  .microsoft(session.signOut())
        case    .google(let session): return try await     .google(session.signOut())
        }
    }
    

    
    public var refresh: Self { get async throws {
        switch self {
        case .microsoft(let session): return .microsoft(try await session.refresh)
        case .google   (let session): return    .google(try await session.refresh)
        }
    } }
}

@MainActor
extension PlatformEnum : AccountIDSessionAPI where
Microsoft : AccountIDSessionAPI,
   Google : AccountIDSessionAPI
{
    public typealias AccountIDSessionType = PlatformEnum<Microsoft.AccountIDSessionType, Google.AccountIDSessionType>
    
    public var storedSession: AccountIDSessionType? {
        switch self {
        case .microsoft(let id): id.storedSession.map(AccountIDSessionType.microsoft)
        case    .google(let id): id.storedSession.map(AccountIDSessionType.google)
        }
    }
    
    public var refreshSession: AccountIDSessionType { get async throws {
        switch self {
        case .microsoft(let id): try await .microsoft(id.refreshSession)
        case    .google(let id): try await    .google(id.refreshSession)
        }
    } }
    
    public func removeSession() -> AccountIDSessionType? {
        switch self {
        case .microsoft(let id): id.removeSession().map(AccountIDSessionType.microsoft)
        case    .google(let id): id.removeSession().map(AccountIDSessionType.google)
        }
    }
}

// MARK: - Rest API

extension PlatformEnum: RestAPIProtocol where
    Microsoft : RestAPIProtocol,
       Google : RestAPIProtocol,
    Microsoft.MailFolderType.ID == MicrosoftMailFolderID,
       Google.MailFolderType.ID ==    GoogleMailFolderID,
    Microsoft   .MessageType.ID ==    MicrosoftMessageID,
       Google   .MessageType.ID ==       GoogleMessageID
//Microsoft.ModelStoreType == Google.ModelStoreType
{
    public typealias MailFolderType = PlatformEnum<Microsoft.MailFolderType,  Google.MailFolderType>
    public typealias    MessageType = PlatformEnum<Microsoft   .MessageType,  Google   .MessageType>
    
    
    
    // MARK: account - mailFolders
    
    public func rootMailFolder() async throws -> MailFolderType {
        checkBackgroundThread()
        switch self {
        case .microsoft(let session): return .microsoft(try await session.rootMailFolder())
        case    .google(let session): return    .google(try await session.rootMailFolder())
        }
    }
    
    public func loadMailFoldersUnderRoot(root: MailFolderType, modelStore: ModelStore) async throws {
        checkBackgroundThread()
        switch self {
        case .microsoft(let session): try await session.loadMailFoldersUnderRoot(root: root.microsoft, modelStore: modelStore)
        case    .google(let session): try await session.loadMailFoldersUnderRoot(root: root.google   , modelStore: modelStore)
        }
    }
    
    // MARK: mailFolder - messages

    public func syncMessages(mailFolderID: MailFolderID, modelStore: ModelStore) async throws {
        checkBackgroundThread()
        switch self {
        case .microsoft(let session): try await session.syncMessages(mailFolderID: mailFolderID.microsoft, modelStore: modelStore)
        case    .google(let session): try await session.syncMessages(mailFolderID: mailFolderID.google   , modelStore: modelStore)
        }
    }
    
    // MARK: message
    
    public func moveMessage(messageID: MessageID, fromID: MailFolderID, toID: MailFolderID) async throws -> MessageType {
        checkBackgroundThread()
        return switch self {
        case .microsoft(let session): .microsoft(try await session.moveMessage(messageID: messageID.microsoft, fromID: fromID.microsoft, toID: toID.microsoft))
        case    .google(let session): .google(try await session.moveMessage(messageID: messageID.google   , fromID: fromID.google   , toID: toID.google   ))
        }
    }
    
    public func messageBody(messageID: MessageID) async throws -> MessageType {
        checkBackgroundThread()
        return switch self {
        case .microsoft(let session): .microsoft(try await session.messageBody(messageID: messageID.microsoft))
        case    .google(let session):    .google(try await session.messageBody(messageID: messageID.google   ))
        }
    }
}
