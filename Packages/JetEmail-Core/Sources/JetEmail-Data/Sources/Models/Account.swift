//
//  Account.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/12/24.
//

import Foundation
import SwiftData // for @Model
import Microsoft
import Google
import JetEmail_Foundation

@Model
public final class Account {
    /// ID for storing in the database, for unique indexing. So this property is only used in #Query.
    public private(set) var platform    : String
    
    public private(set) var innerID     : String
    
    /// ID for storing in the database, for unique indexing. So this property is only used in #Query.
    @Attribute(.unique)
    public private(set) var uniqueID   : String
    
    @Transient
    public lazy var resourceID: AccountID = {
        .init(platform: .init(rawValue: platform)!, innerID: innerID)
    }()
    /*public var id: ID {
        @storageRestrictions(accesses: _$backingData, initializes: _platform, _rawPlatform, _innerID, _uniqueID)
        init(initialValue) {
            let (platform, innerID, resourceID) = (initialValue.platform, initialValue.innerID, initialValue.uniqueID)
            _$backingData.setValue(forKey: \.platform,       to: platform         )
            _$backingData.setValue(forKey: \.rawPlatform,    to: platform.rawValue)
            _$backingData.setValue(forKey: \.innerID,        to: innerID          )
            _$backingData.setValue(forKey: \.uniqueID,       to: resourceID       )
            
            _platform       = _SwiftDataNoType()
            _rawPlatform    = _SwiftDataNoType()
            _innerID        = _SwiftDataNoType()
            _uniqueID       = _SwiftDataNoType()
        }
        get {
            .init(platform: platform, innerID: innerID)
            /*switch platform {
            case .microsoft: MicrosoftAccountID(platform: .microsoft, innerID: innerID)
            case .google:       GoogleAccountID(platform: .google,    innerID: innerID)
            }*/
        }
        set {
            platform       = newValue.platform
            rawPlatform    = newValue.platform.rawValue
            innerID        = newValue.innerID
            uniqueID       = newValue.uniqueID
        }
    }*/
    
    public var username: String
    
    public init(resourceID: ResourceID, username: String) {
        self.platform          = resourceID.platform.rawValue
        self.innerID           = resourceID.innerID
        self.uniqueID          = resourceID.uniqueID
        
        self.username = username
    }

    /// Account.root <-> MailFolder.account
    @Relationship(deleteRule: .nullify)
    public var root: MailFolder?
    
    /// Account.mailFolders <->> MailFolder.account
    @Relationship(deleteRule: .cascade, inverse: \MailFolder.account)
    public var mailFolders: [MailFolder] = []
    
    public var orderIndex: Int?
    // var isDeleted = false
        
    public var deleteMark = false { didSet {
        // .casecade
        if deleteMark {
            mailFolders.forEach { $0.deleteMark = true }
        }
    } }
}

