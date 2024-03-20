//
//  Account.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/12/24.
//

import SwiftData // for @Model
import JetEmailID

@Model
public final class Account {
    
    // MARK: - Delete Mark
    
    public var deleteMark = false { didSet {
        // for casecade deleteMark
        if deleteMark {
            mailFolders.forEach { $0.deleteMark = true }
        }
    } }
    
    // MARK: - Resource
    
    // MARK: Resource - ID

    public private(set) var platform    : String
    public private(set) var innerID     : String
    
    @Attribute(.unique)
    public private(set) var uniqueID    : String
    
    @Transient
    public private(set) lazy var resourceID: AccountID = {
        .init(platform: .init(rawValue: platform), innerID: innerID)
    }()
    
    // MARK: Resource - Username
    
    public private(set) var username: String
    
    // MARK: - Init & Update
    
    public init<AccountResource: AccountProtocol>(resource: AccountResource) where AccountResource.GeneralID : UniqueID {
        checkBackgroundThread()
        
        platform          = resource.generalID.platform.rawValue
        innerID           = resource.generalID.innerID
        uniqueID          = resource.generalID.uniqueID
        
        username          = resource.username
    }
    
    public func update<AccountResource: AccountProtocol>(resource: AccountResource)  where AccountResource.GeneralID : UniqueID {
        checkBackgroundThread()

        platform          = resource.generalID.platform.rawValue
        innerID           = resource.generalID.innerID
        uniqueID          = resource.generalID.uniqueID
        
        username          = resource.username
    }

    // MARK: - Order

    public var orderIndex: Int?
    
    // MARK: - Relations

    /// Account.root <-> MailFolder.account
    @Relationship(deleteRule: .nullify)
    public var root: MailFolder?
    
    /// Account.mailFolders <->> MailFolder.account
    @Relationship(deleteRule: .cascade, inverse: \MailFolder.account)
    public var mailFolders: [MailFolder] = []
    
    /// Account.messages <->> Message.account
    @Relationship(deleteRule: .cascade, inverse: \Message.account)
    public var messages: [Message] = []
}

