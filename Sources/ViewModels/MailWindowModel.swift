//
//  WindowViewModel.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/2/24.
//

import SwiftUI
import JetEmailData // for Message

@Observable
class MailWindowModel {
    
    var splitViewVisibility: NavigationSplitViewVisibility = .all
    
    var selectedMailFolder: MailFolder? = nil 
    // Feature: Unselection - Change SelectedMailFolder
    { willSet { willChangeSelectedMailFolder(oldValue: selectedMailFolder, newValue: newValue) } }
    
    var selectedMessage: Message? = nil
}

extension MailWindowModel {
    
    // Feature: Unselection - Will Sign Out Account
    func willSignOutAccount(_ accountID: AccountID) {
        if selectedMessage?.account?.resourceID == accountID { selectedMessage = nil }
        if selectedMailFolder?.account?.resourceID == accountID { selectedMailFolder = nil }
    }
    
    // Feature: Unselection - Change Selected Mail Folder
    func willChangeSelectedMailFolder(oldValue: MailFolder?, newValue: MailFolder?) {
        if oldValue != newValue {
            selectedMessage = nil
        }
    }
}
