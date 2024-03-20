//
//  SignOut.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

// MARK: Feature: Accounts - Sign Out

import JetEmailID
import JetEmailPlatform

extension AppModel {

    @MainActor // for isBusy, willSignOutAccount
    func signOut(accountID: AccountID) async {
        guard !accountID.isBusy else { return }
        accountID.isBusy = true
        defer { accountID.isBusy = false }
        
        // Feature: Unselection - Will Sign Out Account
        willSignOutAccount.send(accountID)
        
        do {
            _ = try await accountID.platformCase?.storedSession?.signOut()      // Session
            _ = try await ModelStore.shared.deleteAccount(accountID: accountID) // ModelStore
        } catch {
            logger.error("\(error)")
        }
    }
}
