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
            try await _signOut(resourceID: item.resourceID)
        } catch {
            logger.error("\(error)")
        }
    }
    
    // @BackgroundActor
    
}


fileprivate func _signOut(resourceID: AccountID) async throws {
    checkBackgroundThread()
    _ = try await resourceID.storedSession?.signOut()
    _ = try await ModelStore.shared.deleteAccount(id: resourceID)
}
