//
//  Recipient.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import MimeEmailParser

struct MailBox : Codable, Equatable {
    let    addrSpec: String
    let displayName: String?
}

extension MailBox {
    var rawValue: String {
        if let displayName { "\(displayName) <\(addrSpec)>" }
        else { addrSpec }
    }
}

extension Microsoft.EmailAddress {
    var rawValue: String {
        if let name { "\(name) <\(address)>" }
        else { address }
    }
}

extension String {
    var paringAddressList: [MailBox] { get throws {
        try MimeEmailParser().parseAddressList(addresses: self).map(\.mailbox)
    } }
    
    var parsingAddress: MailBox { get throws {
        try MimeEmailParser().parseSingleAddress(address: self).mailbox
    } }
}

extension Address {
    var mailbox: MailBox {
        .init(addrSpec: Address, displayName: Name)
    }
}

extension Microsoft.EmailAddress {
    var mailbox: MailBox {
        .init(addrSpec: address, displayName: name)
    }
}

/*
extension Address {
    init(rawValue: String) {
        //guard let address = MCOAddress(nonEncodedRFC822String: string) else {
        /*let b = try! MimeEmailParser().parseAddressList(addresses: rawValue)
            self.name = nil
            self.email = string
            return
         //}*/
        self.name = ""  //address.displayName
        self.email = "" //address.mailbox
    }
}*/
/*
extension Microsoft.EmailAddress {
    var recipient: Address {
        Address(email: address!, name: name)
    }
}
*/
