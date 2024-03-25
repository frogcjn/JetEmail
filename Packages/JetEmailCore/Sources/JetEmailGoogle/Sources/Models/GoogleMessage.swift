//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import struct Foundation.Data
import struct Foundation.Date
import JetEmailData

public struct GoogleMessage : GoogleProtocol, PlatformSpecificMessageProtocol {
    public typealias GeneralID = MessageID
    
    public let          id: GoogleMessageID
           let      _inner: _GoogleAPI.GoogleMessageInner
    
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
    
    init(id: GoogleMessageID, _inner: _GoogleAPI.GoogleMessageInner, raw: Data?) throws {
        self.id     = id
        self._inner = _inner
        
        /*
         header fields:
            subject
            from/sender/replyTo/to/cc/bcc
            messageID/inReplyTo/references
         */
        
        if let headers = _inner.payload?.headers {
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
        
        self.body        = try _inner.payload?.messageBody
        self.bodyPreview = _inner.snippet
        self.raw         = _inner.raw ?? raw
    }
}
