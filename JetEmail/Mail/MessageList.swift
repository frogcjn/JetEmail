//
//  MailListView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/2/24.
//

import SwiftUI

struct MessageList : View {
    
    @Bindable
    var model : MailFolderViewModel
    
    var body: some View {

        //NavigationSplitView {
            Group {
                if model.isLoadingMessages {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    if !model.errorMessage.isEmpty {
                        ScrollView {
                            ErrorText(model.errorMessage)
                        }
                    }
         List(model.messages, selection: $model.selectedMessage) { item in
             VStack(alignment: .leading) {
                 Text(item.sender?.emailAddress?.name ?? item.sender?.emailAddress?.address ?? "")
                 Text(item.subject ?? "")
                 Text(item.receivedDateTime?.date.formattedRelative() ?? "")
             }.tag(item)
         }
                }
            }
            .toolbar {
                Button("update", systemImage: "arrow.clockwise") {
                    Task { await model.loadMessages() }
                }
            }
            .onChange(of: model._mailFolder, initial: true) {
                Task {
                    await model.loadMessages()
                }
            }
        //} detail: {
            // Text("Mail Content")
        //}
    }
}
