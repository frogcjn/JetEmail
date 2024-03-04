//
//  SignOut.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

// MARK: Feature: Accounts - Sign Out

extension AppItemModel<Account> {

    @MainActor // for isBusy, willSignOutAccount
    func signOut() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
                
        let model = item
        
        // Feature: Unselection - Will Sign Out Account
        context.willSignOutAccount.send(model)
        
        do {

            _ = try await item.session?.signOut()
            item.session = nil
            _ = try await BackgroundModelActor.shared.deleteAccount(itemModel: self, id: item.persistentID)
        } catch {
            logger.error("\(error)")
        }
    }
}


