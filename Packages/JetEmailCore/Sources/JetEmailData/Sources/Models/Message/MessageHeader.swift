//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/24/24.
//

public struct MessageHeader : CodableValueType, Sendable {
    public let  name: String
    public let value: String
    public init(name: String, value: String) {
        self.name  = name
        self.value = value
    }
}

public protocol MessageHeaderProtocol {
    var  name: String { get }
    var value: String { get }
}


public enum MessageHeaderName: String, CodableValueType, Sendable {
    case subject     = "Subject"

    case from        = "From"
    case sender      = "Sender"
    case replyTo     = "Reply-To"

    case to          = "To"
    case cc          = "Cc"
    case bcc         = "Bcc"
    case deliveredTo = "Delivered-To"

    case date        = "Date"
}
    //static let messageID   = "Message-ID"
    //static let inReplyTo   = "In-Reply-To"
    //static let references  = "References"
