//
//  MessageView.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/5/24.
//

import SwiftUI
import JetEmailData
import JetEmailID

struct MessageView : View {
    @Environment(AppItemModel<Message>.self)
    var itemModel

    @Environment(Message.self)
    var message

    var body: some View {
        VStack {
            EmailMetadataView(message: message)
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

struct EmailMetadataView: View {
    let message: Message

    var body: some View {
        Form {
            LabeledContent("subject:", value: message.subject ?? "nil")

            DynamicDivider()

            /*LabeledContent("createdDate:" , value: message.createdDate?.formattedRelative() ?? "")
            LabeledContent("modifiedDate:", value: message.modifiedDate?.formattedRelative() ?? "")*/
            LabeledContent("date:", value: message.date?.formattedRelative() ?? "")
            // LabeledContent("sentDate:"    , value: message.sentDate?.formattedRelative() ?? "")

            DynamicDivider()

            if let from    = message.from                             { LabeledContent("from:"    , value: from)    }
            if let sender  = message.sender,   sender != message.from { LabeledContent("sender:"  , value: sender)  }
            if let replyTo = message.replyTo                          { LabeledContent("replayTo:", value: replyTo) }

            if let to      = message.to                               { LabeledContent("to:"      , value: to )     }
            if let cc      = message.cc                               { LabeledContent("cc:"      , value: cc)      }
            if let bcc     = message.bcc                              { LabeledContent("bcc:"     , value: bcc )    }

            DynamicDivider()

            if let bodyPreview = message.bodyPreview, message.body?.html == nil {
                // no need to display preview if the body is nonnull
                LabeledContent("bodyPreview:", value: bodyPreview)
            }
        }
        .padding(4)
    }
}

struct DynamicDivider: View {
    var body: some View {
        #if os(visionOS)
        #else
        Divider()
        #endif
    }
}

struct EmailBodyView : View {

    @Environment(SettingsModel.self)
    var appSettings
    
    let messageBody: MessageBody?
    
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
