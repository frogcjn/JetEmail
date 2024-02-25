//
//  ViewModels+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

// MARK: - View Context

extension SettingsModel {
    
    // Feature: Unselection - Will Sign Out Account
    func willSignOutAccount(_ account: Account) {
        if selectedAccount == account { selectedAccount = nil }
    }
}

extension MailWindowModel {
    
    // Feature: Unselection - Will Sign Out Account
    func willSignOutAccount(_ account: Account) {
        if selectedMessage?.mailFolder.account == account { selectedMessage = nil }
        if selectedMailFolder?.account == account { selectedMailFolder = nil }
    }
    
    // Feature: Unselection - Change Selected Mail Folder
    func willChangeSelectedMailFolder(oldValue: MailFolder?, newValue: MailFolder?) {
        if selectedMessage?.mailFolder != newValue { selectedMessage = nil }
    }
}
