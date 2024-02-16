//
//  MailSplitView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import SwiftUI

struct MailWindow : View {
    
    @Environment(AppContext.self) // state associate with applciation
    var context
    
    @Environment(MailWindowModel.self)
    var window

    var body: some View {
        NavigationSplitView(columnVisibility: Bindable(window).splitViewVisibility) {
            AccountSectionList()
                .navigationSplitViewColumnWidth(min: 220, ideal: 220)
        } content: {
            if let item = window.selectedMailFolder {
                MessageList()
                    .appContext(item: item)
            }
        } detail: {
            if let item = window.selectedMessage {
                MessageView()
                    .appContext(item: item)
            }
        }
        .labelStyle(.iconOnly)
        
        // Feature: Unselection - Remove Account
        .onReceive(context.willRemoveAccount, perform: window.willRemoveAccount(_:))
    }
}
