//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import Foundation // for Date
import SwiftData  // for @Model
import JetEmailID

// @dynamicMemberLookup
@Model
public final class Message {
    
    // MARK: - Delete Mark
    
    public var deleteMark = false
    
    // MARK: - Resource
    
    // MARK: Resource - ID

    public private(set) var platform       : String    
    public private(set) var innerAccountID: String
    public private(set) var innerID       : String
    
    @Attribute(.unique)
    public private(set) var uniqueID      : String
    
    @Transient
    public private(set) lazy var resourceID: MessageID = {
        .init(platform: .init(rawValue: platform), innerAccountID: innerAccountID, innerID: innerID)
    }()
    
    // MARK: Resource - Subject
    
    public private(set) var      subject: String?
    
    // MARK: Resource - Originator Fields
    
    public private(set) var         from: String? // important
    public private(set) var       sender: String?
    public private(set) var      replyTo: String? // 回复给
    
    // MARK: Resource - Destination Address Fields

    public private(set) var           to: String? // * Important * to
    public private(set) var           cc: String? // * Important * 抄送, carbon copy
    public private(set) var          bcc: String? // 密件抄送，密送，blind carbon copy*/
    public private(set) var  deliveredTo: String?

    // MARK: Resource - Date

    public private(set) var         date: Date?
    public private(set) var  createdDate: Date?
    public private(set) var modifiedDate: Date?
    public private(set) var receivedDate: Date? // * Important *
    public private(set) var     sentDate: Date?
    
    // MARK: Resource - Body & Raw
    
    public private(set) var  bodyPreview: String?
    public private(set) var         body: MessageBody?
    public private(set) var          raw: Data?
    // var   uniqueBody: Body?


    // MARK: Resource - Storage

    public private(set) var _resource: String?
    
    public init<MessageResource : MessageProtocol>(resource: MessageResource, account: Account) where MessageResource.GeneralID : UniqueID {
        checkBackgroundThread()

        platform        = resource.generalID.platform.rawValue
        innerAccountID  = resource.generalID.accountID.innerID
        innerID         = resource.generalID.innerID
        uniqueID        = resource.generalID.uniqueID
        
        subject         = resource.subject
        
        createdDate     = resource.createdDate
        modifiedDate    = resource.modifiedDate
        receivedDate    = resource.receivedDate
        sentDate        = resource.sentDate
        date            = resource.date

        sender          = resource.sender
        from            = resource.from
        to              = resource.to
        replyTo         = resource.replyTo
        cc              = resource.cc
        bcc             = resource.bcc
        
        bodyPreview     = resource.bodyPreview
        body            = resource.body
        raw             = resource.raw
        
        _resource       = try? resource.jsonString
        
        self.account    = account
    }
    
    public func update<MessageResource: MessageProtocol>(resource: MessageResource) where MessageResource.GeneralID : UniqueID {
        checkBackgroundThread()

        platform        = resource.generalID.platform.rawValue
        innerAccountID  = resource.generalID.accountID.innerID
        innerID         = resource.generalID.innerID
        uniqueID        = resource.generalID.uniqueID
        
        subject         = resource.subject
        
        createdDate     = resource.createdDate
        modifiedDate    = resource.modifiedDate
        receivedDate    = resource.receivedDate
        sentDate        = resource.sentDate
        date            = resource.date

        sender          = resource.sender
        from            = resource.from
        to              = resource.to
        replyTo         = resource.replyTo
        cc              = resource.cc
        bcc             = resource.bcc
        
        bodyPreview     = resource.bodyPreview
        body            = resource.body
        raw             = resource.raw
        
        _resource       = try? resource.jsonString
    }
    
    // MARK: - Relationships
    
    /// Message.account <<-> Account.messages
    @Relationship(deleteRule: .nullify)
    public var account: Account
    
    /// Message.mailFolders <<->> MailFolder.messages
    @Relationship(deleteRule: .nullify)
    public var mailFolders: [MailFolder] = []
}
