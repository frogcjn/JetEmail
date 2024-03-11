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
import JetEmail_Foundation

@Model
public final class MailFolder {

    /// ID for storing in the database, for unique indexing. So this property is only used in #Query.
    public private(set) var platform       : String
    // public private(set) var platform    : Platform
    
    public private(set) var innerAccountID: String
    public private(set) var innerID       : String
    
    /// ID for storing in the database, for unique indexing. So this property is only used in #Query.
    @Attribute(.unique)
    public private(set) var uniqueID      : String
    
    @Transient
    public lazy var resourceID: MailFolderID = {
        .init(platform: .init(rawValue: platform), innerAccountID: innerAccountID, innerID: innerID)
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
    
    public var name: String
    
    /// MailFolder.account <<-> Account.mailFolders
    @Relationship(deleteRule: .nullify)
    public var account: Account
    
    //@Relationship(deleteRule: .nullify)
    //var rootAccount: Account?
    
    /// MailFolder.parent <<-> MailFOlder.children
    @Relationship(deleteRule: .nullify)
    public var parent: MailFolder?
    public var  _childIndex: Int? // cached child index in parent folder
    
    /// MailFolder.children <->> MailFolder.parent
    @Relationship(deleteRule: .nullify, originalName: "children", inverse: \MailFolder.parent)
    private var _children: [MailFolder] = [] // Should be Ordered Relationship

    //@Transient
    public var children: [MailFolder] { _children.sortedInParentMailFolderUsingIndex } // TODO: After Swift 6.0
    
    /// MailFolder.messages <->> Message.mailFolder
    @Relationship(deleteRule: .cascade, originalName: "messages", inverse: \Message.mailFolder)
    private var _messages: [Message] = [] // Should be Ordered Relationship
    
    @Transient
    public var messages: [Message] { _messages.sorted(using: KeyPathComparator(\.date, order: .reverse))}
    
    public init(resourceID: MailFolderID, name: String, info: MailFolderInfo, in account: Account) {
        // self.id      = modelID
        // self.platform       = modelID.platform
        self.platform          = resourceID.platform.rawValue
        self.innerAccountID    = resourceID.accountID.innerID
        self.innerID           = resourceID.innerID
        self.uniqueID          = resourceID.uniqueID
        
        self.name              = name
        self._isSystemFolder   = info._isSystemFolder
        self._systemOrder      = info._systemOrder
        self._nameLocalizedKey = info._nameLocalizedKey
        self._systemImage = info._systemImage
        self.account = account
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
    
    
    public let   _isSystemFolder: Bool    // cached whether it is a system folder
    public let      _systemOrder: Int?    // cached sytem older
    public let _nameLocalizedKey: String? // cached localized name
    public let      _systemImage: String? // cached system image
    
    // parent - children relationship
}



public struct MailFolderInfo : Codable {

    public let   _isSystemFolder: Bool
    public let      _systemOrder: Int?
    public let _nameLocalizedKey: String?
    public let      _systemImage: String?
    
    init(isSystemFolder: Bool, systemOrder: Int?, nameLocalizedKey: String?, systemImage: String?) {
        self._isSystemFolder   = isSystemFolder
        self._systemOrder      = systemOrder
        self._nameLocalizedKey = nameLocalizedKey
        self._systemImage      = systemImage
    }
}

public extension MailFolder {
    
    @Transient
    var localizedName : String {
        if let key = _nameLocalizedKey {
            return String(localized: String.LocalizationValue(key), bundle: .module)
        } else {
            return name
        }
    }
    
    @Transient
    var systemImage : String {
        _systemImage ?? "folder"
    }
}
