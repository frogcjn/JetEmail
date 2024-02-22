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
            // Feature: Accounts - Add Account
            Button("Add Microsoft Account", systemImage: "plus") {
                Task { await appModel.addAccount(platform: .microsoft) }
            }//.disabled(context.isBusy)
            
            // Feature: Accounts - Add Account
            Button("Add Google Account", systemImage: "plus") {
                Task { await appModel.addAccount(platform: .google) }
            }//.disabled(context.isBusy)
            
            // Feature: Accounts - Remove Account
            Button("Remove", systemImage: "minus") {
                guard let account = settings.selectedAccount else { return }
                Task { await appModel(account).delete() }
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
