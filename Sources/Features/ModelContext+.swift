//
//  ModelContext+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import Foundation
import SwiftData // for ModelContainer
import JetEmail_Foundation


@ModelActor
public actor ModelStore {
}

extension ModelContext {
    subscript<T: PersistentModel>(id: PersistentID<T>) -> T? {
        model(for: id.rawValue) as? T
    }
    var modelContainer: ModelContainer { self.container }
    public var context: ModelContext {
        self
    }
}

/*
protocol AppStorage {
    func setSessions(_ sessions: [Session]) async throws -> [Account.PersistentID]
    nonisolated var modelContainer: ModelContainer { get }
}

extension AppStorage {
    public var context: ModelContext { fatalError() }
    
    
}*/

extension ModelStore {
        
    subscript<T: PersistentModel>(id: PersistentID<T>) -> T? {
        self[id.rawValue ,as: T.self]
    }
    
    /*func moveAccounts(_ accounts: [Account], fromOffsets source: IndexSet, toOffset destination: Int) throws -> [Account] {
        try modelContext.moveAccounts(accounts, fromOffsets: source, toOffset: destination)
    }*/

    /*func setRootMailFolder(microsoft: Microsoft.MailFolder, in accountID: Account.ModelID) async throws -> MailFolder.ModelID {
        try await modelContext.setRootMailFolder(microsoft: microsoft, in: accountID)
    }
    
    func setChildrenMailFolders(microsofts: [Microsoft.MailFolder], parentID: MailFolder.ModelID, in accountID: Account.ModelID) async throws -> [MailFolder.ModelID] {
        try await modelContext.setChildrenMailFolders(microsofts: microsofts, parentID: parentID, in: accountID)
    }
    
    func setMessages(microsofts: [Microsoft.Message], in mailFolderID: MailFolder.ModelID) async throws -> [Message.ModelID] {
        try await modelContext.setMessages(microsofts: microsofts, in: mailFolderID)
    }
    
    func setMessage(microsoft: Microsoft.Message, to messageID: Message.ModelID) async throws -> Message.ModelID {
        try await modelContext.setMessage(microsoft: microsoft, to: messageID)
    }*/
    
}


