//
//  MessagesToolBar.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import JetEmailData
import JetEmailID

struct LoadingMessageProgressBar : View {
    let mailFolderName: String
    let loadingMessageState: MailFolderLoadingMessageState
    var body: some View {
        switch loadingMessageState {
        case .none: EmptyView()
        case .start:
            ProgressView(value: Float?.none) {
                HStack {
                    Text("Checking Messages in \(mailFolderName)…")
                    Spacer()
                }
            }
            .controlSize(.small)
        case .loading(value: let value, total: let total):
            ProgressView(value: Float(value), total: Float(total)) {
                HStack {
                    Text("Downloading Messages in \(mailFolderName)…")
                    Spacer()
                    if value > 0 && total > 0 {
                        Text("\(value) of \(total)")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .controlSize(.small)
        }
    }
}

struct MailFolderRefreshButton : View {
    
    @Environment(AppModel.self)
    var appModel
    
    @Environment(MailFolder.self)
    var mailFolder
    
    @Environment(Account.self)
    var account
    
    
    var body: some View {
        Button("Refresh", systemImage: "arrow.clockwise") {
            Task {
                await appModel.loadMessages(mailFolderID: mailFolder.resourceID, accountID: account.resourceID)
            }
        }
        .labelStyle(.titleAndIcon)
        .disabled(mailFolder.resourceID.loadingMessageState.isLoading)
    }
}
