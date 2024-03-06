//
//  MessagesToolBar.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/14/24.
//

import SwiftUI

struct MailFolderMessageListToolBar : View {
    
    @Environment(AppItemModel<MailFolder>.self)
    var mailFolder
    
    var body: some View {
        HStack {  
            Spacer()
            // Feature: Account - Load Messages
            if mailFolder.isBusy {
                HStack(spacing: 5) {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.small)
                    Text("Loading…")
                        .foregroundStyle(.secondary)
                }
            } else {
                Button("Refresh", systemImage: "arrow.clockwise") {
                    Task { await mailFolder.loadMessages() }
                }
                .buttonStyle(.link)
                .labelStyle(.titleAndIcon)
            }
            Spacer()
        }.background(.bar)
    }
}
