//
//  ModelContext+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import Foundation
import SwiftData // for ModelContainer
import JetEmail_Foundation
import JetEmail_Data


@ModelActor
public actor ModelStore {}


/*
protocol AppStorage {
    func setSessions(_ sessions: [Session]) async throws -> [Account.PersistentID]
    nonisolated var modelContainer: ModelContainer { get }
}

extension AppStorage {
    public var context: ModelContext { fatalError() }
    
    
}*/

extension ModelStore {
    
    /*func moveAccounts(_ accounts: [Account], fromOffsets source: IndexSet, toOffset destination: Int) throws -> [Account] {
        try modelContext.moveAccounts(accounts, fromOffsets: source, toOffset: destination)
    }*/

    /*func setRootMailFolder(microsoft: Microsoft.MailFolder, in accountID: Account.ID) async throws -> MailFolder.ID {
        try await modelContext.setRootMailFolder(microsoft: microsoft, in: accountID)
    }
    
    func setChildrenMailFolders(microsofts: [Microsoft.MailFolder], parentID: MailFolder.ID, in accountID: Account.ID) async throws -> [MailFolder.ID] {
        try await modelContext.setChildrenMailFolders(microsofts: microsofts, parentID: parentID, in: accountID)
    }
    
    func setMessages(microsofts: [Microsoft.Message], in mailFolderID: MailFolder.ID) async throws -> [Message.ID] {
        try await modelContext.setMessages(microsofts: microsofts, in: mailFolderID)
    }
    
    func setMessage(microsoft: Microsoft.Message, to messageID: Message.ID) async throws -> Message.ID {
        try await modelContext.setMessage(microsoft: microsoft, to: messageID)
    }*/
    
}


