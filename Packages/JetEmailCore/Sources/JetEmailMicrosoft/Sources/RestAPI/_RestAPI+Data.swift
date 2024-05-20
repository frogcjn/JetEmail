//
//  MailFolder.Others.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/7/24.
//

import typealias JetEmailFoundation.CodableValueType
import struct Foundation.Date
import struct Foundation.Data
import JetEmailData
    
enum _MicrosoftAPI {}

// MARK: - MailFolder

extension _MicrosoftAPI {
    
    // https://learn.microsoft.com/en-us/graph/api/resources/message
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
        
        let             type: String?
        
        enum CodingKeys: String, CodingKey, Sendable {
            case id
            case displayName
            case isHidden
            
            case parentFolderId
            case childFolderCount
            
            case unreadItemCount
            case totalItemCount
            
            case    type = "@odata.type"
        }

    }
}

// MARK: - Message

extension _MicrosoftAPI {
    
    // https://learn.microsoft.com/en-us/graph/api/resources/message
    struct MicrosoftMessageInner : CodableValueType, Sendable {
        let                     id: String
        let internetMessageHeaders: [InternetMessageHeader]?
        
        let            bodyPreview: String?   // * Important *
        let                   body: ItemBody? // * Important * may load later
        
        let                   type: String?
        let                   etag: String?
        
        // https://learn.microsoft.com/en-us/graph/api/message-delta
        // https://learn.microsoft.com/en-us/graph/delta-query-messages
        let                removed: Removed?
        
        enum CodingKeys: String, CodingKey, Sendable {
            case id
            case internetMessageHeaders
            case bodyPreview
            case body
            
            case    type = "@odata.type"
            case    etag = "@odata.etag"
            case removed = "@removed"
        }
    }
}

// MARK: - Inner -> Outter

extension _MicrosoftAPI.MicrosoftMessageInner {
    func id(accountID: MicrosoftAccountID) -> MicrosoftMessageID {
        .init(accountID: accountID, innerID: id)
    }
    
    func outer(accountID: MicrosoftAccountID, raw: Data?) -> MicrosoftMessage {
        .init(id: .init(accountID: accountID, innerID: id), _inner: self, raw: raw)
    }
}

extension _MicrosoftAPI.MicrosoftMailFolderInner {
    func id(accountID: MicrosoftAccountID) -> MicrosoftMailFolderID {
        .init(accountID: accountID, innerID: id)
    }
    func outer(accountID: MicrosoftAccountID, _systemName: _MicrosoftAPI.MicrosoftMailFolderSystemName?) -> MicrosoftMailFolder {
        return .init(id: .init(accountID: accountID, innerID: id), _inner: self, _systemName: _systemName, name: displayName)
    }
    
    func outer(accountID: MicrosoftAccountID, _idToSystemName: IDToSystemName?) -> MicrosoftMailFolder {
        outer(accountID: accountID, _systemName: _idToSystemName?[id(accountID: accountID)])
    }
}

// MARK: - Other
    
extension _MicrosoftAPI {
    
    /*
     The date and time the message was created.
     The date and time information uses ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z.
     */
    // https://learn.microsoft.com/en-us/graph/api/resources/message?view=graph-rest-1.0
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
        let     content: String?
        let contentType: ContentType?
        let        type: String?

        enum ContentType : String, CodableValueType, Sendable {
            case text
            case html
        }
        
        enum CodingKeys: String, CodingKey, Sendable {
            case     content
            case contentType
            case        type = "@odata.type"
        }
    }
    
    // https://learn.microsoft.com/en-us/graph/api/resources/recipient
    struct Recipient : CodableValueType, Sendable {
        let emailAddress: EmailAddress?
        let         type: String?

        enum CodingKeys: String, CodingKey, Sendable {
            case emailAddress
            case         type = "@odata.type"
        }
    }
    
    // https://learn.microsoft.com/en-us/graph/api/resources/emailaddress
    struct EmailAddress: CodableValueType, Sendable {
        let address: String
        let    name: String?
    }
    
    struct InternetMessageHeader : CodableValueType, Sendable {
        let  name: String
        let value: String
        let  type: String?
        
        enum CodingKeys: String, CodingKey, Sendable {
            case  name
            case value
            case  type = "@odata.type"
        }
    }
    
    // https://learn.microsoft.com/en-us/graph/api/message-delta
    // https://learn.microsoft.com/en-us/graph/delta-query-messages
    struct Removed : CodableValueType, Sendable {
        let reason: Reason
        enum Reason: String, CodableValueType, Sendable {
            case changed
            case deleted
        }
    }
}
