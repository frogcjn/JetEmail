//
//  APIView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/31/24.
//

import SwiftUI
import SwiftData

struct AccountSectionList : View {

    @Environment(AppContext.self)
    var context
    
    @Environment(MailWindowModel.self)
    var window
    
    @Query(filter: #Predicate<Account> { !$0.deleteMark },  sort: \Account.orderIndex)
    var accounts: [Account]
    
    var body: some View {
        Group {
            if accounts.isEmpty {
                SettingsLink {
                    Text("Open Settings to login in…")
                }
            } else {
                List(selection: Bindable(window).selectedMailFolder) {
                    ForEach(accounts) { item in
                        AccountSection()
                            .appContext(item: item)
                    }
                    
                    // Feature: Accounts - Move Accounts
                    .onMove { source, destination in
                        context.moveAccounts(accounts, fromOffsets: source, toOffset: destination)
                    }
                }
            }
        }
        
        // Feature: Accounts - Load Accounts
        .task {
            context.loadAccounts()
        }
         
        
        /*Section("target mail folders", isExpanded: $isExpanded) {
         OutlineGroup(
         model.targetFolderTreeRootChildren,
         id: \.value.,
         children: \.children.nilIfEmpty
         ) { item in
         Text(item.value.)
         }
         }*/
    }
}


