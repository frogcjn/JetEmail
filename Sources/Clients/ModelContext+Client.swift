//
//  Google+Feature.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

import SwiftData
import Google
import Microsoft

extension ModelContext {
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
        // if folder.parent != nil && folder.parent != parent { throw TreeError.mailFolderAlreadyHaveParent }
        folder.parent = parent
        
        // check node.children
        // guard node.children.isEmpty else { throw TreeError.alreadyHaveChild }
        
        return folder
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
    
    func _insertMessage(google: Google.Message.Full, in mailFolder: MailFolder) throws -> Message {
        let id = google.modelID
        
        // find existed
        if let model = try _fetchMessage(modelID: id) {
            
            // If found: update
            model.deleteMark = false
            try model.setGoogle(google, in: mailFolder)
            return model
        }
        
        // If not found: create
        let model = Message(modelID: google.modelID, in: mailFolder)
        try model.setGoogle(google, in: mailFolder)
        insert(model)
        return model
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
    

}


extension BackgroundModelActor {
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
    
    func setMessage(google: Google.Message.Full, to messageID: Message.ModelID) throws -> PersistentID<Message> {
        BackgroundModelActor.assertIsolated()
        let message = try modelContext._fetchMessage(modelID: messageID)!
        do {
            try message.setGoogle(google, in: message.mailFolder)
            try modelContext.save()
            return message.persistentID
        } catch {
            modelContext.rollback()
            throw error
        }
    }
    
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

extension BackgroundModelActor {

    func setRootMailFolder(microsoft: Microsoft.MailFolder, in accountID: PersistentID<Account>) throws -> MailFolder {
        let account = self[accountID]!
        do {
            if let root = account.root { return root }
            let root = try modelContext._insertMailFolder(microsoft: microsoft, in: account)
            account.root = root
            try modelContext.save()
            return root
        } catch {
            modelContext.rollback()
            throw error
        }
    }
    
    func setRootMailFolder(google: Google.MailFolder, in accountID: PersistentID<Account>) throws -> MailFolder {
        let account = self[accountID]!
        do {
            if let root = account.root { return root }
            let root = try modelContext._insertMailFolder(google: google, in: account)
            account.root = root
            try modelContext.save()
            return root
        } catch {
            modelContext.rollback()
            throw error
        }
    }
    
    func setChildrenMailFolders(microsofts: [Microsoft.MailFolder], parent parentID: PersistentID<MailFolder>, in accountID: PersistentID<Account>) throws -> [MailFolder] {
        let parent = self[parentID]!
        let account = self[accountID]!
        do {
            // insert
            var inserts: [MailFolder] = []
            for microsoft in microsofts {
                try inserts.append(modelContext._insertMailFolder(microsoft: microsoft, parent: parent, in: account))
            }
            
            // delete
            let removings = try modelContext._fetchMailFolderNotIn(inserts, in: parent)
            try removings.forEach { _ = try modelContext._deleteMailFolder($0) }
            
            try modelContext.save()
            return inserts
        } catch {
            modelContext.rollback()
            throw error
        }
    }

    func setChildrenMailFolders(googles: [Google.MailFolder], parent parentID: PersistentID<MailFolder>, in accountID: PersistentID<Account>) throws -> [MailFolder] {
        let parent = self[parentID]!
        let account = self[accountID]!
        do {
            var inserts: [MailFolder] = []
            for google in googles {
                try inserts.append(modelContext._insertMailFolder(google: google, parent: parent, in: account))
            }
            
            // delete
            let removings = try modelContext._fetchMailFolderNotIn(inserts, in: parent)
            try removings.forEach { _ = try modelContext._deleteMailFolder($0) }
            
            try modelContext.save()
            return inserts
        } catch {
            modelContext.rollback()
            throw error
        }
    }
}
