//
//  MessagesToolBar.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI

struct MailFolderMessageListToolBar : View {
    
    @Environment(AppItemModel<MailFolder>.self)
    var mailFolder
    
    var body: some View {
        HStack {            
            // Feature: Account - Load Messages
            RefreshButton(isBusy: mailFolder.isBusy) { await mailFolder.loadMessages() }
        }.background(.bar)
    }
}
