//
//  Client.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

import Google
import Microsoft
import Foundation
import JetEmail_Foundation
import JetEmail_Data

enum Client {
    static var sessions: [JetEmail_Data.Session] { get async throws {
        async let microsoftSessions = Microsoft.Client.shared.sessions.map(JetEmail_Data.Session.microsoft)
        async let googleSessions = Google.Client.shared.sessions.map(JetEmail_Data.Session.google)
        return try await microsoftSessions + googleSessions
    } }
}

extension JetEmail_Data.Session {
    func signOut() async throws -> JetEmail_Data.Session {
        switch self {
        case .microsoft(let session): _ = try await session.signOut()
        case .google(let platformSession): _ = try await platformSession.signOut()
        }
        return self
    }
}





extension JetEmail_Data.Session {
    func loadMailFolders(persistentID: JetEmail_Data.Account.ID, modelID: JetEmail_Data.Account.ID) async throws  {
        checkBackgroundThread()
        switch self {
        case .microsoft(let session): try await session.loadMailFolders(persistentID: persistentID)
        case .google(let session): try await session.loadMailFolders(persistentID: persistentID, modelID: modelID)
        }
    }
}

extension Microsoft.Session {
    var idToWellKnownFolderName:  [Microsoft.MailFolder.ID: Microsoft.MailFolder.WellKnownFolderName] { get async {
        do {
            // catch wellknownFolderName
            var idToWellKnownFolderName = [Microsoft.MailFolder.ID: Microsoft.MailFolder.WellKnownFolderName]()
            for name in Microsoft.MailFolder.WellKnownFolderName.allCases {
                do {
                    let folder = try await getMailFolder(wellKnownFolderName: name)
                    idToWellKnownFolderName[folder.id] = name
                } catch let error as Microsoft.PublicError where error.code == "ErrorFolderNotFound" {
                    continue
                }
            }
            return idToWellKnownFolderName
        } catch {
            return [:]
        }
    } }
    
    func loadMailFolders(persistentID: JetEmail_Data.Account.ID) async throws {
        var microsoftRoot = try await getRootMailFolder()
        microsoftRoot.wellKnownFolderName = .msgFolderRoot
        let (rootPersistentID, modelID) = try await ModelStore.instance.setRootMailFolder(microsoft: microsoftRoot, in: persistentID)
        
        
        let idToWellKnownFolderName = await idToWellKnownFolderName
        
        var queue: [(persistentID: JetEmail_Data.MailFolder.ID, modelID: JetEmail_Data.MailFolder.ID)] = [(rootPersistentID, modelID)]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            
            let id = current.modelID.microsoftID! as Microsoft.MailFolder.ID
            var mailFolders = try await self.getChildFolders(id: id)
            mailFolders = mailFolders.map {
                var mailFolder = $0
                if let wellKnownFolderName = idToWellKnownFolderName[mailFolder.id] { mailFolder.wellKnownFolderName = wellKnownFolderName }
                return mailFolder
            }
            
            let children = try await ModelStore.instance.setChildrenMailFolders(microsofts: mailFolders, parent: current.persistentID, in: persistentID)
            
            queue.append(contentsOf: children)
        }
    }
}

extension Google.Session {
    func loadMailFolders(persistentID: JetEmail_Data.Account.ID, modelID: JetEmail_Data.Account.ID) async throws {
        let rootElement = Google.MailFolder(id: .init(rawValue: "$" + modelID.platformID + ":folder_all_mail"), name: "folder_all_mail")
        let tree = try await getMailFolderTree(rootElement: rootElement)
        let root = try await ModelStore.instance.setRootMailFolder(google: rootElement, in: persistentID)
        var queue: [((persistentID: JetEmail_Data.MailFolder.ID, modelID: JetEmail_Data.MailFolder.ID), google: TreeNode<Google.MailFolder>)] = [((root.persistentID, root.modelID), tree.root)]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            
            let googles = current.google.children.map(\.element)
            let children = try await ModelStore.instance.setChildrenMailFolders(googles: googles, parent: current.0.persistentID, in: persistentID)
            
            queue.append(contentsOf: Array(zip(children, current.google.children)))
        }
    }
}





/*

extension Tree<Google.MailFolder> {
    func element(forPath path: [String]) -> Google.MailFolder? {
        var current: TreeNode<Google.MailFolder>? = root
        var currentPath = path
        
        while let unwrappedCurrent = current {
            unwrappedCurrent.children.first { $0.path ==  }
        }
    }
}
*/
