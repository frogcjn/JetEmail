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

public protocol SessionProtocol<AccountType> {
    associatedtype AccountType: AccountProtocol
    associatedtype MailFolderType: MailFolderProtocol
    associatedtype MessageType: MessageProtocol

    // sessions
    var account: AccountType { get }
    var refresh: Self { get async throws }
    
    //@SessionActor
    func signOut() async throws -> Self
    
    // account - mailFolders
    //@SessionActor
    func getRootMailFolder() async throws -> MailFolderType
    
    //@SessionActor
    func loadMailFoldersUnderRoot(root: MailFolderType, modelStore: ModelStore) async throws

    // mailFolder - messages
    //@SessionActor
    func loadMessages(mailFolderID: MailFolderType.ID, modelStore: ModelStore) async throws
    
    //@SessionActor
    func moveMessage(messageID: MessageType.ID, fromID: MailFolderType.ID, toID: MailFolderType.ID) async throws

    // message
    //@SessionActor
    func getMessageBody(messageID: MessageType.ID) async throws -> MessageType
}


extension PlatformEnum: SessionProtocol where
    Microsoft : SessionProtocol,
       Google : SessionProtocol,
    Microsoft.AccountType.GeneralID == AccountID,
       Google.AccountType.GeneralID == AccountID,
Microsoft.MailFolderType.ID == MicrosoftMailFolderID,
   Google.MailFolderType.ID ==    GoogleMailFolderID,
Microsoft   .MessageType.ID == MicrosoftMessageID,
   Google   .MessageType.ID ==    GoogleMessageID
//Microsoft.ModelStoreType == Google.ModelStoreType
{
    public typealias    AccountType = PlatformEnum<Microsoft   .AccountType, Google   .AccountType>
    public typealias MailFolderType = PlatformEnum<Microsoft.MailFolderType, Google.MailFolderType>
    public typealias    MessageType = PlatformEnum<Microsoft   .MessageType, Google   .MessageType>

    // sessions

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
    
    public func getRootMailFolder() async throws -> MailFolderType {
        checkBackgroundThread()
        switch self {
        case .microsoft(let session): return .microsoft(try await session.getRootMailFolder())
        case    .google(let session): return    .google(try await session.getRootMailFolder())
        }
    }
    
    //@SessionActor
    public func loadMailFolders(modelStore: ModelStore) async throws -> MailFolderType {
        checkBackgroundThread()
        let rootMailFolder = try await getRootMailFolder()                                  // Session
        _ = try await modelStore.setRootMailFolder(resource: rootMailFolder, accountID: account.id)  // ModelStore
        
        try await loadMailFoldersUnderRoot(root: rootMailFolder, modelStore: modelStore)
        return rootMailFolder
    }
    
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

    
    public func loadMessages(mailFolderID: MailFolderID, modelStore: ModelStore) async throws {
        checkBackgroundThread()
        switch self {
        case .microsoft(let session): 
            guard let mailFolderID = mailFolderID.platformCase?.microsoft else { return }
            try await session.loadMessages(mailFolderID: mailFolderID, modelStore: modelStore)
        case    .google(let session):
            guard let mailFolderID = mailFolderID.platformCase?.google else { return }
            try await session.loadMessages(mailFolderID: mailFolderID, modelStore: modelStore)
        }
    }
    
    public func moveMessage(messageID: MessageID, fromID: MailFolderID, toID: MailFolderID) async throws {
        checkBackgroundThread()
        switch self {
        case .microsoft(let session): 
            guard 
                let messageID = messageID.platformCase?.microsoft,
                let    fromID =    fromID.platformCase?.microsoft,
                let      toID =      toID.platformCase?.microsoft
            else { return }
            try await session.moveMessage(messageID: messageID, fromID: fromID, toID: toID)
        case    .google(let session):
            guard
                let messageID = messageID.platformCase?.google,
                let    fromID =    fromID.platformCase?.google,
                let      toID =      toID.platformCase?.google
            else { return }
            try await session.moveMessage(messageID: messageID, fromID: fromID, toID: toID)
        }
    }
    
    // message

    public func getMessageBody(messageID: MessageID) async throws -> MessageType {
        checkBackgroundThread()
        switch self {
        case .microsoft(let session): 
            guard let messageID = messageID.platformCase?.microsoft else { throw SessionError.idNotForThePlatform }
            return .microsoft(try await session.getMessageBody(messageID: messageID))
        case    .google(let session): 
            guard let messageID = messageID.platformCase?.google else { throw SessionError.idNotForThePlatform  }
            return .google(try await session.getMessageBody(messageID: messageID))
        }
    }
}

enum SessionError : Error {
    case idNotForThePlatform
}