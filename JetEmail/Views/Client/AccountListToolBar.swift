//
//  AccountsToolBar.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI

struct AccountListToolbar : View {
    
    @Environment(AppContext.self)
    var context
    
    @Environment(SettingsModel.self)
    var settings
    
    var body: some View {
        HStack {
            // Feature: Accounts - Add Account
            Button("Add", systemImage: "plus") {
                Task { await context.addAccount() }
            }//.disabled(context.isBusy)
            
            // Feature: Accounts - Remove Account
            Button("Remove", systemImage: "minus") {
                guard let account = settings.selectedAccount else { return }
                Task { await context.removeAccount(account) }
            }.disabled(settings.selectedAccount?.isBusy ?? true)
            

            Spacer()
            
            // Feature: Accounts - Load Accounts
            RefreshButton(isBusy: context.isBusy) { context.loadAccounts() }
        }
        .padding(4)
        .buttonStyle(.borderless)
    }
}
