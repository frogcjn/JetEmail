//
//  ModelContext+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import Foundation
import SwiftData // for ModelContainer
import JetEmailFoundation
import os

@ModelActor
public actor ModelStore : ModelStoreProtocol {
    

    let logger = Logger(subsystem: "me.frogcjn.jet-email.ModelStore", category: "ModelStore")
}

enum ModelStoreError : Error {
    case notFound
}

// MARK: - Fetch #Predicate - ID

public extension ModelContext {
    /*subscript<Model: DataModel>(id: UnifiedID<Model>) -> Model? { get throws { // TODO: WWDC2024
        let uniqueID = id.rawValue
        return try? fetch(.init(predicate: #Predicate<Model> { $0.uniqueID == uniqueID })).first // Error,  keypath could not figure right, since it is from protocol key path
    } }*/
    
    subscript(accountID: AccountID) -> Account { get throws {
        let uniqueID = accountID.uniqueID
        let first = try fetch(.init(predicate: #Predicate<Account>    { $0.uniqueID == uniqueID })).first
        guard let first else { throw ModelStoreError.notFound }
        return first
    } }
    
    subscript(mailFolderID: MailFolderID) -> MailFolder { get throws {
        let uniqueID = mailFolderID.uniqueID
        //var fetchDescriptor = FetchDescriptor(predicate: #Predicate<MailFolder>    { $0.uniqueID == uniqueID })
        // fetchDescriptor.relationshipKeyPathsForPrefetching = [\.account, \._messages]
        let first = try fetch(.init(predicate: #Predicate<MailFolder>    { $0.uniqueID == uniqueID })).first
        guard let first else { throw ModelStoreError.notFound }
        return first 
    } }
    
    subscript(messageID: MessageID) -> Message { get throws {
        let uniqueID = messageID.uniqueID
        let first = try fetch(.init(predicate: #Predicate<Message>    { $0.uniqueID == uniqueID })).first
        guard let first else { throw ModelStoreError.notFound }
        return first
    } }
}

/*fileprivate extension ModelStore {
    subscript(accountID: AccountID) -> Account { get throws {
        try modelContext[accountID]
    } }
    
    subscript(mailFolderID: MailFolderID) -> MailFolder { get throws {
        try modelContext[mailFolderID]
    } }
    
    subscript(messageID: MessageID) -> Message { get throws {
        try modelContext[messageID]
    } }
}*/

// MARK: - Fetch #Predicate - Others

fileprivate extension ModelContext {
    func _fetchAccountCount() throws -> Int {
        try fetchCount(.init(predicate: #Predicate<Account> { !$0.deleteMark }))
    }
    
    func _fetchAccounts() throws -> [Account] {
        try fetch(.init(predicate: #Predicate<Account> { !$0.deleteMark }, sortBy: [.init(\.orderIndex, order: .forward)]))
    }
    
    func _fetchAccountNotIn(_ scope: [Account]) throws -> [Account] {
        let scope = scope.map(\.uniqueID)
        return try fetch(.init(predicate: #Predicate<Account> { !$0.deleteMark && !scope.contains($0.uniqueID) }))
    }
    
    func _fetchMailFolderNotIn(_ scope: [MailFolder], parent: MailFolder) throws -> [MailFolder] {
        let scope = scope.map(\.uniqueID)
        let parent = parent.uniqueID
        return try fetch(.init(predicate: #Predicate<MailFolder> { !$0.deleteMark && !scope.contains($0.uniqueID) && $0.parent?.uniqueID == parent }))
    }
    
    // MARK: - Insert
    
    func _insertAccount<AccountResource: AccountProtocol>(resource: AccountResource) throws -> Account {
        // find existed
        do {
            let model = try self[resource.generalID]
            
            // If deleteMark: recover
            if model.deleteMark {
                model.orderIndex = try _fetchAccountCount()
                model.deleteMark = false
            }
            return model
        } catch ModelStoreError.notFound {
            
            // If not found: create
            let model = Account(resource: resource)
            model.orderIndex = try _fetchAccountCount()
            model.deleteMark = false
            insert(model)
            return model
        }
    }
    
    func _insertMailFolder<MailFolderResource : MailFolderProtocol>(resource: MailFolderResource, account: Account) throws -> MailFolder {
        let id = resource.generalID
        
        // find existed
        do {
            let model = try self[id]
            
            // If found: update
            model.deleteMark = false
            model.update(resource: resource)
            model.account = account
            return model
        } catch ModelStoreError.notFound {
            
            // If not found: create
            let model = MailFolder(resource: resource, account: account)
            insert(model)
            return model
        }
    }
    
    func _insertMailFolder<MailFolderResource: MailFolderProtocol>(resource: MailFolderResource, parent: MailFolder, account: Account) throws -> MailFolder {
        // check account.root
        guard account.root != nil else { throw TreeError.accountDoNotHaveRootFolder }
        
        // insert before check relationship
        let folderID = try _insertMailFolder(resource: resource, account: account)
        let folder = try self[folderID.resourceID]

        // check parent and folder account
        guard parent.account == account else { throw TreeError.parentMailFolderNotInThisAccount }
        guard folder.account == account else { throw TreeError.mailFolderNotInThisAccount }
        
        // check node.parent
        // if folder.parent != nil && folder.parent != parent { throw TreeError.mailFolderAlreadyHaveParent } // Microsoft may need this line
        folder.parent = parent
        
        // check node.children
        // guard node.children.isEmpty else { throw TreeError.alreadyHaveChild }
        
        return folder
    }
    
    
    func _insertMessage<MessageResource: MessageProtocol>(resource: MessageResource, mailFolder: MailFolder) throws -> Message {
        let id = resource.generalID

        // find existed
        do {
            let model = try self[id]
            
            // If found: update
            model.deleteMark = false
            model.update(resource: resource)
            model.account = mailFolder.account
            model.mailFolders.append(mailFolder)
            return model
        } catch ModelStoreError.notFound {
            
            // If not found: create
            let model = Message(resource: resource, account: mailFolder.account)
            insert(model)
            model.mailFolders.append(mailFolder)
            return model
        }
    }
    
    // MARK: - Delete
    
    func _deleteModel(_ model: Account) throws -> Account {
        model.deleteMark = true
        return model
    }
    
    func _deleteModel(_ model: MailFolder) throws -> MailFolder {
        model.deleteMark = true
        return model
    }
    
    func _deleteModel(_ model: Message) throws -> Message {
        model.deleteMark = true
        return model
    }
}

public extension ModelStore {
    
    // MARK: - Accounts
    
    // loadAccounts
    func setAccounts<AccountResource: AccountProtocol>(_ accounts: [AccountResource]) async throws -> (inserts: [AccountID], delete: [AccountID]) {
        checkBackgroundThread()
        
        var inserts   = [Account]()
        var removings = [Account]()
        
        try modelContext.transaction {
            // inserts
            inserts = try accounts.map(modelContext._insertAccount(resource:))
            
            // others: not have
            removings = try modelContext._fetchAccountNotIn(inserts)
            try removings.forEach { _ = try modelContext._deleteModel($0) }
        }
        return (inserts.map(\.resourceID), removings.map(\.resourceID))
    }
       
    // signIn
    func insertAccount<AccountResource: AccountProtocol>(_ account: AccountResource) async throws -> AccountID {
        checkBackgroundThread()
        var accountID: AccountID!
        try modelContext.transaction {
            accountID = try modelContext._insertAccount(resource: account).resourceID
        }
        return accountID
    }
        
    // signOut
    func deleteAccount(accountID: AccountID) throws -> AccountID {
        checkBackgroundThread()
        let account = try modelContext[accountID]
        try modelContext.transaction {
            _ = try modelContext._deleteModel(account)
            account.orderIndex = nil
            
            // reorder
            let accounts = try modelContext._fetchAccounts()
            for (index, item) in accounts.enumerated() {
                item.orderIndex = index
            }
        }
        return accountID
    }
    
    // move account
    func moveAccounts(accountIDs: [AccountID], fromOffsets source: IndexSet, toOffset destination: Int) throws -> [Account.ResourceID] {
        checkBackgroundThread()
        
        // contacts.move(fromOffsets: from, toOffset: to)
        // Make a copy of the current list of items
        var accounts = try accountIDs.map { try modelContext[$0] }
        
        // Apply the move operation to the items
        accounts.move(fromOffsets: source, toOffset: destination)
        
        try modelContext.transaction {
            
            // Update each item's relative index order based on the new items
            // Can extract and reuse this part if the order of the items is changed elsewhere (like when deleting items)
            // The iteration could be done in reverse to reduce changes to the indices but isn't necessary
            for (index, item) in accounts.filter({ !$0.deleteMark }).enumerated() {
                item.orderIndex = index
            }
            for item in accounts.filter({ $0.deleteMark }) {
                item.orderIndex = nil
            }
        }
        return accounts.map(\.resourceID)
    }
    
    // MARK: - Account-Mailfolders
    
    
    
    // loadMailFolders
    func setRootMailFolder<MailFolderResource : MailFolderProtocol>(resource: MailFolderResource, accountID: AccountID) throws -> MailFolderID {
        let account = try modelContext[accountID]
        var mailFolder: MailFolder!
        try modelContext.transaction {
            mailFolder = try modelContext._insertMailFolder(resource: resource, account: account)
            account.root = mailFolder // set root mail folder relation on main
        }
        return mailFolder.resourceID
    }
    
    

    // loadMailFolders
    func setChildrenMailFolders<MailFolderResource : MailFolderProtocol>(resources: [MailFolderResource], parentID: MailFolderID, accountID: AccountID) throws -> [MailFolderID] where MailFolderResource : JetEmailData.MailFolderProtocol {
        let parent =  try modelContext[parentID]
        let account = try modelContext[accountID]
        
        var inserts = [MailFolder]()
        try modelContext.transaction {
            for resource in resources {
                try inserts.append(modelContext._insertMailFolder(resource: resource, parent: parent, account: account))
            }
            
            // inserts order
            inserts = inserts.sortedChildren
            for (index, insert) in inserts.enumerated() {
                insert._childIndex = index
            }
            
            // delete
            let deletings = try modelContext._fetchMailFolderNotIn(inserts, parent: parent)
            try deletings.forEach {
                $0._childIndex = nil
                _ = try modelContext._deleteModel($0)
            }
        }
        return inserts.map { $0.resourceID }
    }
    
    // MARK: - MailFolder-Messages
    
    // loadMessages
    func setMessagesDeletePart(newMessageIDs: [MessageID], mailFolderID: MailFolderID) async throws -> [(offset: Int,  element: MessageID)] {
        checkBackgroundThread()
                
        let oldMessages =  try modelContext[mailFolderID]._messages.filter { !$0.deleteMark }/* Set(try modelContext._fetchMessages(mailFolderID: mailFolderID))*/
        
        let newMessageIDSet = Set(newMessageIDs)
        let oldMessageIDSet = Set(oldMessages.map(\.resourceID))

        let deletingIDSet = oldMessageIDSet.subtracting(newMessageIDSet)
        let   insertIDSet = newMessageIDSet.subtracting(oldMessageIDSet)
        
        try modelContext.transaction {
            let deletings = oldMessages.filter { deletingIDSet.contains($0.resourceID) }
            try deletings.forEach { _ = try modelContext._deleteModel($0) }
        }
        
        let enumeratedInsertIDs = newMessageIDs.enumerated().filter { insertIDSet.contains($0.element) }
        return enumeratedInsertIDs
    }
    
    // loadMessages
    func setMessagesInsertPart<MessageResource>(resources: [MessageResource], mailFolderID: MailFolderID) throws -> [MessageID] where MessageResource : JetEmailData.MessageProtocol {
        checkBackgroundThread()
        let mailFolder = try modelContext[mailFolderID]
        
        var inserts = [Message]()
        try modelContext.transaction {
            try resources.forEach { resource in
                try inserts.append(modelContext._insertMessage(resource: resource, mailFolder: mailFolder))
            }
        }
        return inserts.map(\.resourceID)
    }
    
    // moveMessages
    func moveMessage(messageID: MessageID, fromID: MailFolderID, toID: MailFolderID) throws {
        let message = try modelContext[messageID]
        let from    = try modelContext[fromID]
        let to      = try modelContext[toID]
        try modelContext.transaction {
            var fromMessages = from._messages
            fromMessages.removeAll { $0 == message }
            from._messages = fromMessages
            
            var toMessages = to._messages
            toMessages.append(message)
            to._messages = toMessages
        }
    }
    
    // MARK: - Message
    
    // load body
    func setMessage<MessageResource: MessageProtocol>(resource: MessageResource, messageID: MessageID) throws -> MessageID {
        checkBackgroundThread()
        let message = try modelContext[messageID]
        try modelContext.transaction {
            message.update(resource: resource)
        }
        return message.resourceID
    }
}

public extension ModelContext {
    @MainActor
    func moveMessage(message: Message, from: MailFolder, to: MailFolder) throws {
        try transaction {
            var moveFromMessages = from._messages
            moveFromMessages.removeAll { $0.uniqueID == message.uniqueID }
            from._messages = moveFromMessages
            
            var moveToMessages = to._messages
            moveToMessages.append(message)
            to._messages = moveToMessages
        }
    }
}
