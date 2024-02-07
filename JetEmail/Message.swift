//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/7/24.
//


// MARK: - Message
// https://learn.microsoft.com/en-us/graph/api/resources/message

extension Microsoft.Graph {
    struct Message : Codable, Identifiable {
        let                         id: ID
        
        // subject
        let                    subject: String?
        /*
         The date and time the message was created.
         The date and time information uses ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z.
         */
        let            createdDateTime: DateTimeOffset?
        let       lastModifiedDateTime: DateTimeOffset?
        let           receivedDateTime: DateTimeOffset?
        let               sentDateTime: DateTimeOffset?
        
        let                     sender: Recipient?   // sender?
        let                       from: Recipient?   // from
        let               toRecipients: [Recipient]? // to
        let                    replyTo: [Recipient]? // 回复给
        let               ccRecipients: [Recipient]? // 抄送, carbon copy
        let              bccRecipients: [Recipient]? // 密件抄送，密送，blind carbon copy
        
        let                bodyPreview: String?
        let                       body: ItemBody?
        //let                 uniqueBody: ItemBody?
        
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
        
        struct ID : RawRepresentable, Codable, Hashable {
            let rawValue: String
        }
    }

}

extension Microsoft.Graph.Message : Hashable {
    static func == (lhs: Microsoft.Graph.Message, rhs: Microsoft.Graph.Message) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
