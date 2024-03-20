//
//  APIView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/31/24.
//

import SwiftUI
import SwiftData    // for @Query
import JetEmailData // for account

@MainActor
struct AccountSectionList : View, Sendable {

    @Environment(AppModel.self)
    var appModel
    
    @Environment(SettingsModel.self)
    var settings
    
    @Environment(MailWindowModel.self)
    var window
        
    @Query(filter: #Predicate<Account> { !$0.deleteMark },  sort: \Account.orderIndex)
    var accounts: [Account]
    
    var body: some View {
        Group {
            if accounts.isEmpty {
                #if os(macOS)
                SettingsLink {
                    Text("Open Settings to login in…")
                }
                #else
                Button("Open Settings to login in…") {
                    settings.isPresenting = true
                }
                #endif
            } else {
                List(selection: Bindable(window).selectedMailFolder) {
                    ForEach(accounts) { item in
                        AccountSection()
                            .environment(item)
                    }
                    
                    // Feature: Accounts - Move Accounts
                    .onMove { source, destination in
                        Task { await appModel.moveAccounts(accountIDs: accounts.map(\.resourceID), fromOffsets: source, toOffset: destination) }
                    }
                }
            }
        }
        
        // Feature: Accounts - Load Accounts
        .task { await appModel.loadAccounts() }
        
        // Feature: Account - Load Mail Folders
        .onChange(of: accounts, initial: true) { (oldValue, newValue) in
            let accoundIDs = newValue.filter { !$0.loadedMailFolder }.map(\.resourceID)
            Task{ await appModel.loadMailFolders(accountIDs: accoundIDs) }
        }
        
        #if !os(macOS)
        .toolbar {
            Button("Settings") {
                settings.isPresenting = true
            }
        }
        #endif
         
        
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


