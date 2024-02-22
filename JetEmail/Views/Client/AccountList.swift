//
//  AccountList.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import SwiftData // for @Query

struct AccountList: View {
    
    @Environment(AppModel.self)
    var appModel
    
    @Environment(SettingsModel.self)
    var settings
    
    @Query(filter: #Predicate<Account> { !$0.deleteMark },  sort: \Account.orderIndex)
    var accounts: [Account]
    
    var body: some View {
        List(selection: Bindable(settings).selectedAccount) {
            ForEach(accounts) { item in
                AccountCell()
                    .itemModel(item)
                    .tag(item)
            }
            
            // Feature: Accounts - Move Accounts
            .onMove { source, destination in
                Task { await appModel.moveAccounts(accounts, fromOffsets: source, toOffset: destination) }
            }
        }
        .safeAreaInset(edge: .bottom) {
            AccountListToolbar()
        }
        
        // Feature: Accounts - Load Accounts
        .onAppear {
            Task {
                await appModel.loadAccounts()
                _accounts.update()
            }
        }
        
        // Feature: Unselection - Will Remove Account
        .onReceive(appModel.willRemoveAccount, perform: settings.willRemoveAccount(_:))
    }
}
