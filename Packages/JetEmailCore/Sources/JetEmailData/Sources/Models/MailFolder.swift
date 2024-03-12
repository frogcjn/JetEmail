//
//  MailFolder.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import Foundation // for KeyPathComparator
import SwiftData  // for @Model
import JetEmailID

@Model
public final class MailFolder {
    
    // MARK: - Delete Mark
    
    public var deleteMark = false {
        didSet {
            if deleteMark {
                messages.forEach { $0.deleteMark = true }
            }
        }
    }
    
    
    // MARK: - Resource

    // MARK: ResourceID

    /// ID for storing in the database, for unique indexing. So this property is only used in #Query.
    public private(set) var platform      : String
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
    
    // MARK: name
    
    public var name: String?
    
    
    // MARK: systemInfo
    
    public var   _isSystemFolder: Bool    // cached whether it is a system folder
    public var      _systemOrder: Int?    // cached sytem older
    public var _nameLocalizedKey: String? // cached localized name
    public var      _systemImage: String? // cached system image
    
    
    // MARK: resource
    
    public var _resource: String?


    public init(resource: MailFolderResource, in account: Account) {
        checkBackgroundThread()
        
        platform          = resource.id.platform.rawValue
        innerAccountID    = resource.id.accountID.innerID
        innerID           = resource.id.innerID
        uniqueID          = resource.id.uniqueID
        
        name              = resource.name
        _isSystemFolder   = resource.systemInfo != nil
        _systemOrder      = resource.systemInfo?.order
        _nameLocalizedKey = resource.systemInfo?.nameLocalizedKey
        _systemImage      = resource.systemInfo?.systemImage
        
        _resource         = try? resource.jsonString
        
        self.account = account
    }
    
    public func update(resource: MailFolderResource, in account: Account) {
        checkBackgroundThread()

        platform          = resource.id.platform.rawValue
        innerAccountID    = resource.id.accountID.innerID
        innerID           = resource.id.innerID
        uniqueID          = resource.id.uniqueID
        
        name              = resource.name
        _isSystemFolder   = resource.systemInfo != nil
        _systemOrder      = resource.systemInfo?.order
        _nameLocalizedKey = resource.systemInfo?.nameLocalizedKey
        _systemImage      = resource.systemInfo?.systemImage
        
        _resource         = try? resource.jsonString
        
        self.account = account
    }
    
    /// MailFolder.account <<-> Account.mailFolders
    @Relationship(deleteRule: .nullify)
    public var account: Account
    
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
}


public extension MailFolder {
    
    @Transient
    var localizedName : String {
        if let key = _nameLocalizedKey {
            let result = String(localized: .init(key), bundle: .module)
            if key == result { return name ?? "" }
            else { return result }
        } else {
            return name ?? String(localized: "(MailFolder.NoName)", defaultValue: .init(name ?? ""))
        }
    }
    
    @Transient
    var systemImage : String {
        _systemImage ?? "folder"
    }
}
