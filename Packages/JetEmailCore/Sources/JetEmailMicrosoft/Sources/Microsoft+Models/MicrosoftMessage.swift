//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/7/24.
//

import JetEmailData
import JetEmailFoundation
import struct Foundation.Data
import struct Foundation.Date

public struct MicrosoftMessage : MicrosoftProtocol, PlatformSpecificMessageProtocol {
    public typealias GeneralID = MessageID
    
    public let    id       : MicrosoftMessageID
    public let inner       : MicrosoftMessageInner
    
    public var subject     : String?
    
    public var from        : String?
    public var sender      : String?
    public var replyTo     : String?
    
    public var to          : String?
    public var cc          : String?
    public var bcc         : String?
    public var deliveredTo : String?
    
    public var date        : Date?
    public var createdDate : Date?
    public var modifiedDate: Date?
    public var receivedDate: Date?
    public var sentDate    : Date?
    
    public var bodyPreview: String?
    public var body       : MessageBody?
    public var raw        : Data?

    public init(id: MicrosoftMessageID, inner: MicrosoftMessageInner) {
        self.id    = id
        self.inner = inner
        
        // self.id           = newValue.id.general
        subject      = inner.subject?.nilIfEmpty
        
        createdDate  = inner.createdDateTime?     .date
        modifiedDate = inner.lastModifiedDateTime?.date
        receivedDate = inner.receivedDateTime?    .date
        sentDate     = inner.sentDateTime?        .date
        date         = receivedDate

        sender       = inner.sender?.emailAddress.map(\.rawValue)
        from         = inner.from?.emailAddress.map(\.rawValue)
        to           = inner.toRecipients? .compactMap(\.emailAddress?.rawValue).joined(separator: ", ").nilIfEmpty
        replyTo      = inner.replyTo?      .compactMap(\.emailAddress?.rawValue).joined(separator: ", ").nilIfEmpty
        cc           = inner.ccRecipients? .compactMap(\.emailAddress?.rawValue).joined(separator: ", ").nilIfEmpty
        bcc          = inner.bccRecipients?.compactMap(\.emailAddress?.rawValue).joined(separator: ", ").nilIfEmpty
        
        bodyPreview  = inner.bodyPreview?.nilIfEmpty
        
        if let body = inner.body, let contentType = body.contentType, let content = body.content {
            self.body = switch contentType {
            case .html: .init(text: content, html:content)
            case .text: .init(text: content, html: nil)
            }
        }
        
        if let raw { self.raw = raw }
    }
}


// MARK: - Message
// https://learn.microsoft.com/en-us/graph/api/resources/message

public struct MicrosoftMessageInner : CodableValueType, Sendable {
    public let                         id: String
    
    // subject
    public let                    subject: String?
    
    public let            createdDateTime: DateTimeOffset?
    public let       lastModifiedDateTime: DateTimeOffset?
    public let           receivedDateTime: DateTimeOffset? // * Important *
    public let               sentDateTime: DateTimeOffset?
    
    public let                     sender: Recipient?   // sender?
    public let                       from: Recipient?   // * Important * from
    public let               toRecipients: [Recipient]? // * Important * to
    public let                    replyTo: [Recipient]? // 回复给
    public let               ccRecipients: [Recipient]? // * Important * 抄送, carbon copy
    public let              bccRecipients: [Recipient]? // 密件抄送，密送，blind carbon copy
    
    public let                bodyPreview: String?   // * Important *
    public let                       body: ItemBody? // * Important * may load later
    public let                 uniqueBody: ItemBody? //?
    
    /*
     let                 categories: [String]?
     let                  changeKey: String?
     let             conversationId: String?
     let          conversationIndex: Data? // Edm.Binary is typically represented as Data in Swift
     
     let                       flag: FollowupFlag?
     let             hasAttachments: Bool?
     let                 importance: Importance?
     let    inferenceClassification: InferenceClassificationType?
     let     internetMessageHeaders: [InternetMessageHeader]?
     let          internetMessageId: String?
     let isDeliveryReceiptRequested: Bool?
     let                    isDraft: Bool?
     let                     isRead: Bool?
     let     isReadReceiptRequested: Bool?
     let             parentFolderId: String?
     
     let                    webLink: String?*/
}

