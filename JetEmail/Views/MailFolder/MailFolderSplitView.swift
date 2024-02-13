//
//  MailSplitView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import SwiftUI

struct MailFolderSplitView : View {
    
    @Bindable // state associate with a window instance
    var viewModel: WindowViewModel
    
    var body: some View {
        NavigationSplitView(columnVisibility: $viewModel.splitViewVisibility) {
            MailFolderList(viewModel: viewModel)
                .navigationSplitViewColumnWidth(min: 220, ideal: 220)
        } content: {
            if let mailFolder = viewModel.selectedMailFolder {
                MessageList(viewModel: viewModel[mailFolder: mailFolder])
            }
        } detail: {
            if let selection = viewModel.selectedMessage {
                MessageView(viewModel: viewModel[message: selection])
            }
        }
        .labelStyle(.iconOnly)
    }
}

