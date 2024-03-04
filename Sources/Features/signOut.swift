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
            try await _signOut()
        } catch {
            logger.error("\(error)")
        }
    }
    
    @BackgroundActor
    private func _signOut() async throws {
        _ = try await item.session?.signOut()
        item.session = nil
        _ = try await BackgroundModelActor.shared.deleteAccount(itemModel: self, id: item.persistentID)
    }
}
