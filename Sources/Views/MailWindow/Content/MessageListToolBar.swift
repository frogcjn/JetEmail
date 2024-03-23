//
//  MessagesToolBar.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import JetEmailData // for MailFolderLoadingMessageState

struct LoadingMessageProgressBar : View {
    let mailFolderName: String
    let loadingMessageState: MailFolderLoadingMessageState
    let isEmpty: Bool
    var body: some View {
        switch loadingMessageState {
        case .start where isEmpty:
            /*ProgressView {
                Text("Checking Messages in \(mailFolderName)…")
            }
            .progressViewStyle(.linear)
            .controlSize(.small)*/
            HStack {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.small)
                Text("Checking Messages in \(mailFolderName)…")
            }
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
        default: EmptyView()
        }
    }
}

struct MailFolderRefreshButton : View {
    
    @Environment(AppModel.self)
    var appModel
    
    @Environment(MailFolder.self)
    var mailFolder
    
    
    var body: some View {
        Button("Refresh", systemImage: "arrow.clockwise") {
            Task {
                await appModel.syncMessages(mailFolderID: mailFolder.resourceID)
            }
        }
        .labelStyle(.titleAndIcon)
        .disabled(mailFolder.resourceID.loadingMessageState.isLoading)
    }
}
