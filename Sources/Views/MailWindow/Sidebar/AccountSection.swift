//
//  MailFolderSection.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/12/24.
//

import SwiftUI
import SwiftData // for @Query
import JetEmail_Data

struct AccountSection: View {
    @Environment(AppItemModel<Account>.self)
    private var itemModel
    
    @Environment(Account.self)
    private var account
    
    @State
    private var rootChildren: [MailFolder] = []
    
    var body: some View {
        Section {
            // _AcciontSection(rootChildren: (rootChildren.filter { !$0.deleteMark })/*.sorted(using: KeyPathComparator(\MailFolder.name))*/)
            OutlineGroup(rootChildren.filter { !$0.deleteMark }, children: \.children.nilIfEmpty) { item in
                MailFolderCell()
                    .itemModel(item)
                    .tag(item) // selection tag
            }
        } header: {
            // Feature: Account - Load Mail Folders
            AccountSectionHeader { await itemModel.loadMailFolders() }
        }.onChange(of: account.root, initial: true) { oldValue, newValue in
            rootChildren = newValue?.children ?? []
        }
    }
}


/*fileprivate struct _AcciontSection: View {
    
    var rootChildren: [MailFolder]
    
    var body: some View {
        OutlineGroup(rootChildren, children: \.children.nilIfEmpty) { item in
            MailFolderCell()
                .itemModel(item)
                .tag(item) // selection tag
        }
    }
}*/


