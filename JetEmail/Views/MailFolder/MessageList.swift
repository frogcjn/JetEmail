//
//  MailListView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/2/24.
//

import SwiftUI
import SwiftData // for @Query

fileprivate struct _MessageList : View {
    @Environment(AppItemModel<MailFolder>.self)
    var mailFolder

    @Environment(MailWindowModel.self)
    var window

    @Query
    var messages: [Message]

    var body: some View {
        List(messages, selection: Bindable(window).selectedMessage) { item in
            MessageCell()
                .itemModel(item)
                .tag(item)
        }
        .safeAreaInset(edge: .top) {
            MailFolderMessageListToolBar()
        }
        
        // Feature: Account - Load Messages
        .onChange(of: mailFolder.item, initial: true) {
            Task { await mailFolder.loadMessages() }
        }
    }
}

struct MessageList : View {
    @Environment(MailFolder.self)
    var mailFolder

    var body: some View {
        let id = mailFolder.id
        _MessageList(_messages: Query(filter: #Predicate<Message> { $0.mailFolder.id == id && !$0.deleteMark }, sort: \.date, order: .reverse))
    }
}
