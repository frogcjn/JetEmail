//
//  LoadMailFolders.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

// MARK: Feature: Account - Load Mail Folder

//@BackgroundActor // for .isBusy
extension AppItemModel<Account> {
    func loadMailFolders() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        
        await Task.detached { [item, logger] in
            do {
                let account = item
                guard let session = try await account.refreshedIfExpiredSession else { return }
                switch session {
                case .microsoft(let session):
                    let microsoftRoot = try await session.getRootMailFolder()
                    let root = try await BackgroundModelActor.shared.setRootMailFolder(microsoft: microsoftRoot, in: account.persistentID)
                    
                    var queue: [MailFolder] = [root]
                    while !queue.isEmpty {
                        let current = queue.removeFirst()
                        
                        let microsofts = try await session.getChildFolders(microsoftID: current.microsoftID!)
                        let children = try await BackgroundModelActor.shared.setChildrenMailFolders(microsofts: microsofts, parent: current.persistentID, in: account.persistentID)
                        
                        queue.append(contentsOf: children)
                    }
                case .google(let session):
                    let googles = try await session.getMailFolders()
                    
                    let root = try await {
                        if let root = account.root {
                            return root
                        } else {
                            let rootGoogleMailFolder = Google.MailFolder(id: .init(string: account.platformID), name: "folder_all_mail") // TODO:
                            let root = try await BackgroundModelActor.shared.setRootMailFolder(google: rootGoogleMailFolder, in: account.persistentID)
                            account.root = root
                            return root
                        }
                    }()
                    
                    _ = try await BackgroundModelActor.shared.setChildrenMailFolders(googles: googles, parent: root.persistentID, in: account.persistentID)
                }
                
            } catch {
                logger.error("\(error)")
            }
        }.value
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
            for google in googles.dropLast() {
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
