//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import SwiftData  // for @Model
import Foundation // for Date

@Model
class Message : ModelItem {
    
    /// ID for storing in the database, for unique indexing. So this property is only used in #Query.
    @Attribute(.unique)
    private(set) var id: String
    private(set) var platform: String
    private(set) var platformID: String
    
    var modelID: ModelID {
        @storageRestrictions(accesses: _$backingData, initializes: _platform, _platformID, _id)
        init(initialValue) {
            let (platform, platformID, string) = (initialValue.platform, initialValue.platformID, initialValue.string)
            _$backingData.setValue(forKey: \.platform,   to: platform.rawValue)
            _$backingData.setValue(forKey: \.platformID, to: platformID)
            _$backingData.setValue(forKey: \.id,         to: string)

            _platform   = _SwiftDataNoType()
            _platformID = _SwiftDataNoType()
            _id         = _SwiftDataNoType()
        }
        get { .init(platform: .init(rawValue: platform)!, platformID: platformID) }
        set {
            platform   = newValue.platform.rawValue
            platformID = newValue.platformID
            id = newValue.string
        }
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
    
    var account: Account { mailFolder.account }
}

typealias Recipient = Microsoft.EmailAddress
typealias Body      = Microsoft.ItemBody
