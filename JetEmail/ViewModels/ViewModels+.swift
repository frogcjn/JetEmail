//
//  ViewModels+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

// MARK: - View Context

extension SettingsModel {
    
    // Feature: Remove Account Unselection
    func willRemoveAccount(_ account: Account) {
        if selectedAccount == account {
            selectedAccount = nil
        }
    }
}

extension MailWindowModel {
    
    // Feature: Unselection - Remove Account
    func willRemoveAccount(_ account: Account) {
        if selectedMessage?.mailFolder.account == account {
            selectedMessage = nil
        }
        if selectedMailFolder?.account == account {
            selectedMailFolder = nil
        }
    }
    
    // Feature: Unselection - Change SelectedMailFolder
    func willChangeSelectedMailFolder(oldValue: MailFolder?, newValue: MailFolder?) {
        if selectedMessage?.mailFolder != newValue {
            selectedMessage = nil
        }
    }
}
