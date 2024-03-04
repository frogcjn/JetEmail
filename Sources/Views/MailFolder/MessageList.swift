//
//  MailListView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/2/24.
//

import SwiftUI
import SwiftData // for @Query

fileprivate struct _MessageList : View {
    @Environment(AppModel.self)
    var appModel
    
    @Environment(AppItemModel<MailFolder>.self)
    var mailFolder

    @Environment(MailWindowModel.self)
    var window

    @Query
    var messages: [Message]
    
    @State
    var classifyStartIndex = 0

    var body: some View {
        List(messages, selection: Bindable(window).selectedMessage) { item in
            MessageCell()
                .itemModel(item)
                .tag(item)
        }
        /*Table(messages.map { TableDataRow(id: $0, item: $0) },  selection: Bindable(window).selectedMessage) {
            TableColumn("Content") { row in
                MessageCell()
                    .itemModel(row.item)
            }
            
            TableColumn("ClassifyResultCell") { row in
                ClassifyResultCell()
                    .itemModel(row.item)
            }
        }*/
    
        .safeAreaInset(edge: .top) {
            MailFolderMessageListToolBar()
        }
        
        // Feature: Account - Load Messages
        .onChange(of: mailFolder.item, initial: true) {
            Task { await mailFolder.loadMessages() }
        }
        
        // Feature: Classify
        .toolbar {
            Button {
                Task {
                    if let message = window.selectedMessage {
                        await appModel(message).classify()
                    } else {
                        for message in messages.prefix(classifyStartIndex+5).filter({ $0.moveTo == nil }) {
                            await appModel(message).classify()
                        }
                        classifyStartIndex += 5
                    }
                }
            } label: {
                Label("classify", systemImage: "wand.and.rays")
                if messages.contains(where: { $0.isClassifying }) {
                    ProgressView().progressViewStyle(.circular).controlSize(.mini)
                }
            }
            /*if let resultText = message.classifyResultText {
                Text(resultText)
            }*/
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


struct TableDataRow : Identifiable {
    var id: Message
    var item: Message
}
