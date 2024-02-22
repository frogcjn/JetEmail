//
//  MailSplitView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import SwiftUI

struct MailWindow : View {
    
    @Environment(AppModel.self) // state associate with applciation
    var appModel
    
    @State
    var window = MailWindowModel() // a MainWindowModel instance is associated with each model
    
    var body: some View {
        NavigationSplitView(columnVisibility: Bindable(window).splitViewVisibility) {
            AccountSectionList()
                .navigationSplitViewColumnWidth(min: 220, ideal: 220)
        } content: {
            if let item = window.selectedMailFolder {
                MessageList()
                    .itemModel(item)
            }
        } detail: {
            if let item = window.selectedMessage {
                MessageView()
                    .itemModel(item)
            }
        }
        .labelStyle(.iconOnly)
        
        // Feature: Unselection - Remove Account
        .onReceive(appModel.willRemoveAccount, perform: window.willRemoveAccount(_:))
        .environment(window)
    }
}
