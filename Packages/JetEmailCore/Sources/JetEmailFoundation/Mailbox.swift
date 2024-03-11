//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/5/24.
//

import MimeEmailParser

public struct MailBox : Codable, Equatable {
    public let    addrSpec: String
    public let displayName: String?
}

public extension MailBox {
    var rawValue: String {
        if let displayName { "\(displayName) <\(addrSpec)>" }
        else { addrSpec }
    }
}

public extension String {
    var mailboxs: [MailBox] { get throws {
        try MimeEmailParser().parseAddressList(addresses: self).map(\.mailbox)
    } }
    
    var mailbox: MailBox { get throws {
        try MimeEmailParser().parseSingleAddress(address: self).mailbox
    } }
}

public extension Address {
    var mailbox: MailBox {
        .init(addrSpec: Address, displayName: Name)
    }
}
