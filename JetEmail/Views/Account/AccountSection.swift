//
//  MailFolderSection.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/12/24.
//

import SwiftUI
import SwiftData // for @Query

fileprivate struct _AcciontSection: View {
    
    @Environment(AppContext.Item<Account>.self)
    var context
    
    @Query
    var rootChildren: [MailFolder]
    
    var body: some View {
        Section {
            OutlineGroup(rootChildren, children: \.children.nilIfEmpty) { item in
                MailFolderCell()
                    .appContext(item: item)
                    .tag(item) // selection tag
            }
        } header: {
            
            // Feature: Account - Load Mail Folders
            AccountSectionHeader() { 
                await context.loadMailFolders()
                _rootChildren.update()
            }
        }
        
        // Feature: Account - Load Mail Folders
        .task {
            await context.loadMailFolders()
            _rootChildren.update()
        }
    }
}


struct AccountSection: View {
    @Environment(Account.self)
    var account
    
    var body: some View {
        let rootID = account.root?.id
        _AcciontSection(_rootChildren: Query(filter: #Predicate { $0.parent?.id == rootID && !$0.deleteMark }, sort: \MailFolder.name))
    }
}
