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
    
    @Environment(AppModel.self)
    var appModel
    
    @Environment(SettingsModel.self)
    var settings
    
    @Query(filter: #Predicate { $0.deleteMark == false } , sort: \Account.orderIndex, order: .forward)
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
        .task { await appModel.loadAccounts() }
        
        // Feature: Unselection - Will Sign Out Account
        .onReceive(appModel.willSignOutAccount, perform: settings.willSignOutAccount(_:))
    }
}
