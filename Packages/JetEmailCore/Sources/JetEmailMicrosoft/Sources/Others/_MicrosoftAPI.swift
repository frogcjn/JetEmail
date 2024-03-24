//
//  MailFolder.Others.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/7/24.
//

import typealias JetEmailFoundation.CodableValueType
import struct Foundation.Date
import JetEmailData
    
enum _MicrosoftAPI {}

extension _MicrosoftAPI {
    /*
     The date and time the message was created.
     The date and time information uses ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z.
     */
    struct DateTimeOffset: RawRepresentable, CodableValueType, Sendable {
        //let date: Date
        let rawValue: String
        let date: Date
        init?(rawValue: String) {
            guard let date = rawValue.iso8601 else { return nil }
            self.rawValue = rawValue
            self.date = date
        }
    }
    
    // https://learn.microsoft.com/en-us/graph/api/resources/itembody
    
    struct ItemBody : CodableValueType, Sendable {
        let content: String?
        let contentType: ContentType?
        
        enum ContentType : String, CodableValueType, Sendable {
            case text
            case html
        }
    }
    
    // https://learn.microsoft.com/en-us/graph/api/resources/recipient
    
    struct Recipient : CodableValueType, Sendable {
        public let emailAddress: EmailAddress?
    }
    
    // https://learn.microsoft.com/en-us/graph/api/resources/emailaddress
    
    struct EmailAddress: CodableValueType, Sendable {
        let address: String
        let name: String?
    }
}


extension _MicrosoftAPI.EmailAddress {
    var rawValue: String {
        if let name { "\(name) <\(address)>" }
        else { address }
    }
}



extension _MicrosoftAPI {
    
    // MARK: - Message
    // https://learn.microsoft.com/en-us/graph/api/resources/message
    
    struct MicrosoftMessageInner : CodableValueType, Sendable {
        let                         id: String
        
        // subject
        /*let                    subject: String?*/
        
       /* let            createdDateTime: DateTimeOffset?
        let       lastModifiedDateTime: DateTimeOffset?
        let           receivedDateTime: DateTimeOffset? // * Important *
        let               sentDateTime: DateTimeOffset?*/
        
       /* let                     sender: Recipient?   // sender?
        let                       from: Recipient?   // * Important * from
        let               toRecipients: [Recipient]? // * Important * to
        let                    replyTo: [Recipient]? // 回复给
        let               ccRecipients: [Recipient]? // * Important * 抄送, carbon copy
        let              bccRecipients: [Recipient]? // 密件抄送，密送，blind carbon copy*/
        let     internetMessageHeaders: [MessageHeader]?
        
        let                bodyPreview: String?   // * Important *
        let                       body: ItemBody? // * Important * may load later
       //  public let                 uniqueBody: ItemBody? //?
        
        let                       type: String?
        let                       etag: String?
        let                    removed: Removed?
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
        
        enum CodingKeys: String, CodingKey, Sendable {
            case id
            /*case subject
            case createdDateTime
            case lastModifiedDateTime
            case receivedDateTime
            case sentDateTime
            case sender
            case from
            case toRecipients
            case replyTo
            case ccRecipients
            case bccRecipients*/
            case internetMessageHeaders
            case bodyPreview
            case body
            // case uniqueBody
            
            case type    = "@odata.type"
            case etag    = "@odata.etag"
            case removed = "@removed"
        }
        
        struct Removed : CodableValueType, Sendable {
            let reason: Reason
            enum Reason: String, CodableValueType, Sendable {
                case changed
                case deleted
            }
        }

    }
}


/*extension MicrosoftMailFolder {
    init(id: MicrosoftMailFolderID, _inner: MicrosoftMailFolderInner, systemName: MailFolderSystemName?) {
        self.id         = id
        self._inner     = _inner
        self.systemName = systemName
    }
}*/

extension _MicrosoftAPI {
    
    struct MicrosoftMailFolderInner : CodableValueType, Sendable {
        let               id: String
        let      displayName: String?
        let         isHidden: Bool?
        
        // parent-children relationship
        let   parentFolderId: String?
        let childFolderCount: Int32?
        
        // mailFolder-messages relationship
        let  unreadItemCount: Int32?
        let   totalItemCount: Int32?
    }
}
