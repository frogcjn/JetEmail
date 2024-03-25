//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/7/24.
//

import struct Foundation.Data
import struct Foundation.Date
import        JetEmailData

public struct MicrosoftMessage : MicrosoftProtocol, PlatformSpecificMessageProtocol {
    public typealias GeneralID = MessageID
    
    public let          id: MicrosoftMessageID
           let      _inner: _MicrosoftAPI.MicrosoftMessageInner
    
    public let     subject: String?
    
    public let        from: String?
    public let      sender: String?
    public let     replyTo: String?
    
    public let          to: String?
    public let          cc: String?
    public let         bcc: String?
    
    public let        date: Date?
    
    public let     headers: [MessageHeader]?
    
    public let bodyPreview: String?
    public let        body: MessageBody?
    public let         raw: Data?
    
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
