//
//  LoadMailFolders.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

// MARK: Feature: Account - Load Mail Folder

import JetEmailData // for AcocuntID

public extension AppModel {
    
    @MainActor
    func loadMailFolders(accountIDs: [AccountID]) async {
        await accountIDs.forEachTask { await self.loadMailFolders(accountID: $0) }
    }

    @MainActor
    func loadMailFolders(accountID: AccountID) async {
        guard !accountID.isBusy else { return }
        accountID.isBusy = true
        defer {accountID.isBusy = false }
        
        do {
            try await Task.detached { try await self._loadMailFolders(accountID: accountID) }.value
        } catch {
            logger.error("\(error)")
        }
    }
    
    // @BackgroundThreadPool
    nonisolated
    private func _loadMailFolders(accountID: AccountID) async throws {
        let session = try await accountID.refreshSession             // get Session
        
        // loadRootMailFolder
        let rootMailFolder = try await session.rootMailFolder()                                 // Session
        _ = try await modelStore.setRootMailFolder(resource: rootMailFolder, accountID: accountID)  // ModelStore
        
        /*// update mainContext for root
        await MainActor.run {
            let account = try mainContext[accountID]
            account.root = account.root
        }*/
        
        // loadMailFolders under root
        try await session.loadMailFoldersUnderRoot(root: rootMailFolder, modelStore: modelStore) // Session, ModelStore
        
        // record loadedMailFolder
        await MainActor.run {
            accountID.loadedMailFolder = true
        }
    }
}

enum AppModelError : Error {
    case noSession
}
