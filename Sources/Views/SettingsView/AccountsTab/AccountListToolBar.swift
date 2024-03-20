//
//  AccountsToolBar.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI

struct AccountListToolbar : View {
    
    @Environment(SettingsModel.self)
    var settings
    
    @Environment(AppModel.self)
    var appModel
    
    var body: some View {
        HStack {
            

            
            // Feature: Accounts - Sign In Account
            Menu {
                Group {
                    Button {
                        Task { 
                            await appModel.signIn(platform: .microsoft, delay: true)
                        }
                    } label: {
                        Label("Microsoft Outlook", image: "Outlook")
                    }//.disabled(context.isBusy)
                    
                    Button {
                        
                        
                        Task {
                            await appModel.signIn(platform: .google, delay: true)
                        }
                    } label: {
                        Label("Google Gmail", image: "Gmail")
                    }
                    //.disabled(context.isBusy)
                }
                .labelStyle(.titleAndIcon)
            } label: {
                Label("Sign In", systemImage: "plus")
            }.menuIndicator(.hidden)
            .disabled(appModel.isBusy)
            
            // Feature: Accounts - Sign Out Account
            Button("Sign Out", systemImage: "minus") {
                guard let account = settings.selectedAccount else { return }
                Task { await appModel.signOut(accountID: account.resourceID) }
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
