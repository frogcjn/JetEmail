//
//  MailFolder.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import struct Foundation.KeyPathComparator
import        SwiftData  // for @Model

import func JetEmailFoundation.checkBackgroundThread

@Model
public final class MailFolder {
    
    // MARK: - Delete Mark
    
    public var deleteMark = false { didSet {
        // for casecade deleteMark
        if deleteMark {
            messages.forEach { $0.deleteMark = true }
        }
    } }
    
    // MARK: - Resource

    // MARK: Resource - ID

    public private(set) var platform      : String
    public private(set) var innerAccountID: String
    public private(set) var innerID       : String
    
    @Attribute(.unique)
    public private(set) var uniqueID      : String
    
    @Transient
    public private(set) lazy var resourceID: MailFolderID = {
        .init(platform: .init(rawValue: platform), innerAccountID: innerAccountID, innerID: innerID)
    }()
    
    // MARK: Resource - Name
    
    public private(set) var name: String?
    
    // MARK: Resource - SystemInfo
    
    public private(set) var systemName: MailFolderSystemName?    // cached sytem older
    
    /*public private(set) var   _isSystemFolder: Bool    // cached whether it is a system folder
    public private(set) var      _systemOrder: Int?    // cached sytem older
    public private(set) var _nameLocalizedKey: String? // cached localized name
    public private(set) var      _systemImage: String? // cached system image*/
    
    
    // MARK: Resource - Storage
    
    public private(set) var _resource: String?

    // MARK: - Init & Update

    public init<MailFolderResource : MailFolderProtocol>(resource: MailFolderResource, account: Account) {
        checkBackgroundThread()
        
        platform          = resource.generalID.platform.rawValue
        innerAccountID    = resource.generalID.accountID.innerID
        innerID           = resource.generalID.innerID
        uniqueID          = resource.generalID.uniqueID
        
        name              = resource.name
        systemName        = resource.systemName
        /*_isSystemFolder   = resource.systemInfo != nil
        _systemOrder      = resource.systemInfo?.order
        _nameLocalizedKey = resource.systemInfo?.nameLocalizedKey
        _systemImage      = resource.systemInfo?.systemImage*/
        
        _resource         = try? resource.jsonString
        self.account      = account
    }
    
    public func update<MailFolderResource : MailFolderProtocol>(resource: MailFolderResource) {
        checkBackgroundThread()

        platform          = resource.generalID.platform.rawValue
        innerAccountID    = resource.generalID.accountID.innerID
        innerID           = resource.generalID.innerID
        uniqueID          = resource.generalID.uniqueID
        
        name              = resource.name
        systemName        = resource.systemName

        /*_isSystemFolder   = resource.systemInfo != nil
        _systemOrder      = resource.systemInfo?.order
        _nameLocalizedKey = resource.systemInfo?.nameLocalizedKey
        _systemImage      = resource.systemInfo?.systemImage*/
        
        _resource         = try? resource.jsonString
    }
    
    // MARK: - Relationships
    
    /// MailFolder.account <<-> Account.mailFolders
    @Relationship(deleteRule: .nullify)
    public var account: Account
    
    /// MailFolder.parent <<-> MailFOlder.children
    @Relationship(deleteRule: .nullify)
    public var parent: MailFolder?
    public var  _childIndex: Int? // cached current child index in parent folder
    
    /// MailFolder.children <->> MailFolder.parent
    @Relationship(deleteRule: .nullify, originalName: "children", inverse: \MailFolder.parent)
    public var _children: [MailFolder] = [] // Should be Ordered Relationship

    @Transient
    public var children: [MailFolder] { _children.sortedByChildIndex } // TODO: After Swift 6.0
    
    /// MailFolder.messages <->> Message.mailFolder
    @Relationship(deleteRule: .cascade, originalName: "messages", inverse: \Message.mailFolders)
    public var _messages: [Message] = [] // Should be Ordered Relationship
    
    @Transient
    public var messages: [Message] { _messages.filter{ !$0.isDeleted }/*.sorted(using: KeyPathComparator(\.date, order: .reverse))*/}
}


public extension MailFolder {
    
    @Transient
    var isSystemFolder: Bool {
        systemName != nil
    }
    
    @Transient
    var localizedName : String {
        if let systemLocalizedName = systemName?.localized { return systemLocalizedName }
        if let name = name?.nilIfEmpty { return name }
        return String(localized: "(No Name)", bundle: .module)
    }
    
    @Transient
    var systemImage : String {
        systemName?.systemImage ?? "folder"
    }
}
