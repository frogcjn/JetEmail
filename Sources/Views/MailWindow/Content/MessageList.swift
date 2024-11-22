//
//  MailListView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/2/24.
//

import SwiftUI
import SwiftData    // for @Query
import JetEmailData // for Account
import JetEmailPlatform

private struct _MessageList : View {
    
    @Environment(MailWindowModel.self)
    var window
    
    @Environment(AppModel.self)
    var appModel
    
    @Environment(MailFolder.self)
    var mailFolder
    
    @Environment(Account.self)
    var account
    
    @Query
    var messages: [Message]
    
    /*init(mailFolder: MailFolder) {
        let uniqueID = mailFolder.uniqueID
        self.mailFolder = mailFolder
        self._messages = Query(filter: #Predicate<Message> { $0.mailFolders.contains { $0.uniqueID == uniqueID } }, sort: \.date, order: .reverse)
    }*/
    
    var body: some View {
        List(selection: Bindable(window).selectedMessage) {
            Section {
                ForEach(messages) { message in
                    MessageCell()
                        .environment(message)
                        .tag(message)
                        .contextMenu {
                            Button("Delete") {
                                appModel.moveMessage(message, toSystemName: .trash, in: mailFolder, account)
                            }
                        }
                }
            } header: {
                LoadingMessageProgressBar(
                    mailFolderName: mailFolder.localizedName,
                    loadingMessageState: mailFolder.resourceID.loadingMessageState,
                    isEmpty: messages.isEmpty
                )
            }
        }
        .toolbar {
            MailFolderRefreshButton()
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
            Task { await appModel.syncMessages(mailFolderID: mailFolder.resourceID) }
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
                
                if messages.contains(where: { $0.movePlanID != nil }) {
                    Button {
                        appModel.moveAllMessagesToMovePlan(messages, in: mailFolder, account)
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
        let classifyStartIndex: Int
        if let message = window.selectedMessage, let selectedIndex = messages.firstIndex(of: message) {
            classifyStartIndex = selectedIndex
        } else {
            classifyStartIndex = (messages.lastIndex { $0.movePlanID != nil } ?? -1) + 1
        }
    
        let classifyMessages = messages.dropFirst(classifyStartIndex).prefix(count) // .filter({ $0.movePlan == nil })
        if auto {
            await classifyMessages.map(\.resourceID).forEachTask {[appModel] in await appModel.classify(messageID: $0) }
        } else {
            classifyMessages.forEach { message in message.movePlanID = mailFolder.resourceID }
        }
    }
}

struct MessageList : View {
    @Environment(MailFolder.self)
    var mailFolder

    var body: some View {
        let uniqueID = mailFolder.uniqueID
        _MessageList(_messages: Query(filter: #Predicate<Message> { !$0.deleteMark && $0.mailFolders.contains { $0.uniqueID == uniqueID } }, sort: \.date, order: .reverse))
        
        /*_MessageList(_messages: Query(filter: #Predicate<Message> { uniqueIDs.contains($0.uniqueID) && !$0.deleteMark }, sort: \.date, order: .reverse))
            .onChange(of: mailFolder._messages, initial: true) {
                uniqueIDs = $1.map(\.uniqueID)
            }*/
        /*_MessageList(messages: mailFolder.messages)*/
        //_MessageList(mailFolder: mailFolder)
    }
}


struct TableDataRow : Identifiable {
    var id: Message
    var item: Message
}
