//
//  ModelContext+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import Foundation
import SwiftData // for ModelContainer



// MARK: - ModelContext: Fetch

extension ModelContext {
    func fetchAccountCount() throws -> Int {
        try fetchCount(.init(predicate: #Predicate<Account> { !$0.deleteMark }))
    }
    
    /*func fetchAccounts() throws -> [Account] {
        try fetch(FetchDescriptor<Account>())
    }*/
    
    func fetchAccount(modelID: Account.ModelID) throws -> Account? {
        let id = modelID.string
        return try fetch(.init(predicate: #Predicate<Account> { $0.id == id })).first
    }
    
    func fetchMailFolder(modelID: MailFolder.ModelID) throws -> MailFolder? {
        let id = modelID.string
        return try fetch(.init(predicate: #Predicate<MailFolder> { $0.id == id })).first
    }
    
    func fetchMessage(modelID: Message.ModelID) throws -> Message? {
        let id = modelID.string
        return try fetch(.init(predicate: #Predicate<Message> { $0.id == id })).first
    }
    
    func fetchAccountNotIn(models: [Account]) throws -> [Account] {
        let ids = models.map(\.id)
        return try fetch(.init(predicate: #Predicate<Account> { !ids.contains($0.id) }))
    }
    
    func fetchMailFolderNotIn(models: [MailFolder], in parent: MailFolder) throws -> [MailFolder] {
        let ids = models.map(\.id)
        let parentID = parent.id
        return try fetch(.init(predicate: #Predicate<MailFolder> { $0.parent?.id == parentID && !ids.contains($0.id) }))
    }
    
    func fetchMessageNotIn(models: [Message], in mailFolder: MailFolder) throws -> [Message] {
        let ids = models.map(\.id)
        let mailFolderID = mailFolder.id
        return try fetch(.init(predicate: #Predicate<Message> { $0.mailFolder.id == mailFolderID && !ids.contains($0.id) }))
    }
}

// MARK: - ModelContext: Client-Accounts API


extension ModelContext {
    
    func setAccounts(graphs: [MSGraph.Account]) throws -> [Account] {
        do {
            // insert
            let inserted = try graphs.map{ try _insertAccount(graph: $0) }
            
            // delete
            let removing = try fetchAccountNotIn(models: inserted)
            removing.forEach { _ = _deleteAccount($0) }
            
            try save()
            return inserted
        } catch {
            rollback()
            throw error
        }
    }
    
    func addAccount(graph: MSGraph.Account) throws -> Account {
        do {
            // insert
            let account = try _insertAccount(graph: graph)
            try save()
            return account
        } catch {
            rollback()
            throw error
        }
    }
    
    func removeAccount(_ model: Account) throws -> Account {
        let model = try model.to(self)
        do {
            let model = _deleteAccount(model)
            try save()
            return model
        } catch {
            rollback()
            throw error
        }
    }
    
    func moveAccounts(_ models: [Account], fromOffsets source: IndexSet, toOffset destination: Int) throws -> [Account] {
        let models = try models.to(self)
        do {
            // contacts.move(fromOffsets: from, toOffset: to)
            // Make a copy of the current list of items
            var updatedItems = models
            
            // Apply the move operation to the items
            updatedItems.move(fromOffsets: source, toOffset: destination)
            
            // Update each item's relative index order based on the new items
            // Can extract and reuse this part if the order of the items is changed elsewhere (like when deleting items)
            // The iteration could be done in reverse to reduce changes to the indices but isn't necessary
            for (index, item) in updatedItems.enumerated() {
                item.orderIndex = index
            }
            try save()
            return updatedItems
        } catch {
            rollback()
            throw error
        }
    }
}



extension BackgroundModelActor {
    

}

// MARK: - ModelContext: Account-MailFolders API

extension ModelContext {

    /// Set all messages from graphContext to `ModelContainer`.
    /// - Parameters:
    ///   - elements: Messages from  `MSGraph.Context`.
    ///   - mailFolder: mai
    /// - Returns: Messages from `ModelContainer`.
    func setRootMailFolder(graph: MSGraph.MailFolder, in account: Account) throws -> MailFolder {
        let account = try account.to(self)
        do {
            if let root = account.root { return root }
            let root = try _insertMailFolder(graph: graph, in: account)
            account.root = root
            try save()
            return root
        } catch {
            rollback()
            throw error
        }
    }
    
    func setChildrenMailFolders(graphs: [MSGraph.MailFolder], parent: MailFolder, in account: Account) throws -> [MailFolder] {
        let parent = try parent.to(self)
        let account = try account.to(self)
        
        do {
            // insert
            let inserted = try graphs.map { try _insertMailFolder(graph: $0, parent: parent, in: account) }
            
            // delete
            let removing = try fetchMailFolderNotIn(models: inserted, in: parent)
            removing.forEach { _ = _deleteMailFolder($0) }
            
            try save()
            return inserted
        } catch {
            rollback()
            throw error
        }
    }
}

// MARK: - ModelContext: MailFolder-Messages API

extension ModelContext {
    
    //let batchSize = 1
    func setMessages(graphs: [MSGraph.Message], in mailFolder: MailFolder) throws -> [Message] {
        let mailFolder = try mailFolder.to(self)
        do {
            
            // insert
            let inserted = try graphs.map { try _insertMessage(graph: $0, in: mailFolder) }
            
            // delete
            let removing = try fetchMessageNotIn(models: inserted, in: mailFolder)
            removing.forEach { _ = _deleteMessage($0) }
            
            try save()
            return inserted
        } catch {
            rollback()
            throw error
        }
    }
    
}

// MARK: - Message -> Contents API

extension ModelContext {

    
    func setMessage(graph: MSGraph.Message, to message: Message) throws -> Message {
        let message = try message.to(self)
        do {
            message.graph = graph
            try save()
            return message
        } catch {
            rollback()
            throw error
        }
    }
}

// MARK: - ModelContext: Insert or Delete Atom Operations

fileprivate extension ModelContext {
    
    func _insertMailFolder(graph: MSGraph.MailFolder, parent: MailFolder, in account: Account) throws -> MailFolder {
        
        // check account.root
        guard account.root != nil else { throw TreeError.accountDoNotHaveRootFolder }
        
        // insert before check relationship
        let folder = try _insertMailFolder(graph: graph, in: account)
    
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
    
    
    func _insertAccount(graph: MSGraph.Account) throws -> Account {
        let modelID = graph.modelID
        
        // find existed
        if let model = try fetchAccount(modelID: modelID) {
            
            // If found: update
            model.deleteMark = false
            model.graph = graph
            return model
        }
            
        // If not found: create
        let count = try fetchAccountCount()
        let model = try Account(graph: graph, orderIndex: count)
        insert(model)
        return model
    }
    
    func _insertMailFolder(graph: MSGraph.MailFolder, in account: Account) throws -> MailFolder {
        let id = graph.modelID
        
        // find existed
        if let model = try fetchMailFolder(modelID: id) {
            
            // If found: update
            model.deleteMark = false
            model.graph = graph
            model.account = account
            return model
        }
        
        // If not found: create
        let model = MailFolder(graph: graph, in: account)
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
    
    func _insertMessage(graph: MSGraph.Message, in mailFolder: MailFolder) throws -> Message {
        let id = graph.modelID
        
        // find existed
        if let model = try fetchMessage(modelID: id) {
            
            // If found: update
            model.deleteMark = false
            model.graph = graph
            model.mailFolder = mailFolder
            return model
        }
        
        // If not found: create
        let model = Message(modelID: graph.modelID, in: mailFolder)
        model.graph = graph
        insert(model)
        return model
    }
    
    func _deleteAccount(_ model: Account) -> Account {
        model.deleteMark = true
        return model
    }
    
    func _deleteMailFolder(_ model: MailFolder) -> MailFolder {
        model.deleteMark = true
        return model
    }
    
    func _deleteMessage(_ model: Message) -> Message {
        model.deleteMark = true
        return model
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
        .init(modelContainer: self)
    }
}

@ModelActor
actor BackgroundModelActor {
    /*func moveAccounts(_ accounts: [Account], fromOffsets source: IndexSet, toOffset destination: Int) throws -> [Account] {
        try modelContext.moveAccounts(accounts, fromOffsets: source, toOffset: destination)
    }*/

    func setRootMailFolder(graph: MSGraph.MailFolder, in account: Account) throws -> MailFolder {
        try modelContext.setRootMailFolder(graph: graph, in: account)
    }
    
    func setChildrenMailFolders(graphs: [MSGraph.MailFolder], parent: MailFolder, in account: Account) throws -> [MailFolder] {
        try modelContext.setChildrenMailFolders(graphs: graphs, parent: parent, in: account)
    }
    
    func setMessages(graphs: [MSGraph.Message], in mailFolder: MailFolder) throws -> [Message] {
        try modelContext.setMessages(graphs: graphs, in: mailFolder)
    }
    
}
