//
//  ModelContext+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import Foundation
import SwiftData // for ModelContainer

// MARK: - ModelContext: Fetch
fileprivate extension ModelContext {
    func _fetchAccountCount() throws -> Int {
        return try fetchCount(.init(predicate: #Predicate<Account> { !$0.deleteMark }))
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
    
    
    func _insertAccount(microsoft: Microsoft.Account) throws -> Account {
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
    }
    
    
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
    
    /// Set all messages from graphContext to `ModelContainer`.
    /// - Parameters:
    ///   - elements: Messages from  `MSGraph.Context`.
    ///   - mailFolder: mai
    /// - Returns: Messages from `ModelContainer`.
    func _setRootMailFolder(microsoft: Microsoft.MailFolder, in account: Account) throws -> MailFolder {
        do {
            if let root = account.root { return root }
            let root = try _insertMailFolder(microsoft: microsoft, in: account)
            account.root = root
            try save()
            return root
        } catch {
            rollback()
            throw error
        }
    }
    

    
    func _setChildrenMailFolders(microsofts: [Microsoft.MailFolder], parent: MailFolder, in account: Account) throws -> [MailFolder] {
        do {
            // insert
            var inserts: [MailFolder] = []
            for microsoft in microsofts {
                try inserts.append(_insertMailFolder(microsoft: microsoft, parent: parent, in: account))
            }
            
            // delete
            let removings = try _fetchMailFolderNotIn(inserts, in: parent)
            try removings.forEach { _ = try _deleteMailFolder($0) }
            
            try save()
            return inserts
        } catch {
            rollback()
            throw error
        }
    }
    
    
}

@MainActor
extension ModelContext {
    
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
    
    func setAccounts(googles: [Google.Account]) throws -> [PersistentID<Account>] {
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
    }
    
    func addSessions(_ sessions: [Session]) async throws -> [PersistentID<Account>] {
        MainActor.assertIsolated()
        do {
            // insert
            var inserts: Set<Account> = []
            for session in sessions {
                try inserts.insert(_insertAccount(session: session))
            }
            
            /* do not delete, just keep it to show status
            // delete*/
            let otherAccounts = try _fetchAccountNotIn(Array(inserts), in: .microsoft)
            otherAccounts.forEach { $0.session = nil }
            
            print("modelContext.save")
            try save()
            return inserts.map(\.persistentID)
        } catch {
            rollback()
            throw error
        }
    }
    
    func addSession(_ session: Session) throws -> PersistentID<Account> {
        MainActor.assertIsolated()
        // insert
        do {
            let account = try _insertAccount(session: session)
            try save()
            return account.persistentID
        } catch {
            rollback()
            throw error
        }
    }
    
    func _insertAccount(session: Session) throws -> Account {
        MainActor.assertIsolated()
        let modelID = try session.modelID
        
        // find existed
        if let model = try _fetchAccount(modelID: modelID) {
            
            // If found: update
            model.session = session
            return model
        }
            
        // If not found: create
        let model = try session.newAccount
        model.orderIndex = try _fetchAccountCount()
        insert(model)
        return model
    }
    
}


extension BackgroundModelActor {
    
    
    func addAccount(microsoft: Microsoft.Account) throws -> PersistentID<Account> {
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
    }
    
    
    subscript<T: PersistentModel>(id: PersistentID<T>) -> T? {
        self[id.rawValue, as: T.self]
    }
    
    func deleteAccount(id: PersistentID<Account>) throws -> PersistentID<Account> {
        BackgroundModelActor.assertIsolated()
        do {
            let model = self[id]!
            let result = try modelContext._deleteAccount(model)
            try modelContext.save()
            return result.persistentID
        } catch {
            modelContext.rollback()
            throw error
        }
    }
    
    func moveAccounts(ids: [PersistentID<Account>], fromOffsets source: IndexSet, toOffset destination: Int) throws -> [PersistentID<Account>] {
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
            for (index, item) in updatedItems.enumerated() {
                item.orderIndex = index
            }
            try modelContext.save()
            return updatedItems.map(\.persistentID)
        } catch {
            modelContext.rollback()
            throw error
        }
    }

    func loadAccountMailFolders(client: Microsoft.Client, account accountPersistentID: PersistentID<Account>) async throws {
        /*BackgroundModelActor.assertIsolated()
        

        let account = self[accountPersistentID]!
        guard case .microsoft(let accountMicrosoftID) = account.modelID.enumValue else { return }
        let microsoft = try await client.account(id: accountMicrosoftID)
        let microsoftRoot = try await microsoft.getRootMailFolder()
        let root = try modelContext._setRootMailFolder(microsoft: microsoftRoot, in: account)
        var queue: [MailFolder] = [root]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            let microsofts = try await microsoft.getChildFolders(microsoftID: .init(string: current.platformID))
            let children = try modelContext._setChildrenMailFolders(microsofts: microsofts, parent: current, in: account)
            queue.append(contentsOf: children)
        }*/
    }
    


// MARK: - ModelContext: MailFolder-Messages API

    
    //let batchSize = 1
    func setMessages(microsoft messages: [Microsoft.Message], in mailFolderID: PersistentID<MailFolder>) throws -> [PersistentID<Message>] {
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

extension ModelContainer {
    var backgroundContext: BackgroundModelActor {
        BackgroundModelActor(modelContainer: self)
    }
}

@globalActor
@ModelActor
actor BackgroundModelActor {
    
    static var shared = BackgroundModelActor(modelContainer: try! ModelContainer(for: Account.self))
    
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

