//
//  MailListView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/2/24.
//

import SwiftUI
import SwiftData // for @Query
import JetEmail_Data

fileprivate struct _MessageList : View {
    @Environment(AppModel.self)
    var appModel
    
    @Environment(AppItemModel<MailFolder>.self)
    var itemModel
    
    @Environment(MailFolder.self)
    var mailFolder

    @Environment(MailWindowModel.self)
    var window

    @Query
    var messages: [Message]
    
    var body: some View {
        List(selection: Bindable(window).selectedMessage) {
            Section {
                ForEach(messages) { item in
                    MessageCell()
                        .itemModel(item)
                        .tag(item)
                }
            } header: {
                LoadingMessageProgressBar(mailFolderName: mailFolder.localizedName, loadingMessageState: mailFolder.id.loadingMessageState)
            }
        }
        .toolbar {
            MailFolderMessageListToolBar()
        }
        
        // Feature: Account - Load Messages
        /*.refreshable {
            await itemModel.loadMessages()
        }*/
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
    
        /*.safeAreaInset(edge: .top) {
            MailFolderMessageListToolBar()
        }*/
        
        // Feature: Account - Load Messages
        .onChange(of: mailFolder, initial: true) {
            Task { await itemModel.loadMessages() }
        }
        
        // Feature: Classify
        .toolbar {
            Group {
                
                /*if let message = window.selectedMessage, messages.contains(message), message.moveTo == nil {
                    Button {
                        message.moveTo = mailFolder
                    } label: {
                        Label("Classify", systemImage: "cursorarrow.rays")
                    }
                }*/
                
                Menu {
                    ForEach([1,5,10,50], id: \.self) { count in
                        Button("^[\(count) Message](inflect: true)" /*, systemImage: "wand.and.rays"*/) { 
                            Task { await classifyMultiple(auto: true, count: count) }
                        }
                    }
                    Button("Manual"/*, systemImage: "cursorarrow.rays"*/) { 
                        Task { await classifyMultiple(auto: false, count: 1) }
                    }
                } label: {
                    Label("Classify", systemImage: "wand.and.rays")
                }
                .disabled(messages.contains(where: { $0.isClassifying }))
                //.menuStyle(.default)
                
                /*if let resultText = message.classifyResultText {
                 Text(resultText)
                 }*/
                
                if messages.contains(where: { $0.movePlan != nil }) {
                    Button {
                        for message in messages.filter({ $0.movePlan != nil }) {
                            if let to = message.movePlan {
                                Task {
                                    await appModel(message).move(from: mailFolder, to: to)
                                    message.movePlan = nil
                                }
                            }
                        }
                    } label: {
                        Label("Move All", systemImage: "folder")
                    }
                }
            }
            .labelStyle(.titleAndIcon)
        }
    }
        
    @MainActor
    func classifyMultiple(auto: Bool, count: Int) async {
        do {
            let classifyStartIndex: Int
            if let message = window.selectedMessage, let selectedIndex = messages.firstIndex(of: message) {
                classifyStartIndex = selectedIndex
            } else {
                classifyStartIndex = (messages.lastIndex { $0.movePlan != nil } ?? -1) + 1
            }
        
            let classifyMessages = messages.dropFirst(classifyStartIndex).prefix(count) // .filter({ $0.movePlan == nil })
            if auto {
                try await classifyMessages.map(\.id).forEachTask { @MainActor in try await appModel($0)?.classify() }
            } else {
                classifyMessages.forEach { message in message.movePlan = mailFolder }
            }
        } catch {
            appModel.logger.error("\(error)")
        }
    }
}

struct MessageList : View {
    @Environment(MailFolder.self)
    var mailFolder

    var body: some View {
        let rawID = mailFolder.rawID
        _MessageList(_messages: Query(filter: #Predicate<Message> { $0.mailFolder.rawID == rawID && !$0.deleteMark }, sort: \.date, order: .reverse))
    }
}


struct TableDataRow : Identifiable {
    var id: Message
    var item: Message
}
