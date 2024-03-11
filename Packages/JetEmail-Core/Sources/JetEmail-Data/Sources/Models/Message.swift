//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import SwiftData  // for @Model
import Foundation // for Date
import Google
import Microsoft
import JetEmail_Foundation

// @dynamicMemberLookup
@Model
public final class Message {

    /// ID for storing in the database, for unique indexing. So this property is only used in #Query.
    public private(set) var platform       : String
    // public private(set) var platform    : Platform
    
    public private(set) var innerAccountID: String
    public private(set) var innerID       : String
    
    /// ID for storing in the database, for unique indexing. So this property is only used in #Query.
    @Attribute(.unique)
    public private(set) var uniqueID      : String
    
    @Transient
    public lazy var resourceID: MessageID = {
        .init(platform: .init(rawValue: platform)!, innerAccountID: innerAccountID, innerID: innerID)
    }()
    
    /*public var id: ID {
        @storageRestrictions(accesses: _$backingData, initializes: _platform, _rawPlatform, _innerAccountID, _innerID, _uniqueID)
        init(initialValue) {
            let (platform, innerAccountID, innerID, uniqueID) = (initialValue.platform, initialValue.accountID.innerID, initialValue.innerID, initialValue.uniqueID)
            _$backingData.setValue(forKey: \.platform,       to: platform         )
            _$backingData.setValue(forKey: \.rawPlatform,    to: platform.rawValue)
            _$backingData.setValue(forKey: \.innerAccountID, to: innerAccountID   )
            _$backingData.setValue(forKey: \.innerID,        to: innerID          )
            _$backingData.setValue(forKey: \.uniqueID,       to: uniqueID         )
            
            _platform       = _SwiftDataNoType()
            _rawPlatform    = _SwiftDataNoType()
            _innerAccountID = _SwiftDataNoType()
            _innerID        = _SwiftDataNoType()
            _uniqueID       = _SwiftDataNoType()
        }
        get {
            .init(platform: platform, accountID: .init(platform: platform, innerID: innerAccountID), innerID: innerID)
        }
        set {
            platform       = newValue.platform
            rawPlatform    = newValue.platform.rawValue
            innerAccountID = newValue.accountID.innerID
            innerID        = newValue.innerID
            uniqueID       = newValue.uniqueID
        }
    }*/
    
    public var      subject: String?
    
    // Originator Fields
    
    public var         from: String?
    public var       sender: String?
    public var      replyTo: String? // 回复给
    
    // Destination Address Fields
    public var           to: String? // * Important * to
    public var           cc: String? // * Important * 抄送, carbon copy
    public var          bcc: String? // 密件抄送，密送，blind carbon copy*/
    public var  deliveredTo: String?

    public var         date: Date?
    public var  createdDate: Date?
    public var modifiedDate: Date?
    public var receivedDate: Date? // * Important *
    public var     sentDate: Date?
    
    /* Orgnized */
    
    public var  bodyPreview: String?
    public var         body: Body?
    public var          raw: Data?
    // var   uniqueBody: Body?

    
    /// Message.mailFolder <<-> MailFolder.messages
    @Relationship(deleteRule: .nullify)
    public var mailFolder: MailFolder
    
    public init(resourceID: ResourceID, in mailFolder: MailFolder) {
        // self.id          = modelID
        self.platform          = resourceID.platform.rawValue
        self.innerAccountID    = resourceID.accountID.innerID
        self.innerID           = resourceID.innerID
        self.uniqueID          = resourceID.uniqueID
        
        self.mailFolder  = mailFolder
    }
    
    public var deleteMark = false
    
    
    
    
    public var _graph : String?
    public var _google: String?
}
/*
@MainActor // for @MainActor AttributesStore
extension Message {
    
    var isBusy: Bool {
        get { AttributesStore[id].isBusy }
        set { AttributesStore[id].isBusy = newValue }
    }
    
    var isClassifying: Bool {
        get { AttributesStore[id].isClassifying }
        set { AttributesStore[id].isClassifying = newValue }
    }
    
    var movePlan: MailFolder? {
        get { AttributesStore[id].movePlan }
        set { AttributesStore[id].movePlan = newValue }
    }
    
    /*subscript<Value>(dynamicMember keyPath: KeyPath<Attributes, Value>) -> Value {
        AttributesStore[modelID][keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Attributes, Value>) -> Value {
        _read { yield AttributesStore[modelID][keyPath: keyPath] }
        _modify { yield &AttributesStore[modelID][keyPath: keyPath] }
    }*/
    
    @MainActor // for @MainActor AttributesStore
    @Observable
    class AttributesStore {
        var rawValue = [Message.ID: Message.Attributes]()
        
        static subscript(modelID: Message.ID) -> Message.Attributes {
            get {
                if let properties = shared.rawValue[modelID] { return properties }
                let properties = Message.Attributes()
                shared.rawValue[modelID] = properties
                return properties
            }
            set { shared.rawValue[modelID] = newValue }
        }
    }
    
    struct Attributes {
        var isBusy = false
        var isClassifying = false
        var movePlan: MailFolder? = nil
        var isMoveToVisible = false
    }
}*/
/*
struct Recipient {
    let email: String
    let name: String?
}
*/


