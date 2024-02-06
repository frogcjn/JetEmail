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
                .navigationSplitViewColumnWidth(min: 200, ideal: 200)
        } content: {
            if let selection = model.selectedMailFolder {
                MessageList(model: model[mailFolder: selection])
            }
        } detail: {
            if let selection = model.selectedMessage {
                MessageView(model: model[message: selection])
            }
        }
        .labelStyle(.iconOnly)
    }
}

extension Date {
    func formattedRelative() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self, to: .now)
        switch components.day ?? 0 {
        case 3...:
            return self.formatted(.dateTime.day(.defaultDigits).month(.defaultDigits).year(.defaultDigits))
        default:
            return self.formatted(.relative(presentation: .named)/*.locale(.current)*/)
        }
    }
}
