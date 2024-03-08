//
//  Message+UI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import JetEmail_Data

extension Message {
    var senderField: String? {
        let fromMailboxes = (try? from?.mailboxs) ?? []
        let senderMailboxes = (try? sender?.mailboxs) ?? []
        let mailboxes = (fromMailboxes + senderMailboxes).compactMap { $0.displayName }
        if mailboxes.count == 0 {
            return nil
        } else {
            return mailboxes.joined(separator: ", ")
        }
    }
}
