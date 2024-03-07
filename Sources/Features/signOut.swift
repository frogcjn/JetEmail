//
//  SignOut.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

import JetEmail_Foundation

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
            try await _signOut(modelID: item.modelID, persistentID: item.persistentID)
        } catch {
            logger.error("\(error)")
        }
    }
    
    // @BackgroundActor
    
}


fileprivate func _signOut(modelID: Account.ModelID, persistentID: Account.PersistentID) async throws {
    checkBackgroundThread()
    _ = try await modelID.session?.signOut()
    await MainActor.run {
        modelID.session = nil
    }
    _ = try await ModelStore.instance.deleteAccount(id: persistentID)
}
