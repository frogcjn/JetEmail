//
//  Client.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

import Google
import Microsoft

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


extension AppModel {
    func _signIn(platform: Platform) async throws {
        switch platform {
        case .microsoft: _ = try await BackgroundModelActor.shared.addSession(.microsoft(microsoftClient.signIn()))
        case .google:    _ = try await BackgroundModelActor.shared.addSession(   .google(   googleClient.signIn()))
        }
    }
}

fileprivate extension Microsoft.Client {
    func signIn() async throws -> Microsoft.Session {
        try await _msalSignIn().lazySession
    }
}

fileprivate extension Google.Client {
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
    }
}

