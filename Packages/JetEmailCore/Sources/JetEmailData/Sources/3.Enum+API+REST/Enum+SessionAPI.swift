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
    associatedtype     ClientType
    associatedtype  AccountIDType: Sendable
    associatedtype    AccountType: AccountProtocol    where    AccountType.ID : Sendable
    associatedtype MailFolderType: MailFolderProtocol where MailFolderType.ID : Sendable
    associatedtype    MessageType: MessageProtocol    where    MessageType.ID : Sendable
    
    // sessions
    var client: ClientType { get }
    var account: AccountType { get }
    
    var refresh: Self { get async throws }
    
    //@SessionActor
    @MainActor
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
    Microsoft  .AccountType.GeneralID == AccountID,
       Google  .AccountType.GeneralID == AccountID,
    Microsoft .AccountIDType ==     MicrosoftAccountID,
       Google .AccountIDType ==        GoogleAccountID,
    Microsoft.MailFolderType.ID == MicrosoftMailFolderID,
       Google.MailFolderType.ID ==    GoogleMailFolderID,
    Microsoft   .MessageType.ID ==    MicrosoftMessageID,
       Google   .MessageType.ID ==       GoogleMessageID
//Microsoft.ModelStoreType == Google.ModelStoreType
{
    public var client: PlatformEnum<Microsoft.ClientType, Google.ClientType> {
        switch self {
        case .microsoft(let session): .microsoft(session.client)
        case    .google(let session):    .google(session.client)
        }
    }
    
    public typealias     ClientType = PlatformEnum<Microsoft   .ClientType,  Google      .ClientType>
    public typealias  AccountIDType = PlatformEnum<Microsoft   .AccountIDType,  Google   .AccountIDType>
    public typealias    AccountType = PlatformEnum<Microsoft   .AccountType   , Google   .AccountType  >
    public typealias MailFolderType = PlatformEnum<Microsoft.MailFolderType   , Google.MailFolderType  >
    public typealias    MessageType = PlatformEnum<Microsoft   .MessageType   , Google   .MessageType  >

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
    
    @MainActor
    public func signOut() async throws -> Self {
        switch self {
        case .microsoft(let session): return try await  .microsoft(session.signOut())
        case    .google(let session): return try await     .google(session.signOut())
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

public enum SessionError : Error {
    case idNotForThePlatform
    case noSession
}


