//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/7/24.
//

import Foundation
import MSAL

// MARK: - Message
// https://learn.microsoft.com/en-us/graph/api/resources/message

public struct Message : Codable, Identifiable, Sendable {
        public var                         id: ID
        
        // subject
        public var                    subject: String?

        public var            createdDateTime: DateTimeOffset?
        public var       lastModifiedDateTime: DateTimeOffset?
        public var           receivedDateTime: DateTimeOffset? // * Important *
        public var               sentDateTime: DateTimeOffset?
        
        public var                     sender: Recipient?   // sender?
        public var                       from: Recipient?   // * Important * from
        public var               toRecipients: [Recipient]? // * Important * to
        public var                    replyTo: [Recipient]? // 回复给
        public var               ccRecipients: [Recipient]? // * Important * 抄送, carbon copy
        public var              bccRecipients: [Recipient]? // 密件抄送，密送，blind carbon copy
        
        public var                bodyPreview: String?   // * Important *
        public var                       body: ItemBody? // * Important * may load later
        public var                 uniqueBody: ItemBody? //?
        
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
        public var raw: Data?
        
    }

extension Message : Hashable {
    public static func == (lhs: Microsoft.Message, rhs: Microsoft.Message) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
