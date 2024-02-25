//
//  APIView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/31/24.
//

import SwiftUI
import SwiftData

struct AccountSectionList : View {

    @Environment(AppModel.self)
    var appModel
    
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
                            .itemModel(item)
                    }
                    
                    // Feature: Accounts - Move Accounts
                    .onMove { source, destination in
                        Task { await appModel.moveAccounts(accounts, fromOffsets: source, toOffset: destination) }
                    }
                }
            }
        }
        
        // Feature: Accounts - Load Accounts
        .task {
            await appModel.loadAccounts()
        }
        
        // Feature: Account - Load Mail Folders
        .onChange(of: accounts, initial: true) { Task {
            for account in accounts {
                await appModel(account).loadMailFolders()
            }
        } }
         
        
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


