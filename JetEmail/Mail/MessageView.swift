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
        
        VStack {
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
            
            if let body = model.body {
                EmailBodyView(itemBody: body)
            }
        }
        .toolbar {
            Button {
                Task { await model.classify() }
            } label: {
                Label("classify", systemImage: "wand.and.rays")
                if model.isClassifying {
                    ProgressView().progressViewStyle(.circular).controlSize(.mini)
                }
            }
            if let resultText = model.classifyResultText {
                Text(resultText)
            }
        }
    }
}

struct EmailBodyView : View {
    
    @Environment(AppSettings.self)
    var appSettings
    
    var itemBody: Microsoft.Graph.ItemBody
    
    var body: some View {
        switch (itemBody.contentType, itemBody.content)  {
        case (.html, let htmlString?):
            WebView(htmlString: htmlString)
        case (.text, let text?):
            if appSettings.isOnColorScheme {
                Text(text)
            } else {
                Group {
                    Text(text)
                        .background(.background)
                }
                .environment(\.colorScheme, .light)
            }
        default:
            EmptyView()
        }
    }
}
