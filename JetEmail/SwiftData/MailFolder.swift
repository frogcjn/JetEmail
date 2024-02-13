//
//  MailFolder.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import Foundation
import SwiftData

@Model
class MailFolder {
    
    @Attribute(.unique)
    var id: String
    var _element: String
    var name: String

    /// MailFolder.account <<-> Account.mailFolders
    @Relationship(deleteRule: .nullify)
    var account: Account
    
    /// MailFolder.parent <<-> MailFOlder.children
    @Relationship(deleteRule: .nullify)
    var parent: MailFolder?
    
    /// MailFolder.children <->> MailFolder.parent
    @Relationship(deleteRule: .cascade, originalName: "children", inverse: \MailFolder.parent)
    private var _children: [MailFolder] = [] // Should be Ordered Relationship
    
    @Transient
    var children: [MailFolder] { _children.sorted(using: KeyPathComparator(\.name)) }
    
    /// MailFolder.messages <->> Message.mailFolder
    @Relationship(deleteRule: .cascade, originalName: "messages", inverse: \Message.mailFolder)
    var _messages: [Message] = [] // Should be Ordered Relationship
    
    @Transient
    var messages: [Message] { _messages.sorted(using: KeyPathComparator(\.receivedDate, order: .reverse))}
    
    init(element: Microsoft.Graph.MailFolder, in account: Account) {
        self.id       = element.id
        self.name     = element.displayName ?? ""
        self._element = element.encodeJSON() ?? ""
        self.account  = account
    }
            
    /*var data: Microsoft.Graph.MailFolder {
        get {
            _element.decodeJSON(Microsoft.Graph.MailFolder.self) ?? .init()
        }
        set {
            guard let element = newValue.encodeJSON() else { return }
            _element = element
        }
    }*/
}
/*
extension MailFolder : Hashable {
    
}
*/

