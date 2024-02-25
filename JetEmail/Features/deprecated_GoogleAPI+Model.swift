//
//  Model+GoogleAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/18/24.
//

// MARK: - Model <-> MSGraph
/*
extension Account {
    convenience init(google: Google.Account, orderIndex: Int) throws {
        self.init(
            modelID: google.modelID,
            username: google.username,
            orderIndex: orderIndex
        )
    }
    
    func update(google: Google.Account, deleteMark: Bool = false) {
        if self.modelID == google.modelID && self.username == google.username && self.deleteMark == deleteMark { return }
        self.deleteMark = deleteMark
        self.modelID  = google.modelID
        self.username = google.username
    }
    /*
    var googleAccount: Google.Account? {
        @available(macOS, unavailable, message: "Parse Use graph(_ client: MSGraph) instead.")
        @available(iOS, unavailable, message: "Parse Use graph(_ client: MSGraph) instead.")
        get {
            nil // should use graph(_:)
            // self.graph
        }
        set {
            guard let google = newValue else { return }
            self.modelID  = google.modelID
            self.username = google.username
        }
    }*/
}

*/

/*.onChange(of: account.hasAccount, initial: true) {
    Task {
        await account.updateState()
    }
}
.onChange(of: account.hasSession, initial: true) {
    Task {
        await account.updateState()
    }
}*/


/*// Feature: Accounts - Remove Account
/// Remove an account from `MSGraph.Context` and `ModelContext`.
/// - Parameter account: the account to remove.
@MainActor // for isAppModelBusy, item.isBusy
func removeAccountForGoogle(_ model: Account) async {
    await model.removeAccount()
}*/

/*// Feature: Accounts - Remove Account
/// Remove an account from `MSGraph.Context` and `ModelContext`.
/// - Parameter account: the account to remove.
@MainActor // for isAppModelBusy, item.isBusy
func removeAccount(_ model: Account) async {
    await AppItemModel(context: self, item: model).delete()
}*/



/*func loadMailFolders(account accountPersistentID: PersistentID<Account>) async throws {
    BackgroundModelActor.assertIsolated()
    
    let account = self[accountPersistentID]!
    
    switch try await account.refreshedIfExpiredSession {
    case .microsoft(let session):
        let microsoftRoot = try await session.getRootMailFolder()
        let root = try modelContext.setRootMailFolder(microsoft: microsoftRoot, in: account.persistentID)
        
        var queue: [MailFolder] = [root]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            
            let microsofts = try await session.getChildFolders(microsoftID: .init(string: current.platformID))
            let children = try modelContext.setChildrenMailFolders(microsofts: microsofts, parentID: current.persistentID, in: account.persistentID)
            
            queue.append(contentsOf: children)
        }
    case .google(let session):
        let googles = try await session.getMailFolders()
        try modelContext._setMailFolders(googles: googles, in: account)
    default:
        return
    }
}*/

/// Set all messages from graphContext to `ModelContainer`.
/// - Parameters:
///   - elements: Messages from  `MSGraph.Context`.
///   - mailFolder: mai
/// - Returns: Messages from `ModelContainer`.
