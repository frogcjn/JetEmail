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
            guard let session = try await accountID.refreshSession else { return }                     // get Session
            _ = try await session.loadMailFolders(accountID: accountID, modelStore: modelStore) // Session, ModelStore
        } catch {
            logger.error("\(error)")
        }
    }
}
