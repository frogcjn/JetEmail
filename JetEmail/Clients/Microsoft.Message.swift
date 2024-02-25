//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/7/24.
//

import Foundation

// MARK: - Message
// https://learn.microsoft.com/en-us/graph/api/resources/message

extension Microsoft {
    struct Message : Codable, Identifiable {
        var                         id: ID
        
        // subject
        var                    subject: String?

        var            createdDateTime: DateTimeOffset?
        var       lastModifiedDateTime: DateTimeOffset?
        var           receivedDateTime: DateTimeOffset? // * Important *
        var               sentDateTime: DateTimeOffset?
        
        var                     sender: Recipient?   // sender?
        var                       from: Recipient?   // * Important * from
        var               toRecipients: [Recipient]? // * Important * to
        var                    replyTo: [Recipient]? // 回复给
        var               ccRecipients: [Recipient]? // * Important * 抄送, carbon copy
        var              bccRecipients: [Recipient]? // 密件抄送，密送，blind carbon copy
        
        var                bodyPreview: String?   // * Important *
        var                       body: ItemBody? // * Important * may load later
        var                 uniqueBody: ItemBody? //?
        
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
        var raw: Data?
        
    }

}

extension Microsoft.Message : Hashable {
    static func == (lhs: Microsoft.Message, rhs: Microsoft.Message) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
