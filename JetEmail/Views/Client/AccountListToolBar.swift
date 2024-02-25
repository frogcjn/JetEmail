//
//  AccountsToolBar.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI

struct AccountListToolbar : View {
    
    @Environment(AppModel.self)
    var appModel
    
    @Environment(SettingsModel.self)
    var settings
    
    var body: some View {
        HStack {
            
            // Feature: Accounts - Sign In Account
            Button("Sign In Microsoft Account", systemImage: "plus") {
                Task { await appModel.signIn(platform: .microsoft) }
            }//.disabled(context.isBusy)
            
            // Feature: Accounts - Sign In Account
            Button("Sign In Google Account", systemImage: "plus") {
                Task { await appModel.signIn(platform: .google) }
            }//.disabled(context.isBusy)
            
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
        .padding(4)
        .buttonStyle(.borderless)
    }
}
