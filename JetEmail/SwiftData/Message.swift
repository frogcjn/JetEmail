//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import Foundation
import SwiftData

@Model
class Message {
    
    @Attribute(.unique)
    var id: String
    var _element: String
    var subject: String?
    var receivedDate: Date?
    var bodyPreview: String?
    var bodyContentType: Microsoft.Graph.ItemBody.ContentType?
    var bodyContent: String?
    
    /// Message.mailFolder <<-> MailFolder.messages
    @Relationship(deleteRule: .nullify)
    var mailFolder: MailFolder
    
    init(element: Microsoft.Graph.Message, in mailFolder: MailFolder) {
        self.id              = element.id
        self.subject         = element.subject
        self.receivedDate    = element.receivedDateTime?.date
        self.bodyPreview     = element.bodyPreview
        self.bodyContentType = element.body?.contentType
        self.bodyContent     = element.body?.content
        self._element        = element.encodeJSON() ?? ""
        self.mailFolder      = mailFolder
    }
            
    var element: Microsoft.Graph.Message {
        get {
            _element.decodeJSON(Microsoft.Graph.Message.self) ?? .init()
        }
        set {
            guard let element = newValue.encodeJSON() else { return }
            _element = element
        }
    }
}

extension Message : Hashable {
    static func ==(lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
