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
@preconcurrency import GTMAppAuth
@preconcurrency import MSAL

enum Client {
    static var sessions: [Session] { get async throws {
        async let microsoftSessions = Microsoft.Client.shared.sessions.map(Session.microsoft)
        async let googleSessions = Google.Client.shared.sessions.map(Session.google)
        return try await microsoftSessions + googleSessions
    } }
}

fileprivate extension Microsoft.Client {
    var sessions: [Microsoft.Session] { get async throws {
        try await _msalAccounts.asyncMap { @MainActor in try await $0.lazySession }
    } }
}

fileprivate extension Google.Client {
    @MainActor
    var sessions: [Google.Session] { get async throws {
        try await Google.Keychain.shared.items.map { $0.lazySession }
    } }
}

extension Microsoft.Client {
    func signIn() async throws -> Microsoft.Session {
        try await _msalSignIn().lazySession
    }
}

extension Google.Client {
    func signIn() async throws -> Google.Session {
        try await _gtmSignIn().insertTo(keychain: .shared).lazySession
    }
}

extension Session {
    func signOut() async throws -> Session {
        switch self {
        case .microsoft(let platformSession): _ = try await platformSession.signOut()
        case .google(let platformSession): _ = try await platformSession.signOut()
        }
        return self
    }
}

extension Microsoft.Session {
    @MainActor
    func signOut() async throws -> Microsoft.Session {
        _ = try await Microsoft.Client.shared._msalSignout(msalAccount: _msalSession.account)
        return self
    }
}

extension Google.Session {
    func signOut() async throws -> Google.Session {
        _ = try await item.deleteFrom(keychain: .shared)
        return self
    }
}

extension Session {
    func loadMailFolders(persistentID: Account.PersistentID, modelID: Account.ModelID) async throws  {
        checkBackgroundThread()
        switch self {
        case .microsoft(let session): try await session.loadMailFolders(persistentID: persistentID)
        case .google(let session): try await session.loadMailFolders(persistentID: persistentID, modelID: modelID)
        }
    }
}

extension Microsoft.Session {
    func loadMailFolders(persistentID: Account.PersistentID) async throws {
        var microsoftRoot = try await getRootMailFolder()
        microsoftRoot.wellKnownFolderName = .msgFolderRoot
        let (rootPersistentID, modelID) = try await ModelStore.instance.setRootMailFolder(microsoft: microsoftRoot, in: persistentID)
        
        
        var folderToWellKnownFolderName = [Microsoft.MailFolder.ID: Microsoft.MailFolder.WellKnownFolderName]()
        for name in Microsoft.MailFolder.WellKnownFolderName.allCases {
            do {
                let folder = try await getMailFolder(wellKnownFolderName: name)
                folderToWellKnownFolderName[folder.id] = name
            } catch let error as Microsoft.PublicError where error.code == "ErrorFolderNotFound" {
                continue
            }
        }
        
        var queue: [(persistentID: MailFolder.PersistentID, modelID: MailFolder.ModelID)] = [(rootPersistentID, modelID)]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            
            var mailFolders = try await getChildFolders(microsoftID: current.modelID.microsoftID!)
            mailFolders = mailFolders.map {
                var mailFolder = $0
                if let wellKnownFolderName = folderToWellKnownFolderName[mailFolder.id] {
                    mailFolder.wellKnownFolderName = wellKnownFolderName
                }
                return mailFolder
            }
            
            let children = try await ModelStore.instance.setChildrenMailFolders(microsofts: mailFolders, parent: current.persistentID, in: persistentID)
            
            queue.append(contentsOf: children)
        }
    }
}

extension Google.Session {
    func loadMailFolders(persistentID: Account.PersistentID, modelID: Account.ModelID) async throws {
        let rootElement = Google.MailFolder(id: .init(string: "$" + modelID.platformID + ":folder_all_mail"), name: "folder_all_mail")
        let tree = try await getMailFolderTree(rootElement: rootElement)
        let root = try await ModelStore.instance.setRootMailFolder(google: rootElement, in: persistentID)
        var queue: [((persistentID: MailFolder.PersistentID, modelID: MailFolder.ModelID), google: TreeNode<Google.MailFolder>)] = [((root.persistentID, root.modelID), tree.root)]
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
