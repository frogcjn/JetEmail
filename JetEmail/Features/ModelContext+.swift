//
//  ModelContext+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import Foundation
import SwiftData // for ModelContainer

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
    func setSessions(_ sessions: [Session]) async throws -> [PersistentID<Account>]
    nonisolated var modelContainer: ModelContainer { get }
}

extension AppStorage {
    public var context: ModelContext { fatalError() }
    
    
}*/

extension BackgroundModelActor {
        
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

// MARK: - ModelContext: Insert or Delete Atom Operations
    
    func _insertMailFolder(microsoft: Microsoft.MailFolder, parent: MailFolder, in account: Account) throws -> MailFolder {
        // check account.root
        guard account.root != nil else { throw TreeError.accountDoNotHaveRootFolder }
        
        // insert before check relationship
        let folderID = try _insertMailFolder(microsoft: microsoft, in: account)
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
    }
    
    
    func _insertMailFolder(google: Google.MailFolder, parent: MailFolder, in account: Account) throws -> MailFolder {
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
        let model = try session.account
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
    
    
    func _insertMailFolder(microsoft: Microsoft.MailFolder, in account: Account) throws -> MailFolder {
        let id = microsoft.modelID
        
        // find existed
        if let model = try _fetchMailFolder(modelID: id) {
            
            // If found: update
            model.deleteMark = false
            model.microsoft = microsoft
            model.account = account
            return model
        }
        
        // If not found: create
        let model = MailFolder(microsoft: microsoft, in: account)
        insert(model)
        return model
        /*
            SwiftData.ModelContext:
            insert()
         
            if insert a new instance has a value of an unique property that is a duplicated with an old instance in the container:
                before saving, it has a temperary persistantModelID.
                after manual-saving or auto-saving (which is unkown time),
                    the old instance is updated to the new instance's properties.
                    the new instance is deleted.
            *It is unsafe to keep the new instance and access its properties. Developer should refetch to get the right instance after saving.*
         */
    }
    
    func _insertMailFolder(google: Google.MailFolder, in account: Account) throws -> MailFolder {
        let id = google.modelID
        
        // find existed
        if let model = try _fetchMailFolder(modelID: id) {
            
            // If found: update
            model.deleteMark = false
            model.google = google
            model.account = account
            return model
        }
        
        // If not found: create
        let model = MailFolder(google: google, in: account)
        insert(model)
        return model
        /*
            SwiftData.ModelContext:
            insert()
         
            if insert a new instance has a value of an unique property that is a duplicated with an old instance in the container:
                before saving, it has a temperary persistantModelID.
                after manual-saving or auto-saving (which is unkown time),
                    the old instance is updated to the new instance's properties.
                    the new instance is deleted.
            *It is unsafe to keep the new instance and access its properties. Developer should refetch to get the right instance after saving.*
         */
    }
    
    
    func _insertMessage(microsoft: Microsoft.Message, in mailFolder: MailFolder) throws -> Message {
        let id = microsoft.modelID
        
        // find existed
        if let model = try _fetchMessage(modelID: id) {
            
            // If found: update
            model.deleteMark = false
            model.microsoft = microsoft
            model.mailFolder = mailFolder
            return model
        }
        
        // If not found: create
        let model = Message(modelID: microsoft.modelID, in: mailFolder)
        model.microsoft = microsoft
        insert(model)
        return model
    }
    
    func _insertMessage(google: Google.Message.Full, in mailFolder: MailFolder) throws -> Message {
        let id = google.modelID
        
        // find existed
        if let model = try _fetchMessage(modelID: id) {
            
            // If found: update
            model.deleteMark = false
            try model.setGoogle(google)
            model.mailFolder = mailFolder
            return model
        }
        
        // If not found: create
        let model = Message(modelID: google.modelID, in: mailFolder)
        try model.setGoogle(google)
        insert(model)
        return model
    }
    
}




extension BackgroundModelActor {
    
    // MARK: - ModelContext: Client-Accounts API
    
    /*func setAccounts(microsofts: [Microsoft.Account]) async throws -> [PersistentID<Account>] {
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
    
    /*func setAccounts(googles: [Google.Account]) throws -> [PersistentID<Account>] {
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
    

    func addSession(_ session: Session) async throws -> PersistentID<Account> {
        BackgroundModelActor.assertIsolated()
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
    

    
    func deleteAccount(itemModel: AppItemModel<Account>, id: PersistentID<Account>) throws -> PersistentID<Account> {
        BackgroundModelActor.assertIsolated()
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
    
    func moveAccounts(appModel: AppModel, ids: [PersistentID<Account>], fromOffsets source: IndexSet, toOffset destination: Int) throws -> [PersistentID<Account>] {
        BackgroundModelActor.assertIsolated()
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



extension BackgroundModelActor {
    
    var appModel: AppModel { .shared }
    
    
    /*func addAccount(microsoft: Microsoft.Account) throws -> PersistentID<Account> {
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
    
    func addAccount(google: Google.Account) throws -> PersistentID<Account> {
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
    
    





// MARK: - ModelContext: MailFolder-Messages API

    
    //let batchSize = 1
    func setMessages(microsofts messages: [Microsoft.Message], in mailFolderID: PersistentID<MailFolder>) throws -> [PersistentID<Message>] {
        BackgroundModelActor.assertIsolated()
        let mailFolder = self[mailFolderID]!
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
    }
    
    
    func setMessages(googles messages: [Google.Message.Full], in mailFolderID: PersistentID<MailFolder>) throws -> [PersistentID<Message>] {
        BackgroundModelActor.assertIsolated()
        let mailFolder = self[mailFolderID]!
        do {
            
            // insert
            var inserts: [Message] = []
            for message in messages {
                try inserts.append(modelContext._insertMessage(google: message, in: mailFolder))
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
    }

// MARK: - Message -> Contents API

    
    func setMessage(microsoft: Microsoft.Message, to messageID: Message.ModelID) throws -> PersistentID<Message> {
        BackgroundModelActor.assertIsolated()
        let message = try modelContext._fetchMessage(modelID: messageID)!
        do {
            message.microsoft = microsoft
            try modelContext.save()
            return message.persistentID
        } catch {
            modelContext.rollback()
            throw error
        }
    }
    
    func setMessage(google: Google.Message.Full, to messageID: Message.ModelID) throws -> PersistentID<Message> {
        BackgroundModelActor.assertIsolated()
        let message = try modelContext._fetchMessage(modelID: messageID)!
        do {
            try message.setGoogle(google)
            try modelContext.save()
            return message.persistentID
        } catch {
            modelContext.rollback()
            throw error
        }
    }}


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

extension ModelContainer {
    var backgroundContext: BackgroundModelActor {
        BackgroundModelActor(modelContainer: self)
    }
}

