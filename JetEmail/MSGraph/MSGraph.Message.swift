//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/7/24.
//


// MARK: - Message
// https://learn.microsoft.com/en-us/graph/api/resources/message

extension MSGraph {
    struct Message : Codable, Identifiable {
        let                         id: ID
        
        // subject
        let                    subject: String?

        let            createdDateTime: DateTimeOffset?
        let       lastModifiedDateTime: DateTimeOffset?
        let           receivedDateTime: DateTimeOffset? // * Important *
        let               sentDateTime: DateTimeOffset?
        
        let                     sender: Recipient?   // sender?
        let                       from: Recipient?   // * Important * from
        let               toRecipients: [Recipient]? // * Important * to
        let                    replyTo: [Recipient]? // 回复给
        let               ccRecipients: [Recipient]? // * Important * 抄送, carbon copy
        let              bccRecipients: [Recipient]? // 密件抄送，密送，blind carbon copy
        
        let                bodyPreview: String?   // * Important *
        let                       body: ItemBody? // * Important * may load later
        let                 uniqueBody: ItemBody? //?
        
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

}

extension MSGraph.Message : Hashable {
    static func == (lhs: MSGraph.Message, rhs: MSGraph.Message) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
