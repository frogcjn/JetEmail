//
//  MailFolderSection.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/12/24.
//

import SwiftUI
import SwiftData // for @Query

fileprivate struct _AcciontSection: View {
    
    
    @Query
    var rootChildren: [MailFolder]
    
    var body: some View {
        OutlineGroup(rootChildren, children: \.children.nilIfEmpty) { item in
            MailFolderCell()
                .itemModel(item)
                .tag(item) // selection tag
        }
    }
}


struct AccountSection: View {
    @Environment(AppItemModel<Account>.self)
    var account
    
    var body: some View {
        Section {
            if let rootID = account.root?.id {
                _AcciontSection(_rootChildren: Query(filter: #Predicate { rootID != nil && $0.parent?.id == rootID && !$0.deleteMark }, sort: \MailFolder.name))
            } else {
                Color.red
            }
            
        } header: {
            // Feature: Account - Load Mail Folders
            AccountSectionHeader() {
                await account.loadMailFolders()
            }
        }
        .task {
            // Feature: Account - Load Mail Folders
            await account.loadMailFolders()
        }
    }
}
