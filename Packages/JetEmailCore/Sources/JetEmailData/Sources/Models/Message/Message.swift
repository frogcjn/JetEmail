//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import struct Foundation.Date
import struct Foundation.Data
import        SwiftData  // for @Model

import func JetEmailFoundation.checkBackgroundThread

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
    
    // MARK: Resource - Headers

    
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
    //public private(set) var  deliveredTo: String?

    // MARK: Resource - Date

    public private(set) var         date: Date?
    /*public private(set) var  createdDate: Date?
    public private(set) var modifiedDate: Date?
    public private(set) var receivedDate: Date? // * Important *
    public private(set) var     sentDate: Date?*/
    
    // MARK: Resource - Body & Raw & Headers
    
    public private(set) var  bodyPreview: String?
    public private(set) var         body: MessageBody?
    
    public private(set) var      headers: [MessageHeader]? // auto translate into Blob of Data of JSON
    public private(set) var          raw: Data?            // Blob of Data
    // var   uniqueBody: Body?


    // MARK: Resource - Storage

    public private(set) var _resource: String?
    
    public init<MessageResource : MessageProtocol>(source: MessageResource, account: Account) {
        checkBackgroundThread()

        platform        = source.generalID.platform.rawValue
        innerAccountID  = source.generalID.accountID.innerID
        innerID         = source.generalID.innerID
        uniqueID        = source.generalID.uniqueID
        
        headers         = source.headers
        
        subject         = source.subject
        
        //createdDate     = source.createdDate
        //modifiedDate    = source.modifiedDate
        //receivedDate    = source.receivedDate
        //sentDate        = source.sentDate
        date            = source.date

        sender          = source.sender
        from            = source.from
        replyTo         = source.replyTo

        to              = source.to
        cc              = source.cc
        bcc             = source.bcc
        
        bodyPreview     = source.bodyPreview
        body            = source.body
        raw             = source.raw
        
        _resource       = try? source.jsonString
        
        self.account    = account
    }
    
    public func update<MessageResource: MessageProtocol>(source: MessageResource) {
        checkBackgroundThread()

        platform        = source.generalID.platform.rawValue
        innerAccountID  = source.generalID.accountID.innerID
        innerID         = source.generalID.innerID
        uniqueID        = source.generalID.uniqueID
        
        headers         = source.headers
        
        subject         = source.subject
        
        //createdDate     = source.createdDate
        //modifiedDate    = source.modifiedDate
        //receivedDate    = source.receivedDate
        //sentDate        = source.sentDate
        date            = source.date

        sender          = source.sender
        from            = source.from
        to              = source.to
        replyTo         = source.replyTo
        cc              = source.cc
        bcc             = source.bcc
        
        bodyPreview     = source.bodyPreview
        body            = source.body
        raw             = source.raw
        
        _resource       = try? source.jsonString
    }
    
    // MARK: - Relationships
    
    /// Message.account <<-> Account.messages
    @Relationship(deleteRule: .nullify)
    public var account: Account?
    
    /// Message.mailFolders <<->> MailFolder.messages
    @Relationship(deleteRule: .nullify)
    public var mailFolders: [MailFolder] = []
}
