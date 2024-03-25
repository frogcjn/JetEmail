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

extension _MicrosoftAPI {
    
    // MARK: - Message
    // https://learn.microsoft.com/en-us/graph/api/resources/message
    struct MicrosoftMessageInner : CodableValueType, Sendable {
        let                     id: String
        let internetMessageHeaders: [InternetMessageHeader]?
        
        let            bodyPreview: String?   // * Important *
        let                   body: ItemBody? // * Important * may load later
        
        let                   type: String
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
    

    // MARK: - MailFolder
    
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
    }
    
    // MARK: - Other
    
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
        let        type: String

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
        let         type: String

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
        let  type: String
        
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





// The Swift Programming Language
// https://docs.swift.org/swift-book

extension MicrosoftMessage {

    init(id: MicrosoftMessageID, _inner: _MicrosoftAPI.MicrosoftMessageInner, raw: Data?) {
        self.id    = id
        self._inner = _inner
        
        /*
         header fields:
            subject
            date
            from/sender/replyTo
            to/cc/bcc
         */
        if let headers = _inner.internetMessageHeaders {
            let headers = headers.map { MessageHeader(name: $0.name, value: $0.value) }
            self.headers = headers
            self.subject = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.subject.rawValue) == .orderedSame }?.value
            self.from    = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.from   .rawValue) == .orderedSame }?.value
            self.sender  = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.sender .rawValue) == .orderedSame }?.value
            self.replyTo = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.replyTo.rawValue) == .orderedSame }?.value
            self.to      = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.to     .rawValue) == .orderedSame }?.value
            self.cc      = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.cc     .rawValue) == .orderedSame }?.value
            self.bcc     = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.bcc    .rawValue) == .orderedSame }?.value
            self.date    = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.date   .rawValue) == .orderedSame }?.value.rfc2822
        } else {
            self.headers = nil
            self.subject = nil
            self.from    = nil
            self.sender  = nil
            self.replyTo = nil
            self.to      = nil
            self.cc      = nil
            self.bcc     = nil
            self.date    = nil
        }
        
        // Informational fields
        // subject      = inner.subject?.nilIfEmpty
        
        // Mailbox System
        /*receivedDate = inner.receivedDateTime?    .date // 2024-01-30 19:44:34 +0000
         createdDate = inner.createdDateTime?     .date // 2024-03-02 08:20:30 +0000
        modifiedDate = inner.lastModifiedDateTime?.date // 2024-03-02 21:46:30 +0000*/
        
        self.bodyPreview  = _inner.bodyPreview?.nilIfEmpty
        
        if let body = _inner.body, let contentType = body.contentType, let content = body.content {
            self.body = switch contentType {
            case .html: .init(text: content, html:content)
            case .text: .init(text: content, html: nil)
            }
        } else {
            self.body = nil
        }
        
        self.raw = raw
    }

}

// MARK: - Inner -> Outter

extension _MicrosoftAPI.MicrosoftMessageInner {
    func outer(accountID: MicrosoftAccountID, raw: Data?) -> MicrosoftMessage {
        .init(id: .init(accountID: accountID, innerID: id), _inner: self, raw: raw)
    }
    
    func id(accountID: MicrosoftAccountID) -> MicrosoftMessageID {
        .init(accountID: accountID, innerID: id)
    }
}

extension _MicrosoftAPI.MicrosoftMailFolderInner {
    func with(accountID: MicrosoftAccountID, _systemName: _MicrosoftAPI.MicrosoftMailFolderSystemName?) -> MicrosoftMailFolder {
        .init(id: .init(accountID: accountID, innerID: id), _inner: self, systemName: _systemName?.systemName, name: displayName)
    }
    
    func with(accountID: MicrosoftAccountID, _idToSystemName: [MicrosoftMailFolderID: _MicrosoftAPI.MicrosoftMailFolderSystemName]) -> MicrosoftMailFolder {
        with(accountID: accountID, _systemName: _idToSystemName[MicrosoftMailFolderID(accountID: accountID, innerID: id)])
    }
}
