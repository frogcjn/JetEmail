//
//  MailListView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/2/24.
//

import SwiftUI
import SwiftData

struct MessageList : View {
    
    @Bindable
    var viewModel : MailFolderViewModel
    
    @State
    var errorText: String = ""
    
    @Query
    var messages: [Message]
    
    init(viewModel: MailFolderViewModel) {
        self._viewModel = Bindable(viewModel)
        let id = viewModel._mailFolder.id
        self._messages = Query(filter: #Predicate<Message> { $0.mailFolder.id == id })
    }
    
    var body: some View {

        //NavigationSplitView {
        Group {
            if !errorText.isEmpty {
                ErrorText(errorText)
            } else {
                List(messages, selection: $viewModel.selectedMessage) { item in
                    VStack(alignment: .leading) {
                        Text(item.element.sender?.emailAddress?.name ?? item.element.sender?.emailAddress?.address ?? "")
                        Text(item.subject ?? "").lineLimit(1)
                        Text(item.receivedDate?.formattedRelative() ?? "")
                        Text(item.bodyPreview ?? "").lineLimit(2)
                    }.tag(item)
                }
            }
        }
        .toolbar {
            Button("update", systemImage: "arrow.clockwise") {
                Task { await update() }
            }
            .buttonStyle(.borderless)
            .disabled(viewModel.isLoadingMessages)
            if viewModel.isLoadingMessages {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.small)
            }
        }
        .onChange(of: viewModel._mailFolder, initial: true) {
            Task {
                await update()
            }
        }
        //} detail: {
            // Text("Mail Content")
        //}
    }
    
    func update() async {
        print("update.start()")
        errorText = ""
        do {
            _ = try await viewModel.loadMessages()
        } catch {
            errorText = String(describing: error)
        }
        print("update.end()")
    }
}
