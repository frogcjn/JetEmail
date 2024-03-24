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
           let      _inner: GoogleMessageInner
    
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
}
