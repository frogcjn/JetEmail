//
//  MessagesToolBar.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI
import JetEmail_Data

struct LoadingMessageProgressBar : View {
    let mailFolderName: String
    let loadingMessageState: MailFolder.LoadingMessageState
    var body: some View {
        switch loadingMessageState {
        case .none: EmptyView()
        case .start:
            ProgressView(value: Float?.none) {
                HStack {
                    Text("Checking Mess in \(mailFolderName)…")
                    Spacer()
                }
            }
            .controlSize(.small)
        case .loading(value: let value, total: let total):
            ProgressView(value: Float(value), total: Float(total)) {
                HStack {
                    Text("Downloading Mess in \(mailFolderName)…")
                    Spacer()
                    if value > 0 && total > 0 {
                        Text("\(value)/\(total)")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .controlSize(.small)
        }
    }
}

struct MailFolderRefreshButton : View {
    
    @Environment(AppItemModel<MailFolder>.self)
    var mailFolder
    
    var body: some View {
        Button("Refresh", systemImage: "arrow.clockwise") {
            Task { await mailFolder.loadMessages() }
        }
        .labelStyle(.titleAndIcon)
        .disabled(mailFolder.item.id.loadingMessageState.isLoading)
    }
}
