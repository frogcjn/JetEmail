//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/7/24.
//

import JetEmailMicrosoft
import JetEmailGoogle
import JetEmailID

extension Account.AttributesStore {
    static var shared = AttributesStore()
}

extension MailFolder.AttributesStore {
    static var shared = AttributesStore()
}

extension Message.AttributesStore {
    static var shared = AttributesStore()
}

public extension Clients {
    static var shared = Clients()
}
