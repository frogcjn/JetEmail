//
//  MessagesToolBar.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI

struct MailFolderMessageListToolBar : View {
    
    @Environment(AppContext.Item<MailFolder>.self)
    var context
    
    var body: some View {
        HStack {            
            // Feature: Account - Load Messages
            Spacer()
            RefreshButton(isBusy: context.item.isBusy) { await context.loadMessages() }
            Spacer()
        }.background(.bar)
    }
}
