//
//  Client.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

import JetEmailGoogle
import JetEmailMicrosoft
import Foundation
import JetEmailFoundation // Tree
import JetEmailData
import JetEmailID

enum Client {
    static var sessions: [Session] { get async throws {
        async let microsoftSessions = MicrosoftClient.shared.sessions.map(Session.microsoft)
        async let googleSessions = GoogleClient.shared.sessions.map(Session.google)
        return try await microsoftSessions + googleSessions
    } }
}

extension Session {
    func signOut() async throws -> Session {
        switch self {
        case .microsoft(let session): _ = try await session.signOut()
        case .google(let platformSession): _ = try await platformSession.signOut()
        }
        return self
    }
}



extension AccountID {
    
    @MainActor
    func setRootMailFolder(id: MailFolderID) throws -> MailFolderID {
        let account = try mainContext[self]!
        let mailFolder = try mainContext[id]!
        try mainContext.transaction {
            account.root = mailFolder // set root mail folder relation on main
        }
        return mailFolder.resourceID
    }
}

extension Session {
    
    func getRootMailFolder(id: AccountID) async throws -> PlatformCase<MicrosoftMailFolder, GoogleMailFolder> {
        checkBackgroundThread()
        switch self {
        case .microsoft(let session): return .microsoft(try await session.getRootMailFolder())
        case    .google(let session): return    .google(          session.getRootMailFolder())
        }
    }
    

    
    func loadMailFolders(id: AccountID, rootID: MailFolderID) async throws  {
        checkBackgroundThread()
        switch self {
        case .microsoft(let session): try await session.loadMailFolders(id: id, rootID: rootID)
        case    .google(let session): try await session.loadMailFolders(id: id)
        }
    }
}

extension MicrosoftSession {
    
    @MainActor
    var idToWellKnownFolderName:  [MicrosoftMailFolderID: MicrosoftMailFolder.WellKnownFolderName] { get async {
        if let idToWellKnownFolderName = accountID.general.idToWellKnownFolderName { return idToWellKnownFolderName }
        let idToWellKnownFolderName: [MicrosoftMailFolderID: MicrosoftMailFolder.WellKnownFolderName] =  await {
            do {
                // catch wellknownFolderName
                var idToWellKnownFolderName = [MicrosoftMailFolderID: MicrosoftMailFolder.WellKnownFolderName]()
                for name in MicrosoftMailFolder.WellKnownFolderName.allCases {
                    do {
                        let folder = try await getMailFolder(wellKnownFolderName: name)
                        idToWellKnownFolderName[folder.id] = name
                    } catch let error as JetEmailMicrosoft.PublicError where error.code == "ErrorFolderNotFound" {
                        continue
                    }
                }
                return idToWellKnownFolderName
            } catch {
                return [:]
            }
        }()
        accountID.general.idToWellKnownFolderName = idToWellKnownFolderName
        return idToWellKnownFolderName
    } }
    
    
    func loadMailFolders(id: AccountID, rootID:  MailFolderID) async throws {
        let idToWellKnownFolderName = await idToWellKnownFolderName
        var queue: [MailFolderID] = [rootID]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            
            let mailFolderID = current.microsoft! as MicrosoftMailFolderID
            var mailFolders = try await self.getChildFolders(id: mailFolderID)
            mailFolders = mailFolders.map {
                var mailFolder = $0
                if let wellKnownFolderName = idToWellKnownFolderName[mailFolder.id] { mailFolder.wellKnownFolderName = wellKnownFolderName }
                return mailFolder
            }
            
            let children = try await ModelStore.shared.setChildrenMailFolders(platform: mailFolders.map(PlatformCase.microsoft), parent: current, in: id)
            queue.append(contentsOf: children)
        }
    }
}

extension GoogleSession {
    
    func getRootMailFolder() -> GoogleMailFolder {
        GoogleMailFolder(self, data: GoogleMailFolderData(id: .init("folder_all_mail"), name: "folder_all_mail"))
    }
    
    func loadMailFolders(id: AccountID) async throws {
        guard let rootElement = try await ModelStore.shared.rootGoogleMailFolder(in: id) else { return }
        let tree = try await getMailFolderTree(rootElement: rootElement)
        var queue: [TreeNode<GoogleMailFolder>] = [tree.root]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            
            let googles = current.children.map(\.element)
            _ = try await ModelStore.shared.setChildrenMailFolders(platform: googles.map(PlatformCase.google), parent: current.element.id.general, in: id)
            
            queue.append(contentsOf: current.children)
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