// MARK: - ModelContext: Fetch
extension ModelContext {
    func _fetchAccountCount() throws -> Int {
        return try fetchCount(.init(predicate: #Predicate<Account> { !$0.deleteMark }))
    }
    
    func _fetchAccounts() throws -> [Account] {
        return try fetch(.init(predicate: #Predicate<Account> { !$0.deleteMark }, sortBy: [.init(\.orderIndex, order: .forward)]))
    }
    
    
    
    /*func fetchAccounts() throws -> [Account] {
        try fetch(FetchDescriptor<Account>())
    }*/
    
    func _fetchAccount(modelID: Account.ModelID) throws -> Account? {
        let id = modelID.string
        return try fetch(.init(predicate: #Predicate<Account> { $0.id == id })).first
    }
    
    func _fetchMailFolder(modelID: MailFolder.ModelID) throws -> MailFolder? {
        let id = modelID.string
        return try fetch(.init(predicate: #Predicate<MailFolder> { $0.id == id })).first
    }
    
    func _fetchMessage(modelID: Message.ModelID) throws -> Message? {
        let id = modelID.string
        return try fetch(.init(predicate: #Predicate<Message> { $0.id == id })).first
    }
    
    func _fetchAccountNotIn(_ accounts: [Account], in platform: Platform) throws -> [Account] {
        let platform = platform.rawValue
        let ids = accounts.map(\.modelID.string)
        return try fetch(.init(predicate: #Predicate<Account> { $0.platform == platform && !ids.contains($0.id) }))
    }
    
    func _fetchMailFolderNotIn(_ mailFolders: [MailFolder], in parent: MailFolder) throws -> [MailFolder] {
        let ids = mailFolders.map(\.modelID.string)
        let parentID = parent.modelID.string
        return try fetch(.init(predicate: #Predicate<MailFolder> { $0.parent?.id == parentID && !ids.contains($0.id) }))
    }
    
    func _fetchMessageNotIn(_ messages: [Message], in mailFolder: MailFolder) throws -> [Message] {
        let ids = messages.map(\.modelID.string)
        let mailFolderID = mailFolder.modelID.string
        return try fetch(.init(predicate: #Predicate<Message> { $0.mailFolder.id == mailFolderID && !ids.contains($0.id) }))
    }


// MARK: - ModelContext: Delete
    
    func _deleteAccount(_ model: Account) throws -> Account {
        model.deleteMark = true
        return model
    }
    
    func _deleteMailFolder(_ model: MailFolder) throws -> MailFolder {
        model.deleteMark = true
        return model
    }
    
    func _deleteMessage(_ model: Message) throws -> Message {
        model.deleteMark = true
        return model
    }


    

    
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
    
    func _insertAccount(session: Session) throws -> Account {
        let modelID = session.modelID
        
        // find existed
        if let model = try context._fetchAccount(modelID: modelID) {
            
            /*// If found: update
            model.session = session*/
            
            // If deleteMark: recover
            if model.deleteMark {
                model.orderIndex = try context._fetchAccountCount()
                model.deleteMark = false
            }
            return model
        }
        
        // If not found: create
        let model = Account(modelID: modelID, username: session.username)
        model.orderIndex = try context._fetchAccountCount()
        model.deleteMark = false
        context.insert(model)

        return model
    }
    
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
    
    

    


    
}




extension ModelStore {
    
    // MARK: - ModelContext: Client-Accounts API
    
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
    

    func addSession(_ session: Session) async throws -> Account.PersistentID {
        checkBackgroundThread()
        // insert
        do {
            let account = try modelContext._insertAccount(session: session)
            try modelContext.save()
            return account.persistentID
        } catch {
            modelContext.rollback()
            throw error
        }
    }
    

    
    func deleteAccount(id: Account.PersistentID) throws -> Account.PersistentID {
        checkBackgroundThread()
        do {
            var updatedItems = try modelContext._fetchAccounts()
            updatedItems.removeAll { $0.persistentID == id }
            for (index, item) in updatedItems.enumerated() {
                item.orderIndex = index
            }
            
            let model = self[id]!
            let result = try modelContext._deleteAccount(model)
            model.orderIndex = nil
            
            try modelContext.save()
            return result.persistentID
        } catch {
            modelContext.rollback()
            throw error
        }
    }
    
    func moveAccounts(appModel: AppModel, ids: [Account.PersistentID], fromOffsets source: IndexSet, toOffset destination: Int) throws -> [Account.PersistentID] {
        checkBackgroundThread()
        do {
            // contacts.move(fromOffsets: from, toOffset: to)
            // Make a copy of the current list of items
            var updatedItems = ids.map { self[$0]! }
            
            // Apply the move operation to the items
            updatedItems.move(fromOffsets: source, toOffset: destination)
            
            
            // Update each item's relative index order based on the new items
            // Can extract and reuse this part if the order of the items is changed elsewhere (like when deleting items)
            // The iteration could be done in reverse to reduce changes to the indices but isn't necessary
            for (index, item) in updatedItems.filter({ !$0.deleteMark }).enumerated() {
                item.orderIndex = index
            }
            for item in updatedItems.filter({ $0.deleteMark }) {
                item.orderIndex = nil
            }
            
            try modelContext.save()
            return updatedItems.map(\.persistentID)
        } catch {
            modelContext.rollback()
            throw error
        }
    }
    
    /*subscript<T: PersistentModel>(id: PersistentID<T>) -> T? {
        model(for: id.rawValue) as? T
    }*/
}



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

struct ClassifyResult : Codable {
    let existedFolder: String?
    
    private enum CodingKeys: String, CodingKey {
        case existedFolder = "existed_folder"
    }
}


// MARK: - Background Model Actors

