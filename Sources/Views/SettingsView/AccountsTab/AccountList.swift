//
//  AccountList.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import SwiftData // for @Query
import JetEmailData

struct AccountList: View {
    
    @Environment(SettingsModel.self)
    var settings
    
    @Environment(AppModel.self)
    var appModel
    
    @Query(filter: #Predicate { !$0.deleteMark } , sort: \Account.orderIndex, order: .forward)
    var accounts: [Account]
    
    var body: some View {
        List(selection: Bindable(settings).selectedAccount) {
            ForEach(accounts) { account in
                AccountCell()
                    .environment(account)
                    .tag(account)
            }
            
            // Feature: Accounts - Move Accounts
            .onMove { source, destination in
                Task { await appModel.moveAccounts(accountIDs: accounts.map(\.resourceID), fromOffsets: source, toOffset: destination) }
            }
        }
        .safeAreaInset(edge: .bottom) {
            AccountListToolbar()
        }
        
        // Feature: Accounts - Load Accounts
        .task { await appModel.loadAccounts() }
        
        // Feature: Unselection - Will Sign Out Account
        .onReceive(appModel.willSignOutAccount, perform: settings.willSignOutAccount(_:))
    }
}
