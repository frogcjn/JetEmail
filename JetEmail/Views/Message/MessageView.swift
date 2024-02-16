//
//  MessageView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/5/24.
//

import SwiftUI

struct MessageView : View {
    
    @Environment(AppContext.Item<Message>.self)
    var context
    
    @Environment(Message.self)
    var message
    
    var body: some View {
        
        VStack {
            Form {
                LabeledContent("subject:", value: message.subject ?? "nil")
                
                Divider()
                
                /*LabeledContent("createdDate:" , value: message.createdDate?.formattedRelative() ?? "")
                LabeledContent("modifiedDate:", value: message.modifiedDate?.formattedRelative() ?? "")*/
                LabeledContent("receivedDate:", value: message.receivedDate?.formattedRelative() ?? "")
                LabeledContent("sentDate:"    , value: message.sentDate?.formattedRelative() ?? "")
                
                Divider()
                
                if let sender = message.sender, sender != message.from {
                    LabeledContent("sender:", value: sender.nameAndAddress)
                }
                if let from = message.from {
                    LabeledContent("from:", value: from.nameAndAddress)
                }
                if let to = message.to {
                    LabeledContent("to:", value: to.map(\.nameAndAddress).joined(separator: ", "))
                }
                
                if let replyTo = message.replyTo {
                    LabeledContent("replayTo:", value: replyTo.map(\.nameAndAddress).joined(separator: ", "))
                }
                
                if let cc = message.cc {
                    LabeledContent("cc:", value: cc.map(\.nameAndAddress).joined(separator: ", "))
                }
                
                if let bcc = message.bcc {
                    LabeledContent("bcc:", value: bcc.map(\.nameAndAddress).joined(separator: ", "))
                }
                
                Divider()
                
                if let bodyPreview = message.bodyPreview {
                    LabeledContent("bodyPreview:", value: bodyPreview)
                }

                /*LabeledContent("replyTo:") {
                 Text(model.replyTo?.map(\.nameAndAddress).joined(separator: ", ") ?? "nil")
                 }*/
                
                /*LabeledContent("cc:") {
                    Text(message.ccRecipients?.map(\.nameAndAddress) ?? "nil")
                }*/
                

                        
            }
            
            if let body = message.body {
                EmailBodyView(itemBody: body)
            }
            Spacer()
        }
        .overlay {
            if message.isBusy {
                ProgressView()
            }
        }
        /*/.toolbar {
            /*Button {
                Task { await model.classify() }
            } label: {
                Label("classify", systemImage: "wand.and.rays")
                if model.isClassifying {
                    ProgressView().progressViewStyle(.circular).controlSize(.mini)
                }
            }
            if let resultText = model.classifyResultText {
                Text(resultText)
            }*/
        }*/
        .onChange(of: message, initial: true) {
            Task { await context.loadBody() }
        }
    }
}

struct EmailBodyView : View {
    
    @Environment(SettingsModel.self)
    var appSettings
    
    var itemBody: MSGraph.ItemBody
    
    var body: some View {
        switch (itemBody.contentType, itemBody.content)  {
        case (.html, let htmlString?):
            WebView(htmlString: htmlString)
        case (.text, let text?):
            if appSettings.isShowingWithDarkBackground {
                Text(text)
            } else {
                Group {
                    Text(text)
                        .background(.background)
                }
                .environment(\.colorScheme, .light)
            }
        default:
            Color.clear
        }
    }
}
