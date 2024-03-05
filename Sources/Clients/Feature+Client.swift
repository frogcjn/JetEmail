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

enum Client {
    static var sessions: [Session] { get async throws {
        let microsoftSessions = try await Microsoft.Client.shared.sessions.map(Session.microsoft)
        let googleSessions = try await Google.Client.shared.sessions.map(Session.google)
        return microsoftSessions + googleSessions
    } }
}

fileprivate extension Microsoft.Client {
    var sessions: [Microsoft.Session] { get async throws {
        try await _msalAccounts.asyncMap { try await $0.lazySession }
    } }
}

fileprivate extension Google.Client {
    var sessions: [Google.Session] { get async throws {
        try await keychain.items.map(\.lazySession)
    } }
}

extension Microsoft.Client {
    func signIn() async throws -> Microsoft.Session {
        try await _msalSignIn().lazySession
    }
}

extension Google.Client {
    func signIn() async throws -> Google.Session {
        try await _gtmSignIn().insertTo(keychain: keychain).lazySession
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
    func signOut() async throws -> Microsoft.Session {
        _ = try await Microsoft.Client.shared._msalSignout(msalAccount: _msalSession.account)
        return self
    }
}

extension Google.Session {
    func signOut() async throws -> Google.Session {
        _ = try await item.deleteFrom(keychain: Google.Keychain.shared)
        return self
    }
}

extension Session {
    func loadMailFolders(account: Account) async throws  {
        switch self {
        case .microsoft(let session): try await session.loadMailFolders(account: account)
        case .google(let session): try await session.loadMailFolders(account: account)
        }
    }
}

extension Microsoft.Session {
    func loadMailFolders(account: Account) async throws {
        var microsoftRoot = try await getRootMailFolder()
        microsoftRoot.wellKnownFolderName = .msgFolderRoot
        let root = try await BackgroundModelActor.shared.setRootMailFolder(microsoft: microsoftRoot, in: account.persistentID)
        
        
        var folderToWellKnownFolderName = [Microsoft.MailFolder.ID: Microsoft.MailFolder.WellKnownFolderName]()
        for name in Microsoft.MailFolder.WellKnownFolderName.allCases {
            do {
                let folder = try await getMailFolder(wellKnownFolderName: name)
                folderToWellKnownFolderName[folder.id] = name
            } catch let error as Microsoft.PublicError where error.code == "ErrorFolderNotFound" {
                continue
            }
        }
        
        var queue: [MailFolder] = [root]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            
            var mailFolders = try await getChildFolders(microsoftID: current.microsoftID!)
            mailFolders = mailFolders.map {
                var mailFolder = $0
                if let wellKnownFolderName = folderToWellKnownFolderName[mailFolder.id] {
                    mailFolder.wellKnownFolderName = wellKnownFolderName
                }
                return mailFolder
            }
            
            let children = try await BackgroundModelActor.shared.setChildrenMailFolders(microsofts: mailFolders, parent: current.persistentID, in: account.persistentID)
            
            queue.append(contentsOf: children)
        }
    }
}

extension Google.Session {
    func loadMailFolders(account: Account) async throws {
        let rootElement = Google.MailFolder(id: .init(string: "$" + account.platformID + ":folder_all_mail"), name: "folder_all_mail")
        let tree = try await getMailFolderTree(rootElement: rootElement)
        let root = try await BackgroundModelActor.shared.setRootMailFolder(google: rootElement, in: account.persistentID)
        var queue: [(model: MailFolder, google: TreeNode<Google.MailFolder>)] = [(root, tree.root)]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            
            let googles = current.google.children.map(\.element)
            let children = try await BackgroundModelActor.shared.setChildrenMailFolders(googles: googles, parent: current.model.persistentID, in: account.persistentID)
            
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
