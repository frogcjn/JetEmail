//
//  MailListView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/2/24.
//

import SwiftUI
import SwiftData // for @Query

fileprivate struct _MessageList : View {

    @Environment(AppContext.Item<MailFolder>.self)
    var context
    
    @Environment(MailFolder.self)
    var mailFolder

    @Environment(MailWindowModel.self)
    var window

    @Query
    var messages: [Message]

    var body: some View {
        List(messages, selection: Bindable(window).selectedMessage) { item in
            MessageCell()
                .appContext(item: item)
                .tag(item)
        }
        .safeAreaInset(edge: .top) {
            MailFolderMessageListToolBar()
        }
        
        // Feature: Account - Load Messages
        .onChange(of: mailFolder, initial: true) {
            Task { await context.loadMessages() }
        }
    }
}

struct MessageList : View {
    @Environment(MailFolder.self)
    var mailFolder

    var body: some View {
        let id = mailFolder.id
        _MessageList(_messages: Query(filter: #Predicate<Message> { $0.mailFolder.id == id && !$0.deleteMark }, sort: \.receivedDate, order: .reverse))
    }
}
