//
//  MailFolderSection.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/12/24.
//

import SwiftUI
import SwiftData // for @Query
import JetEmail_Data
import JetEmail_Foundation

struct AccountSection: View {
    @Environment(AppItemModel<Account>.self)
    private var itemModel
    
    @Environment(Account.self)
    private var account
    
    @State
    var root: MailFolder?
    
    var body: some View {
        Section {
            if let rootID = account.root?.uniqueID {
                _AcciontSection(_rootChildren: Query(filter: #Predicate<MailFolder> { !$0.deleteMark &&  $0.parent?.uniqueID == rootID }))
            }
        } header: {
            // Feature: Account - Load Mail Folders
            AccountSectionHeader { await itemModel.loadMailFolders() }
        }
    }
}


fileprivate struct _AcciontSection: View {

    @Query  /*sort: \Account.orderIndex*/
    var rootChildren: [MailFolder]
    
    var body: some View {
        OutlineGroup(rootChildren.sortedInParentMailFolderUsingIndex, children: \.children.nilIfEmpty) { item in
            MailFolderCell()
                .itemModel(item)
                .tag(item) // selection tag
        }
    }
}


