//
//  MailFolderSection.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/12/24.
//

import SwiftUI

struct MailFolderSection: View {
    
    @Bindable
    var viewModel: AccountViewModel
    
    @State
    var errorText = ""
    
    var body: some View {
        
        Section(header: HStack(spacing: 5) {
            Text(viewModel.username)
            
            Button("update", systemImage: "arrow.clockwise") {
                Task { await update() }
            }
            .buttonStyle(.borderless)
            .disabled(viewModel.isLoadingFolderTree)
            if viewModel.isLoadingFolderTree {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.small)
            }
        }) {
            if !errorText.isEmpty {
                ErrorText(errorText)
            } else {
                OutlineGroup(viewModel.rootChildren, children: \.children.nilIfEmpty) { node in
                    Text(node.name)
                        .tag(node) // selection tag
                }
            }
        }
    }
    
    func update() async {
        errorText = ""
        do {
            try await viewModel.loadFolderTree()
        } catch {
            errorText = String(describing: error)
        }
    }
}

/*struct MailFolderSelection {
    let accountViewModel: AccountViewModel
    let mailFolder: Microsoft.Graph.MailFolder
}

extension MailFolderSelection : Hashable {
    static func == (lhs: MailFolderSelection, rhs: MailFolderSelection) -> Bool {
        lhs.accountViewModel.id == rhs.accountViewModel.id && lhs.mailFolder == rhs.mailFolder
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(accountViewModel.id)
        hasher.combine(mailFolder.id)
    }
}*/