import SwiftData
/*
extension ModelContext {
    func _fetchAccount(modelID: Account.ID) throws -> Account? {
        let rawID = modelID.rawValue
        return try fetch(.init(predicate: #Predicate<Account> { $0.rawID == rawID })).first
    }
    
    func _fetchMailFolder(modelID: MailFolder.ID) throws -> MailFolder? {
        let rawID = modelID.rawValue
        return try fetch(.init(predicate: #Predicate<MailFolder> { $0.rawID == rawID })).first
    }
    
    func _fetchMessage(modelID: Message.ID) throws -> Message? {
        let rawID = modelID.rawValue
        return try fetch(.init(predicate: #Predicate<Message> { $0.rawID == rawID })).first
    }
}

*/
// MARK: - ModelContext: Fetch
fileprivate extension ModelContext {
    func _fetchAccountCount() throws -> Int {
        return try fetchCount(.init(predicate: #Predicate<JetEmail_Data.Account> { !$0.deleteMark }))
    }
    
    func _fetchAccounts() throws -> [JetEmail_Data.Account] {
        return try fetch(.init(predicate: #Predicate<JetEmail_Data.Account> { !$0.deleteMark }, sortBy: [.init(\.orderIndex, order: .forward)]))
    }
    
    
    
    /*func fetchAccounts() throws -> [Account] {
        try fetch(FetchDescriptor<Account>())
    }*/
    

    
    func _fetchAccountNotIn(_ accounts: [JetEmail_Data.Account], in platform: Platform) throws -> [JetEmail_Data.Account] {
        //let platform = platform.rawValue
        let rawPlatform = platform.rawValue
        let ids = accounts.map(\.id.uniqueID)
        return try fetch(.init(predicate: #Predicate<JetEmail_Data.Account> { $0.rawPlatform == rawPlatform && !ids.contains($0.uniqueID) }))
    }
    
    func _fetchMailFolderNotIn(_ mailFolders: [JetEmail_Data.MailFolder], in parent: JetEmail_Data.MailFolder) throws -> [JetEmail_Data.MailFolder] {
        let rawID = mailFolders.map(\.id.uniqueID)
        let parentRawID = parent.id.uniqueID
        return try fetch(.init(predicate: #Predicate<JetEmail_Data.MailFolder> { $0.parent?.uniqueID == parentRawID && !rawID.contains($0.uniqueID) }))
    }
    
    func _fetchMessageNotIn(_ messages: [JetEmail_Data.Message], in mailFolder: JetEmail_Data.MailFolder) throws -> [JetEmail_Data.Message] {
        let rawIDs = messages.map(\.id.uniqueID)
        let mailFolderRawID = mailFolder.id.uniqueID
        return try fetch(.init(predicate: #Predicate<JetEmail_Data.Message> { $0.mailFolder.uniqueID == mailFolderRawID && !rawIDs.contains($0.uniqueID) }))
    }
    
    func _fetchMessageNotIn(_ messages: [JetEmail_Data.Message.ID], in mailFolder: JetEmail_Data.MailFolder) throws -> [JetEmail_Data.Message] {
        let rawIDs = messages.map(\.uniqueID)
        let mailFolderRawID = mailFolder.id.uniqueID
        return try fetch(.init(predicate: #Predicate<JetEmail_Data.Message> { $0.mailFolder.uniqueID == mailFolderRawID && !rawIDs.contains($0.uniqueID) }))
    }
    
    func _fetchMessageRawIDs(in id: JetEmail_Data.MailFolder.ID) throws -> [JetEmail_Data.Message] {
        let mailFolderRawID = id.uniqueID
        var fetchDescriptor = FetchDescriptor<JetEmail_Data.Message>()
        fetchDescriptor.predicate = #Predicate<JetEmail_Data.Message> { $0.mailFolder.uniqueID == mailFolderRawID }
        fetchDescriptor.propertiesToFetch = [\.uniqueID]
        return try fetch(fetchDescriptor)
    }


// MARK: - ModelContext: Delete
    
    func _deleteAccount(_ model: JetEmail_Data.Account) throws -> JetEmail_Data.Account {
        model.deleteMark = true
        return model
    }
    
    func _deleteMailFolder(_ model: JetEmail_Data.MailFolder) throws -> JetEmail_Data.MailFolder {
        model.deleteMark = true
        return model
    }
    
    func _deleteMessage(_ model: JetEmail_Data.Message) throws -> JetEmail_Data.Message {
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
    
    func _insertAccount(session: JetEmail_Data.Session) throws -> JetEmail_Data.Account {
        // find existed
        if let model: JetEmail_Data.Account = try self[session.accountID] {
            
            /*// If found: update
            model.session = session*/
            
            // If deleteMark: recover
            if model.deleteMark {
                model.orderIndex = try _fetchAccountCount()
                model.deleteMark = false
            }
            return model
        }
        
        // If not found: create
        let model = Account(id: session.accountID, username: session.username)
        model.orderIndex = try _fetchAccountCount()
        model.deleteMark = false
        insert(model)

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
    

    func addSession(_ session: JetEmail_Data.Session) async throws -> JetEmail_Data.Account.PersistentID {
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
    

    
    func deleteAccount(id: JetEmail_Data.Account.ID) throws -> JetEmail_Data.Account.PersistentID {
        checkBackgroundThread()
        do {
            var updatedItems = try modelContext._fetchAccounts()
            updatedItems.removeAll { $0.id == id }
            for (index, item) in updatedItems.enumerated() {
                item.orderIndex = index
            }
            
            let model = try self[id]!
            let result = try modelContext._deleteAccount(model)
            model.orderIndex = nil
            
            try modelContext.save()
            return result.persistentID
        } catch {
            modelContext.rollback()
            throw error
        }
    }
    
    func moveAccounts(appModel: AppModel, ids: [JetEmail_Data.Account.ID], fromOffsets source: IndexSet, toOffset destination: Int) throws -> [JetEmail_Data.Account.PersistentID] {
        checkBackgroundThread()
        do {
            // contacts.move(fromOffsets: from, toOffset: to)
            // Make a copy of the current list of items
            var updatedItems = try ids.map { try self[$0]! }
            
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

//
//  Google+Feature.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

import SwiftData
import Google
import Microsoft
import JetEmail_Foundation
import Foundation

extension ModelContext {
    func _insertMailFolder(google: GoogleMailFolder, parent: JetEmail_Data.MailFolder, in account: JetEmail_Data.Account) throws -> JetEmail_Data.MailFolder {
        // check account.root
        guard account.root != nil else { throw TreeError.accountDoNotHaveRootFolder }
        
        // insert before check relationship
        let folderID = try _insertMailFolder(google: google, in: account)
        let folder = try self[folderID.id]!

        // check parent and folder account
        guard parent.account == account else { throw TreeError.parentMailFolderNotInThisAccount }
        guard folder.account == account else { throw TreeError.mailFolderNotInThisAccount }
        
        // check node.parent
        // if folder.parent != nil && folder.parent != parent { throw TreeError.mailFolderAlreadyHaveParent }
        folder.parent = parent
        
        // check node.children
        // guard node.children.isEmpty else { throw TreeError.alreadyHaveChild }
        
        return folder
    }
    
    // MARK: - ModelContext: Insert or Delete Atom Operations
        
    func _insertMailFolder(_ platformCase: PlatformCase<MicrosoftMailFolder, GoogleMailFolder>, parent: MailFolder, in account: Account) throws -> MailFolder {
        switch platformCase {
        case .microsoft(let microsoft): return try _insertMailFolder(microsoft: microsoft, parent: parent, in: account)
        case    .google(let    google): return try _insertMailFolder(   google:    google, parent: parent, in: account)
        }
    }
    func _insertMailFolder(microsoft: MicrosoftMailFolder, parent: JetEmail_Data.MailFolder, in account: JetEmail_Data.Account) throws -> JetEmail_Data.MailFolder {
        // check account.root
        guard account.root != nil else { throw TreeError.accountDoNotHaveRootFolder }
        
        // insert before check relationship
        let folderID = try _insertMailFolder(microsoft: microsoft, in: account)
        let folder = try self[folderID.id]!

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
        
    func _insertMailFolder(microsoft: MicrosoftMailFolder, in account: JetEmail_Data.Account) throws -> JetEmail_Data.MailFolder {
        let id = microsoft.id.general

        // find existed
        if let model = try self[id] {
            
            // If found: update
            model.deleteMark = false
            model.microsoft = microsoft
            model.account = account
            return model
        }
        
        // If not found: create
        let model = MailFolder(platformCase: .microsoft(microsoft), in: account)
        insert(model)
        return model
        /*
            SwiftData.ModelContext:
            insert()
         
            if insert a new instance has a value of an unique property that is a duplicated with an old instance in the container:
                before saving, it has a temperary persistantID.
                after manual-saving or auto-saving (which is unkown time),
                    the old instance is updated to the new instance's properties.
                    the new instance is deleted.
            *It is unsafe to keep the new instance and access its properties. Developer should refetch to get the right instance after saving.*
         */
    }
    
    func _insertMailFolder(google: GoogleMailFolder, in account: JetEmail_Data.Account) throws -> JetEmail_Data.MailFolder {
        let id = google.id.general
        
        // find existed
        if let model = try self[id] {
            
            // If found: update
            model.deleteMark = false
            model.google = google
            model.account = account
            return model
        }
        
        // If not found: create
        let model = MailFolder(platformCase: .google(google), in: account)
        insert(model)
        return model
        /*
            SwiftData.ModelContext:
            insert()
         
            if insert a new instance has a value of an unique property that is a duplicated with an old instance in the container:
                before saving, it has a temperary persistantID.
                after manual-saving or auto-saving (which is unkown time),
                    the old instance is updated to the new instance's properties.
                    the new instance is deleted.
            *It is unsafe to keep the new instance and access its properties. Developer should refetch to get the right instance after saving.*
         */
    }
    
    func _insertMailFolder(_ platformCase: PlatformCase<MicrosoftMailFolder, GoogleMailFolder>, in account: Account) throws -> MailFolder {
        switch platformCase {
        case .microsoft(let microsoft): return try _insertMailFolder(microsoft: microsoft, in: account)
        case    .google(let    google): return try _insertMailFolder(   google:    google, in: account)
        }
    }
    
    func _insertMessage(google: GoogleMessage, in mailFolder: JetEmail_Data.MailFolder) throws -> JetEmail_Data.Message {
        let id = google.id.general

        // find existed
        if let model = try self[id] {
            
            // If found: update
            model.deleteMark = false
            try model.setGoogle(google)
            model.mailFolder = mailFolder
            return model
        }
        
        // If not found: create
        let model = Message(modelID: id, in: mailFolder)
        try model.setGoogle(google)
        insert(model)
        model.mailFolder = mailFolder
        return model
    }
    
    
    
    func _insertMessage(microsoft: MicrosoftMessage, in mailFolder: JetEmail_Data.MailFolder) throws -> JetEmail_Data.Message {
        let id = microsoft.id.general

        // find existed
        if let model = try self[id] {
            
            // If found: update
            model.deleteMark = false
            model.microsoft = microsoft
            model.mailFolder = mailFolder
            return model
        }
        
        // If not found: create
        let model = Message(modelID: id, in: mailFolder)
        model.microsoft = microsoft
        insert(model)
        return model
    }
    

}


extension ModelStore {
    func setMessages(googles messages: [GoogleMessage], in mailFolderID: JetEmail_Data.MailFolder.ID) throws -> [JetEmail_Data.Message.PersistentID] {
        checkBackgroundThread()
        let mailFolder = try self[mailFolderID]!
        do {
            
            // insert
            var inserts: [JetEmail_Data.Message] = []
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
    
    func setMessage(google: GoogleMessage, to messageID: JetEmail_Data.Message.ID) throws -> JetEmail_Data.Message.PersistentID {
        checkBackgroundThread()
        let message = try self[messageID]!
        do {
            try message.setGoogle(google)
            try modelContext.save()
            return message.persistentID
        } catch {
            modelContext.rollback()
            throw error
        }
    }
    
    // MARK: - ModelContext: MailFolder-Messages API
    
    
    //let batchSize = 1
    func setMessages(microsofts messages: [MicrosoftMessage], in mailFolderID: JetEmail_Data.MailFolder.ID) throws -> [JetEmail_Data.Message.PersistentID] {
        checkBackgroundThread()
        let mailFolder = try self[mailFolderID]!
        do {
            
            // insert
            var inserts: [JetEmail_Data.Message] = []
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
    
    func setMessagesInsertPart(microsofts messages: [MicrosoftMessage], in mailFolderID: JetEmail_Data.MailFolder.ID) throws -> [JetEmail_Data.Message.ID] {
        checkBackgroundThread()
        let mailFolder = try self[mailFolderID]!
        do {
            // insert
            var inserts: [JetEmail_Data.Message] = []
            for message in messages {
                try inserts.append(modelContext._insertMessage(microsoft: message, in: mailFolder))
            }
            try modelContext.save()
            return inserts.map(\.id)
        } catch {
            modelContext.rollback()
            throw error
        }
    }
    
    
    
    func setMessagesDeletePart(keep: [JetEmail_Data.Message.ID], in mailFolderID: JetEmail_Data.MailFolder.ID) throws -> [JetEmail_Data.Message.ID] {
        checkBackgroundThread()
        let mailFolder = try self[mailFolderID]!
        do {
            // delete
            let removings = try modelContext._fetchMessageNotIn(keep, in: mailFolder)
            try removings.forEach { _ = try modelContext._deleteMessage($0) }
            
            try modelContext.save()
            return removings.map(\.id)
        } catch {
            modelContext.rollback()
            throw error
        }
    }
    
    func messageRawIDs(in id: JetEmail_Data.MailFolder.ID) throws -> [JetEmail_Data.Message] {
        checkBackgroundThread()
        // let mailFolder = try self[id]!
        return try modelContext._fetchMessageRawIDs(in: id)
        // return mailFolder.messages.map(\.id)
    }
    
    func setMessagesDeletePart(newMessageIDs: [JetEmail_Data.Message.ID], in id: JetEmail_Data.MailFolder.ID) async throws -> Int? {
        checkBackgroundThread()
        
        let newMessageRawIDs = newMessageIDs.map(\.uniqueID)
        let oldMessages = Set(try modelContext._fetchMessageRawIDs(in: id))
        
        let shouldDeleteMessages = oldMessages.filter { !newMessageRawIDs.contains($0.uniqueID) }
        let shouldInsertFirstIndex = newMessageIDs.firstIndex { !oldMessages.map(\.uniqueID).contains($0.uniqueID) }
        
        
        try modelContext.transaction {
            try shouldDeleteMessages.forEach { _ = try modelContext._deleteMessage($0) }
        }
        return shouldInsertFirstIndex
    }
    
    
    
    
    // MARK: - Message -> Contents API
    
    
    func setMessage(microsoft: MicrosoftMessage, to messageID: JetEmail_Data.Message.ID) throws -> JetEmail_Data.Message.PersistentID {
        checkBackgroundThread()
        let message = try self[messageID]!
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

extension ModelStore {

    func insertMailFolder(platform: PlatformCase<MicrosoftMailFolder, GoogleMailFolder>, in accountID: AccountID) throws -> MailFolderID {
        let account = try self[accountID]!
        var mailFolder: MailFolder!
        try modelContext.transaction {
            mailFolder = try modelContext._insertMailFolder(platform, in: account)
        }
        return mailFolder.id
    }
    
        
    /*func insertMailFolder(platform: MicrosoftMailFolder, in accountID: JetEmail_Data.Account.ID) throws -> MailFolderID {
        let account = try self[accountID]!
        do {
            let root = try modelContext._insertMailFolder(microsoft: microsoft, in: account)
            try modelContext.save()
            return root.id
        } catch {
            modelContext.rollback()
            throw error
        }
    }
    
    func setRootMailFolder(google: GoogleMailFolder, in accountID: JetEmail_Data.Account.ID) throws -> MailFolderID {
        let account = try self[accountID]!
        do {
            if let root = account.root { return root.id }
            let root = try modelContext._insertMailFolder(google: google, in: account)
            account.root = root
            try modelContext.save()
            return root.id
        } catch {
            print(error)
            modelContext.rollback()
            throw error
        }
    }*/
    
    func rootGoogleMailFolder(in accountID: JetEmail_Data.Account.ID) throws -> GoogleMailFolder? {
        let account = try self[accountID]!
        return account.root?.google
    }
    
    func setChildrenMailFolders(platform: [PlatformCase<MicrosoftMailFolder, GoogleMailFolder>], parent parentID: JetEmail_Data.MailFolder.ID, in accountID: JetEmail_Data.Account.ID) throws -> [MailFolder.ID] {
        let parent = try self[parentID]!
        let account = try self[accountID]!
        do {
            // insert
            var inserts: [MailFolder] = []
            for platform in platform {
                try inserts.append(modelContext._insertMailFolder(platform, parent: parent, in: account))
            }
            
            // delete
            let removings = try modelContext._fetchMailFolderNotIn(inserts, in: parent)
            try removings.forEach { _ = try modelContext._deleteMailFolder($0) }
            
            inserts = inserts.sortedInParentMailFolder
            for (index, insert) in inserts.enumerated() {
                insert._childIndex = index
            }

            try modelContext.save()
            return inserts.map { $0.id }
        } catch {
            modelContext.rollback()
            throw error
        }
    }

    /*func setChildrenMailFolders(googles: [GoogleMailFolder], parent parentID: JetEmail_Data.MailFolder.ID, in accountID: JetEmail_Data.Account.ID) throws -> [ JetEmail_Data.MailFolder.ID] {
        let parent = try self[parentID]!
        let account = try self[accountID]!
        do {
            var inserts: [JetEmail_Data.MailFolder] = []
            for google in googles {
                try inserts.append(modelContext._insertMailFolder(google: google, parent: parent, in: account))
            }
            
            // delete
            let removings = try modelContext._fetchMailFolderNotIn(inserts, in: parent)
            try removings.forEach { _ = try modelContext._deleteMailFolder($0) }
            
            try modelContext.save()
            return inserts.map { ($0.id) }
        } catch {
            modelContext.rollback()
            throw error
        }
    }*/
}


extension ModelStore {
    func setSessions(_ sessions: [JetEmail_Data.Session]) async throws -> [JetEmail_Data.Account.PersistentID] {
        checkBackgroundThread()
        do {
            // inserts
            let inserts: [JetEmail_Data.Account] = try sessions.map(modelContext._insertAccount(session:))
            
            // others: not have session
            let otherIDs = try modelContext._fetchAccountNotIn(Array(inserts), in: .google).map(\.id)
            try await otherIDs.forEachTask { @MainActor in _ = $0.removeSession() }
            // save
            try modelContext.save()
            
            // return
            return inserts.map(\.persistentID)
        } catch {
            modelContext.rollback()
            throw error
        }
    }
}
