//
//  MailSplitView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import SwiftUI
import JetEmailID

struct MailWindow : View {
    
    @Environment(AppModel.self) // the app model instance is associate with the applciation
    var appModel
    
    @Environment(SettingsModel.self)
    var settings
    
    
    @State  // a MainWindowModel instance is associated with a window
    var window = MailWindowModel()
    
#if !os(macOS)
    @State
    var isPresentingSettings = false
#endif
    
    @Environment(\.webAuthenticationSession)
    var webAuthenticationSession

    var body: some View {
        NavigationSplitView(columnVisibility: Bindable(window).splitViewVisibility) {
            AccountSectionList()
                .navigationSplitViewColumnWidth(min: 220, ideal: 220)
        } content: {
            if let item = window.selectedMailFolder {
                MessageList()
                    .itemModel(item)
                    .itemModel(item.account)
            }
        } detail: {
            if let item = window.selectedMessage {
                MessageView()
                    .itemModel(item)
                    .itemModel(item.mailFolder)
                    .itemModel(item.account)
            }
        }
        
        // Feature: Unselection - Will Sign Out Account
        .onReceive(appModel.willSignOutAccount, perform: window.willSignOutAccount(_:))
        
        .environment(window)
        
        #if !os(macOS)
        // Settings
        .sheet(isPresented: Bindable(settings).isPresenting) {
            SettingsView()
                .frame(width: 600, height: 300)
        }
        #endif
    }
}
