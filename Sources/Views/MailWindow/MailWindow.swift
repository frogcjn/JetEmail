//
//  MailSplitView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import SwiftUI

struct MailWindow : View {
    
    @Environment(SettingsModel.self)
    var settings
    
    @State  // a MainWindowModel instance is associated with a window
    var window = MailWindowModel()
    
    @Environment(AppModel.self) // the app model instance is associate with the applciation
    var appModel
    
#if !os(macOS)
    @State
    var isPresentingSettings = false
#endif

    var body: some View {
        NavigationSplitView(columnVisibility: Bindable(window).splitViewVisibility) {
            AccountSectionList()
                .navigationSplitViewColumnWidth(min: 220, ideal: 220)
        } content: {
            if let mailFolder = window.selectedMailFolder {
                let account = mailFolder.account
                MessageList()
                    .environment(mailFolder)
                    .environment(account)
            }
        } detail: {
            if let message = window.selectedMessage, let mailFolder = window.selectedMailFolder  {
                let account = message.account
                MessageView()
                    .environment(message)
                    .environment(mailFolder)
                    .environment(account)
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
