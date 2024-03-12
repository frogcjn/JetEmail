//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/7/24.
//

import JetEmailID
import struct Foundation.Data

public struct MicrosoftMessage : MicrosoftProtocol, PlatformSpecificMessageProtocol, GetMessageProtocol {
    public typealias PlatformCaseGeneralID = MessageID
    public let    id: MicrosoftMessageID
    public let inner: MicrosoftMessageInner
    public var   raw: Data?

    public init(id: MicrosoftMessageID, inner: MicrosoftMessageInner) {
        self.id = id
        self.inner = inner
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

