//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/12/24.
//


/*@globalActor
public actor SessionActor {
    public static var shared: SessionActor = SessionActor()
}*/

import SwiftData

public protocol SessionProtocol<AccountType> {
    associatedtype  AccountIDType: Sendable
    associatedtype    AccountType: AccountProtocol    where    AccountType.ID : Sendable
    associatedtype MailFolderType: MailFolderProtocol where MailFolderType.ID : Sendable
    associatedtype    MessageType: MessageProtocol    where    MessageType.ID : Sendable

    @MainActor
    static func  storedSession(accountID: AccountIDType)              -> Self?
    
    @MainActor
    static func refreshSession(accountID: AccountIDType) async throws -> Self?
    
    @MainActor
    static func  removeSession(accountID: AccountIDType)              -> Self?
    
    // sessions
    var account: AccountType { get }
    var refresh: Self { get async throws }
    
    //@SessionActor
    func signOut() async throws -> Self
    
    // account - mailFolders
    //@SessionActor
    func rootMailFolder() async throws -> MailFolderType
    
    //@SessionActor
    func loadMailFoldersUnderRoot(root: MailFolderType, modelStore: ModelStore) async throws

    // mailFolder - messages
    //@SessionActor
    
    func syncMessages(mailFolderID: MailFolderType.ID, modelStore: ModelStore) async throws
    
    
    /*@MainActor
    func loadMessagesMain(mailFolderID: MailFolderType.ID, modelContext: ModelContext) async throws*/
    
    //@SessionActor
    func moveMessage(messageID: MessageType.ID, fromID: MailFolderType.ID, toID: MailFolderType.ID) async throws -> MessageType

    // message
    //@SessionActor
    func messageBody(messageID: MessageType.ID) async throws -> MessageType
}


extension PlatformEnum: SessionProtocol where
    Microsoft : SessionProtocol,
       Google : SessionProtocol,
    Microsoft.AccountType.GeneralID == AccountID,
       Google.AccountType.GeneralID == AccountID,
   Microsoft.AccountIDType ==     MicrosoftAccountID,
      Google.AccountIDType ==        GoogleAccountID,
Microsoft.MailFolderType.ID == MicrosoftMailFolderID,
   Google.MailFolderType.ID ==    GoogleMailFolderID,
Microsoft   .MessageType.ID ==    MicrosoftMessageID,
   Google   .MessageType.ID ==       GoogleMessageID
//Microsoft.ModelStoreType == Google.ModelStoreType
{
    public typealias  AccountIDType = PlatformEnum<Microsoft   .AccountIDType,  Google   .AccountIDType>
    public typealias    AccountType = PlatformEnum<Microsoft   .AccountType   , Google   .AccountType  >
    public typealias MailFolderType = PlatformEnum<Microsoft.MailFolderType   , Google.MailFolderType  >
    public typealias    MessageType = PlatformEnum<Microsoft   .MessageType   , Google   .MessageType  >

    // sessions
    
    @MainActor
    public static func storedSession(accountID: AccountIDType) -> Self? {
        switch accountID {
        case .microsoft(let accountID): Microsoft.storedSession(accountID: accountID).map(Self.microsoft)
        case    .google(let accountID):    Google.storedSession(accountID: accountID).map(Self.google)
        }
    }
    
    @MainActor
    public static func refreshSession(accountID: AccountIDType) async throws -> Self? {
        switch accountID {
        case .microsoft(let accountID): try await Microsoft.refreshSession(accountID: accountID).map(Self.microsoft)
        case    .google(let accountID): try await    Google.refreshSession(accountID: accountID).map(Self.google)
        }
    }
    
    @MainActor
    public static func removeSession(accountID: AccountIDType) -> Self? {
        switch accountID {
        case .microsoft(let accountID): Microsoft.removeSession(accountID: accountID).map(Self.microsoft)
        case    .google(let accountID):    Google.removeSession(accountID: accountID).map(Self.google)
        }
    }

    public var account: AccountType {
        switch self {
        case .microsoft(let session): .microsoft(session.account)
        case    .google(let session):    .google(session.account)
        }
    }
    
    public var refresh: Self { get async throws {
        switch self {
        case .microsoft(let session): return .microsoft(try await session.refresh)
        case .google   (let session): return    .google(try await session.refresh)
        }
    } }
    
    
    public func signOut() async throws -> Self {
        checkBackgroundThread()
        switch self {
        case .microsoft(let session): return try await  .microsoft(session.signOut())
        case    .google(let session): return try await     .google(session.signOut())
        }
    }
    
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
        case .microsoft(let session):
            guard let rootMailFolder = root.microsoft else { return }
            try await session.loadMailFoldersUnderRoot(root: rootMailFolder, modelStore: modelStore)
        case    .google(let session):
            guard let rootMailFolder = root.google else { return }
            try await session.loadMailFoldersUnderRoot(root: rootMailFolder, modelStore: modelStore)
        }
    }
    
    // mailFolder - messages

    public func syncMessages(mailFolderID: MailFolderID, modelStore: ModelStore) async throws {
        checkBackgroundThread()
        switch self {
        case .microsoft(let session):
            guard let mailFolderID = mailFolderID.microsoft else { throw SessionError.idNotForThePlatform }
            try await session.syncMessages(mailFolderID: mailFolderID, modelStore: modelStore)
        case    .google(let session):
            guard let mailFolderID = mailFolderID.google else { throw SessionError.idNotForThePlatform }
            try await session.syncMessages(mailFolderID: mailFolderID, modelStore: modelStore)
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
        switch self {
        case .microsoft(let session): 
            guard 
                let messageID = messageID.microsoft,
                let    fromID =    fromID.microsoft,
                let      toID =      toID.microsoft
            else { throw SessionError.idNotForThePlatform }
            return .microsoft(try await session.moveMessage(messageID: messageID, fromID: fromID, toID: toID))
        case    .google(let session):
            guard
                let messageID = messageID.google,
                let    fromID =    fromID.google,
                let      toID =      toID.google
            else { throw SessionError.idNotForThePlatform }
            return .google(try await session.moveMessage(messageID: messageID, fromID: fromID, toID: toID))
        }
    }
    
    // message

    public func messageBody(messageID: MessageID) async throws -> MessageType {
        checkBackgroundThread()
        switch self {
        case .microsoft(let session): 
            guard let messageID = messageID.microsoft else { throw SessionError.idNotForThePlatform }
            return .microsoft(try await session.messageBody(messageID: messageID))
        case    .google(let session): 
            guard let messageID = messageID.google else { throw SessionError.idNotForThePlatform  }
            return .google(try await session.messageBody(messageID: messageID))
        }
    }
}

enum SessionError : Error {
    case idNotForThePlatform
}


