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

@Model
public final class Account {
    /// ID for storing in the database, for unique indexing. So this property is only used in #Query.
    public private(set) var rawPlatform : String
    public private(set) var platform    : Platform
    
    public private(set) var platformID  : String
    
    /// ID for storing in the database, for unique indexing. So this property is only used in #Query.
    @Attribute(.unique, originalName: "id")
    public private(set) var rawID       : String
    
    public var id: ID {
        @storageRestrictions(accesses: _$backingData, initializes: _platform, _rawPlatform, _platformID, _rawID)
        init(initialValue) {
            let (platform, platformID, uniqueID) = (initialValue.platform, initialValue.platformID, initialValue.rawValue)
            _$backingData.setValue(forKey: \.platform,    to: platform         )
            _$backingData.setValue(forKey: \.rawPlatform, to: platform.rawValue)
            _$backingData.setValue(forKey: \.platformID,  to: platformID       )
            _$backingData.setValue(forKey: \.rawID,       to: uniqueID         )
            
            _platform    = _SwiftDataNoType()
            _rawPlatform = _SwiftDataNoType()
            _platformID  = _SwiftDataNoType()
            _rawID       = _SwiftDataNoType()
        }
        get {
            .init(platform: platform, platformID: platformID)
        }
        set {
            platform    = newValue.platform
            rawPlatform = newValue.platform.rawValue
            platformID  = newValue.platformID
            rawID       = newValue.rawValue
        }
    }
    
    public var username: String
    
    public init(id: ID, username: String) {
        self.id       = id
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
