//
//  MailFolder.Others.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/7/24.
//

import JetEmailID
import Foundation

    
/*
 The date and time the message was created.
 The date and time information uses ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z.
 */
public struct DateTimeOffset: RawRepresentable, CodableValueType, Sendable {
    //let date: Date
    public let rawValue: String
    public let date: Date
    public init?(rawValue: String) {
        guard let date = rawValue.iso8601 else { return nil }
        self.rawValue = rawValue
        self.date = date
    }
}

// https://learn.microsoft.com/en-us/graph/api/resources/itembody

public struct ItemBody : CodableValueType, Sendable {
    public let content: String?
    public let contentType: ContentType?
    
    public enum ContentType : String, CodableValueType, Sendable {
        case text
        case html
    }
}

// https://learn.microsoft.com/en-us/graph/api/resources/recipient

public struct Recipient : CodableValueType, Sendable {
    public let emailAddress: EmailAddress?
}

// https://learn.microsoft.com/en-us/graph/api/resources/emailaddress

public struct EmailAddress: CodableValueType, Sendable {
    public let address: String
    public let name: String?
}

public extension EmailAddress {
    var rawValue: String {
        if let name { "\(name) <\(address)>" }
        else { address }
    }
}
