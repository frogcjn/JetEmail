//
//  WindowViewModel.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/2/24.
//

import SwiftUI

@Observable
class MailWindowModel {
    
    var splitViewVisibility: NavigationSplitViewVisibility = .all
    
    var selectedMailFolder: MailFolder? = nil 
    // Feature: Unselection - Change SelectedMailFolder
    { willSet { willChangeSelectedMailFolder(oldValue: selectedMailFolder, newValue: newValue) } }
    
    var selectedMessage: Message? = nil
}
