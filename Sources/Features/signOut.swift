//
//  SignOut.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

import JetEmail_Foundation
import JetEmail_Data

// MARK: Feature: Accounts - Sign Out

extension AppItemModel<Account> {

    @MainActor // for isBusy, willSignOutAccount
    func signOut() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
                        
        // Feature: Unselection - Will Sign Out Account
        context.willSignOutAccount.send(item)
        
        do {
            try await _signOut(modelID: item.id, persistentID: item.id)
        } catch {
            logger.error("\(error)")
        }
    }
    
    // @BackgroundActor
    
}


fileprivate func _signOut(modelID: Account.ID, persistentID: Account.ID) async throws {
    checkBackgroundThread()
    _ = try await modelID.storedSession?.signOut()
    _ = try await ModelStore.shared.deleteAccount(id: persistentID)
}
