//
//  AccountsToolBar.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import AuthenticationServices

struct AccountListToolbar : View {
    
    @Environment(AppModel.self)
    var appModel
    
    @Environment(SettingsModel.self)
    var settings
    
    @Environment(\.webAuthenticationSession)
    var webAuthenticationSession
    
    var body: some View {
        HStack {
            

            
            // Feature: Accounts - Sign In Account
            Menu {
                Group {
                    Button {
                        Task { await appModel.signIn(platform: .microsoft, webAuthenticationSession: webAuthenticationSession) }
                    } label: {
                        Label("Microsoft Outlook", image: "Outlook")
                    }//.disabled(context.isBusy)
                    
                    Button {
                        Task { await appModel.signIn(platform: .google, webAuthenticationSession: webAuthenticationSession) }
                    } label: {
                        Label("Google Gmail", image: "Gmail")
                    }
                    //.disabled(context.isBusy)
                }
                .labelStyle(.titleAndIcon)
            } label: {
                Label("Sign In", systemImage: "plus")
            }.menuIndicator(.hidden)
            
            // Feature: Accounts - Sign Out Account
            Button("Sign Out", systemImage: "minus") {
                guard let account = settings.selectedAccount else { return }
                Task { await appModel(account).signOut() }
            }.disabled(settings.selectedAccount?.isBusy ?? true)

            Spacer()
            
            // Feature: Accounts - Load Accounts
            RefreshButton(isBusy: appModel.isBusy) {
                Task { await appModel.loadAccounts() }
            }
        }
        .labelStyle(.iconOnly)
        .padding(4)
        .buttonStyle(.borderless)
    }
}
