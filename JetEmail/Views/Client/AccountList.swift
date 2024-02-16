//
//  AccountList.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import SwiftData // for @Query

struct AccountList: View {
    
    @Environment(AppContext.self)
    var context
    
    @Environment(SettingsModel.self)
    var settings
    
    @Query(filter: #Predicate<Account> { !$0.deleteMark },  sort: \Account.orderIndex)
    var accounts: [Account]
    
    var body: some View {
        List(selection: Bindable(settings).selectedAccount) {
            ForEach(accounts) { item in
                AccountCell()
                    .appContext(item: item)
                    .tag(item)
            }
            
            // Feature: Accounts - Move Accounts
            .onMove { source, destination in
                context.moveAccounts(accounts, fromOffsets: source, toOffset: destination)
            }
        }
        .safeAreaInset(edge: .bottom) {
            AccountListToolbar()
        }
        
        // Feature: Unselection - Remove Account
        .onReceive(context.willRemoveAccount, perform: settings.willRemoveAccount(_:))
    }
}
