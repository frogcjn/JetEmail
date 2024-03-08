//
//  MessageView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/5/24.
//

import SwiftUI
import JetEmail_Data

struct MessageView : View {
    @Environment(AppItemModel<Message>.self)
    var itemModel
    
    @Environment(Message.self)
    var message
    
    var body: some View {
        
        VStack {
            Form {
                LabeledContent("subject:", value: message.subject ?? "nil")
                
                Divider()
                
                /*LabeledContent("createdDate:" , value: message.createdDate?.formattedRelative() ?? "")
                LabeledContent("modifiedDate:", value: message.modifiedDate?.formattedRelative() ?? "")*/
                LabeledContent("date:", value: message.date?.formattedRelative() ?? "")
                // LabeledContent("sentDate:"    , value: message.sentDate?.formattedRelative() ?? "")
                
                Divider()
                
                if let from    = message.from                             { LabeledContent("from:"    , value: from)    }
                if let sender  = message.sender,   sender != message.from { LabeledContent("sender:"  , value: sender)  }
                if let replyTo = message.replyTo                          { LabeledContent("replayTo:", value: replyTo) }

                if let to      = message.to                               { LabeledContent("to:"      , value: to )     }
                if let cc      = message.cc                               { LabeledContent("cc:"      , value: cc)      }
                if let bcc     = message.bcc                              { LabeledContent("bcc:"     , value: bcc )    }
                
                Divider()
                
                if let bodyPreview = message.bodyPreview {
                    LabeledContent("bodyPreview:", value: bodyPreview)
                }
            }
            
            EmailBodyView(messageBody: message.body)
            Spacer()
        }
        .overlay {
            if message.isBusy {
                ProgressView()
            }
        }
        /*// Feature: Classify
        .toolbar {
            Button {
                Task { await message.classify() }
            } label: {
                Label("classify", systemImage: "wand.and.rays")
                if message.isClassifying {
                    ProgressView().progressViewStyle(.circular).controlSize(.mini)
                }
            }
            if let resultText = message.classifyResultText {
                Text(resultText)
            }
        }*/
        .onChange(of: message, initial: true) {
            Task { await itemModel.loadBody() }
        }
    }
}

struct EmailBodyView : View {
    
    @Environment(SettingsModel.self)
    var appSettings
    
    let messageBody: Message.Body?
    
    var body: some View {
        if let messageBody {
            if let html = messageBody.html  {
                #if os(macOS)
                WebView(htmlString: html)
                #endif
            } else {
                if appSettings.isShowingWithDarkBackground {
                    Text(messageBody.text)
                } else {
                    Group {
                        Text(messageBody.text)
                            .background(.background)
                    }
                    .environment(\.colorScheme, .light)
                }
            }
        } else {
            Color.clear
        }
    }
}
