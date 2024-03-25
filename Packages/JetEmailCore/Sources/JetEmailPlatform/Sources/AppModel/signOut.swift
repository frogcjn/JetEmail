//
//  SignOut.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

// MARK: Feature: Accounts - Sign Out

import JetEmailData // for AccountID

public extension AppModel {

    @MainActor // for isBusy, willSignOutAccount
    func signOut(accountID: AccountID) async {
        guard !accountID.isBusy else { return }
        accountID.isBusy = true
        defer { accountID.isBusy = false }
        
        // Feature: Unselection - Will Sign Out Account
        willSignOutAccount.send(accountID)
        
        do {
            _ = try await accountID.storedSession?.signOut()      // Session
            _ = try await modelStore.deleteAccount(accountID: accountID) // ModelStore
        } catch {
            logger.error("\(error)")
        }
    }
}
