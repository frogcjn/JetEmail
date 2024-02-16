//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import SwiftData  // for @Model
import Foundation // for Date

@Model
class Message {
    
    @Attribute(.unique)
    var id: String
    
    @Transient
    var modelID: ModelID {
        @storageRestrictions(accesses: _$backingData, initializes: _id)
        init(initialValue) {
            _$backingData.setValue(forKey: \.id, to: initialValue.string)
            _id = _SwiftDataNoType()
        }

        get { ModelID(id) }
        set { id = newValue.string }
    }
    
    var      subject: String?
    var  createdDate: Date?
    var modifiedDate: Date?
    var receivedDate: Date? // * Important *
    var     sentDate: Date?
    var       sender: Recipient?
    var         from: Recipient?
    var           to: [Recipient]? // * Important * to
    var      replyTo: [Recipient]? // 回复给
    var           cc: [Recipient]? // * Important * 抄送, carbon copy
    var          bcc: [Recipient]? // 密件抄送，密送，blind carbon copy*/
    
    var  bodyPreview: String?
    var         body: Body?
    var   uniqueBody: Body?

    
    /// Message.mailFolder <<-> MailFolder.messages
    @Relationship(deleteRule: .nullify)
    var mailFolder: MailFolder
    
    init(modelID: ModelID, in mailFolder: MailFolder) {
        self.modelID          = modelID
        self.mailFolder       = mailFolder
    }
    
    var _graph: String?
    
    @MainActor  // for isBusy
    @Attribute(.ephemeral)
    var isBusy = false
    
    var deleteMark = false
}

typealias Recipient = MSGraph.EmailAddress
typealias Body      = MSGraph.ItemBody
