//
//  MailSplitView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/1/24.
//

import SwiftUI

struct MailFolderSplitView : View {
    
    @State // state associate with a window instance
    var model: WindowViewModel
    
    var body: some View {
        NavigationSplitView() {
            MailFolderList(model: model)
                .navigationSplitViewColumnWidth(min: 180, ideal: 180)
        } detail: {
            if let selection = model.selectedMailFolder {
                MessageList(model: model[mailFolder: selection.value])
            }
        }
        .labelStyle(.iconOnly)
    }
}
