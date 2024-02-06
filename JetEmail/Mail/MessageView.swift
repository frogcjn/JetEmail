//
//  MessageView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/5/24.
//

import SwiftUI

struct MessageView : View {
    
    @Bindable
    var model : MessageViewModel
    var body: some View {
        
        
        Text(model.subject ?? "nil")
        
        LabeledContent("from:") { // chair
            Text(model.from?.emailAddress?.nameAndAddress ?? "nil")
        }
        
        /*LabeledContent("sender:") { // bounces // less useful
            Text(model.sender?.emailAddress?.nameAndAddress ?? "nil")
        }*/
        
        LabeledContent("to:") { // mail list
            Text(model.toRecipients?.map(\.nameAndAddress).joined(separator: ", ") ?? "nil")
        }
        
        /*LabeledContent("replyTo:") {
            Text(model.replyTo?.map(\.nameAndAddress).joined(separator: ", ") ?? "nil")
        }*/
        
        LabeledContent("cc:") {
            Text(model.ccRecipients?.map(\.nameAndAddress).joined(separator: ", ") ?? "nil")
        }
        
        Text(model.receivedDateTime?.date.formattedRelative() ?? "")
        
        Text(model.body?.contentType?.rawValue ?? "")
        
        switch (model.body?.contentType, model.body?.content)  {
        case (.html, let htmlString?):
            WebView(htmlString: htmlString)
        case (.text, let text?):
            Text(text)
        default:
            EmptyView()
        }
        
    }
}
