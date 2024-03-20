//
//  MailFolderSection.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/12/24.
//

import SwiftUI
import SwiftData    // for @Query
import JetEmailData // for Account

struct AccountSection: View {
    
    @Environment(AppModel.self)
    private var appModel
    
    @Environment(Account.self)
    private var account
    
    // pass account.root: AccountSection will update if account's root changes in the background
    let root: MailFolder?
    
    var body: some View {
        Section {
            if let rootID = root?.uniqueID {
                _AcciontSection(_rootChildren: Query(filter: #Predicate<MailFolder> { !$0.deleteMark &&  $0.parent?.uniqueID == rootID }))
            }
        } header: {
            // Feature: Account - Load Mail Folders
            AccountSectionHeader { await appModel.loadMailFolders(accountID: account.resourceID) }
        }
    }
}


fileprivate struct _AcciontSection: View {

    @Query  /*sort: \Account.orderIndex*/
    var rootChildren: [MailFolder]
    
    var body: some View {
        OutlineGroup(rootChildren.sortedByChildIndex, children: \.children.nilIfEmpty) { mailFolder in
            MailFolderCell()
                .environment(mailFolder)
                .tag(mailFolder) // selection tag
        }
    }
}


