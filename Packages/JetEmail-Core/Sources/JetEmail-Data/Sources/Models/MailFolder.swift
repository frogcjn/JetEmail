//
//  MailFolder.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import Foundation // for KeyPathComparator
import SwiftData  // for @Model
import Google
import Microsoft

@Model
public final class MailFolder {
    
    /// ID for storing in the database, for unique indexing. So this property is only used in #Query.
    public private(set) var rawPlatform : String
    public private(set) var platform    : Platform
    
    public private(set) var innerAccountID: String
    public private(set) var innerID       : String
    
    /// ID for storing in the database, for unique indexing. So this property is only used in #Query.
    @Attribute(.unique, originalName: "id")
    public private(set) var rawID       : String
    
    public var id: ID {
        @storageRestrictions(accesses: _$backingData, initializes: _platform, _rawPlatform, _innerAccountID, _innerID, _rawID)
        init(initialValue) {
            let (platform, innerAccountID, innerID, rawID) = (initialValue.platform, initialValue.innerAccountID, initialValue.innerID, initialValue.rawValue)
            _$backingData.setValue(forKey: \.platform,       to: platform         )
            _$backingData.setValue(forKey: \.rawPlatform,    to: platform.rawValue)
            _$backingData.setValue(forKey: \.innerAccountID, to: innerAccountID   )
            _$backingData.setValue(forKey: \.innerID,        to: innerID          )
            _$backingData.setValue(forKey: \.rawID,          to: rawID            )
            
            _platform       = _SwiftDataNoType()
            _rawPlatform    = _SwiftDataNoType()
            _innerAccountID = _SwiftDataNoType()
            _innerID        = _SwiftDataNoType()
            _rawID          = _SwiftDataNoType()
        }
        get {
            switch platform {
            case .microsoft: .microsoft(.init(accountID: .init(innerAccountID), .init(innerID)))
            case .google:       .google(.init(accountID: .init(innerAccountID), .init(innerID)))
            }
        }
        set {
            platform       = newValue.platform
            rawPlatform    = newValue.platform.rawValue
            innerAccountID = newValue.innerAccountID
            innerID        = newValue.innerID
            rawID          = newValue.rawValue
        }
    }
    
    public var name: String
    
    /// MailFolder.account <<-> Account.mailFolders
    @Relationship(deleteRule: .nullify)
    public var account: Account
    
    //@Relationship(deleteRule: .nullify)
    //var rootAccount: Account?
    
    /// MailFolder.parent <<-> MailFOlder.children
    @Relationship(deleteRule: .nullify)
    public var parent: MailFolder?
    
    /// MailFolder.children <->> MailFolder.parent
    @Relationship(deleteRule: .nullify, originalName: "children", inverse: \MailFolder.parent)
    private var _children: [MailFolder] = [] // Should be Ordered Relationship
    
    @Transient
    public var children: [MailFolder] {_children.sidebarSorted() } // TODO: After Swift 6.0
    
    /// MailFolder.messages <->> Message.mailFolder
    @Relationship(deleteRule: .cascade, originalName: "messages", inverse: \Message.mailFolder)
    private var _messages: [Message] = [] // Should be Ordered Relationship
    
    @Transient
    public var messages: [Message] { _messages.sorted(using: KeyPathComparator(\.date, order: .reverse))}
    
    public init(modelID: ID, name: String, in account: Account) {
        self.id  = modelID
        self.name     = name
        self.account  = account
    }
    
    public var _graph: String?
    public var _google: String?

    public var deleteMark = false {
        didSet {
            if deleteMark {
                messages.forEach { $0.deleteMark = true }
            }
        }
    }
}


