//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/12/24.
//


public protocol SessionProtocol<AccountType> {
    associatedtype AccountType: AccountProtocol
    associatedtype MailFolderType: MailFolderProtocol
    //associatedtype ModelStoreType
    var account: AccountType { get }
    // var refresh: Self { get async throws }
    func signOut() async throws -> Self
    
    func loadMessagesProgressing<ModelStore: ModelStoreProtocol & Sendable>(mailFolderID: MailFolderID, modelStore: ModelStore) async throws
    func loadMailFoldersUnderRoot<ModelStore: ModelStoreProtocol & Sendable>(rootMailFolderResource: MailFolderType, accountID: AccountID, modelStore: ModelStore) async throws
    func getRootMailFolder() async throws -> MailFolderType
    func loadBody<ModelStore: ModelStoreProtocol & Sendable>(messageID: MessageID, modelStore: ModelStore) async throws
    func moveMessage(messageID: MessageID, fromID: MailFolderID, toID: MailFolderID) async throws
}

extension PlatformEnum: SessionProtocol where
    Microsoft : SessionProtocol,
       Google : SessionProtocol,
    Microsoft.AccountType.GeneralID == AccountID,
       Google.AccountType.GeneralID == AccountID
//Microsoft.ModelStoreType == Google.ModelStoreType
{
    public typealias AccountType = PlatformEnum<Microsoft.AccountType, Google.AccountType>
    public typealias MailFolderType = PlatformEnum<Microsoft.MailFolderType, Google.MailFolderType>

    //public typealias ModelStoreType = Microsoft.ModelStoreType
    
    public var account: AccountType {
        switch self {
        case .microsoft(let session): .microsoft(session.account)
        case    .google(let session):    .google(session.account)
        }
    }
    
    public func signOut() async throws -> Self {
        switch self {
        case .microsoft(let session): try await  .microsoft(session.signOut())
        case    .google(let session): try await     .google(session.signOut())
        }
    }
    
   public func loadMessagesProgressing<ModelStore: ModelStoreProtocol & Sendable>(mailFolderID: MailFolderID, modelStore: ModelStore) async throws {
        switch self {
        case .microsoft(let session): try await session.loadMessagesProgressing(mailFolderID: mailFolderID, modelStore: modelStore)
        case    .google(let session): try await session.loadMessagesProgressing(mailFolderID: mailFolderID, modelStore: modelStore)
        }
    }
    
    /*public var refresh: Self { get async throws {
        switch self {
        case .microsoft(let session): return .microsoft(try await session.refresh)
        case .google   (let session): return    .google(try await session.refresh)
        }
    } }*/
    

    
    public func getRootMailFolder() async throws -> MailFolderType {
        switch self {
        case .microsoft(let session): return .microsoft(try await session.getRootMailFolder())
        case    .google(let session): return    .google(try await session.getRootMailFolder())
        }
    }
    
    public func loadMailFoldersUnderRoot<ModelStore: ModelStoreProtocol & Sendable>(rootMailFolderResource: MailFolderType, accountID: AccountID, modelStore: ModelStore) async throws {
        switch self {
        case .microsoft(let session):
            guard let rootMailFolderResource = rootMailFolderResource.microsoft else { return }
            try await session.loadMailFoldersUnderRoot(rootMailFolderResource: rootMailFolderResource, accountID: accountID, modelStore: modelStore)
        case    .google(let session):
            guard let rootMailFolderResource = rootMailFolderResource.google else { return }
            try await session.loadMailFoldersUnderRoot(rootMailFolderResource: rootMailFolderResource, accountID: accountID, modelStore: modelStore)
        }
    }
    
    
    public func loadMailFolders<ModelStore: ModelStoreProtocol & Sendable>(accountID: AccountID, modelStore: ModelStore) async throws -> MailFolderType {
        let rootMailFolderResource = try await getRootMailFolder()                                  // Session
        _ = try await modelStore.setRootMailFolder(resource: rootMailFolderResource, accountID: accountID)  // ModelStore
        
        try await loadMailFoldersUnderRoot(rootMailFolderResource: rootMailFolderResource, accountID: accountID, modelStore: modelStore)
        _ = await Task { @MainActor in
            accountID.loadedMailFolder = true
        }.value
        return rootMailFolderResource
    }
    
    public func loadBody<ModelStore: ModelStoreProtocol & Sendable>(messageID: MessageID, modelStore: ModelStore) async throws {
        switch self {
        case .microsoft(let session): _ = try await session.loadBody(messageID: messageID, modelStore: modelStore)
        case    .google(let session): _ = try await session.loadBody(messageID: messageID, modelStore: modelStore)
        }
    }
    
    public func moveMessage(messageID: MessageID, fromID: MailFolderID, toID: MailFolderID) async throws {
        switch self {
        case .microsoft(let session): try await session.moveMessage(messageID: messageID, fromID: fromID, toID: toID)
        case    .google(let session): try await session.moveMessage(messageID: messageID, fromID: fromID, toID: toID)
        }
    }
}
