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
}

