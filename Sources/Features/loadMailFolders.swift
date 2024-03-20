//
//  LoadMailFolders.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

// MARK: Feature: Account - Load Mail Folder

import JetEmailData // for AcocuntID

extension AppModel {
    
    @MainActor
    func loadMailFolders(accountIDs: [AccountID]) async {
        do {
            try await accountIDs.forEachTask { await self.loadMailFolders(accountID: $0) }
        } catch {
            logger.error("\(error)")
        }
    }

    @MainActor
    func loadMailFolders(accountID: AccountID) async {
        guard !accountID.isBusy else { return }
        accountID.isBusy = true
        defer {accountID.isBusy = false }
        
        do {
            guard let session = try await accountID.refreshSession else { return }              // get Session
            
            // loadRootMailFolder

            let rootMailFolder = try await session.getRootMailFolder()                                 // Session
            _ = try await modelStore.setRootMailFolder(resource: rootMailFolder, accountID: accountID)  // ModelStore
            
            /*// update mainContext for root
            let account = try mainContext[accountID]
            account.root = account.root*/
            
            // loadMailFolders under root
            try await session.loadMailFoldersUnderRoot(root: rootMailFolder, modelStore: modelStore) // Session, ModelStore
            
            // record loadedMailFolder
            accountID.loadedMailFolder = true
            
        } catch {
            logger.error("\(error)")
        }
    }
}
