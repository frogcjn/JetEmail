//
//  MailFolder.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import SwiftData  // for @Model
import Foundation // for KeyPathComparator

@Model
class MailFolder : ModelItem {
    
    /// ID for storing in the database, for unique indexing. So this property is only used in #Query.
    @Attribute(.unique)
    private(set) var id: String
    private(set) var platform: String
    private(set) var platformID: String
    
    var modelID: ModelID {
        @storageRestrictions(accesses: _$backingData, initializes: _platform, _platformID, _id)
        init(initialValue) {
            let (platform, platformID, string) = (initialValue.platform, initialValue.platformID, initialValue.string)
            _$backingData.setValue(forKey: \.platform,   to: platform.rawValue)
            _$backingData.setValue(forKey: \.platformID, to: platformID)
            _$backingData.setValue(forKey: \.id,         to: string)

            _platform   = _SwiftDataNoType()
            _platformID = _SwiftDataNoType()
            _id         = _SwiftDataNoType()
        }
        get { .init(platform: .init(rawValue: platform)!, platformID: platformID) }
        set {
            platform   = newValue.platform.rawValue
            platformID = newValue.platformID
            id = newValue.string
        }
    }
    
    
    var name: String
    
    /// MailFolder.account <<-> Account.mailFolders
    @Relationship(deleteRule: .nullify)
    var account: Account
    
    //@Relationship(deleteRule: .nullify)
    //var rootAccount: Account?
    
    /// MailFolder.parent <<-> MailFOlder.children
    @Relationship(deleteRule: .nullify)
    var parent: MailFolder?
    
    /// MailFolder.children <->> MailFolder.parent
    @Relationship(deleteRule: .nullify, originalName: "children", inverse: \MailFolder.parent)
    private var _children: [MailFolder] = [] // Should be Ordered Relationship
    
    @Transient
    var children: [MailFolder] { _children.sorted(using: KeyPathComparator(\.name)) }
    
    /// MailFolder.messages <->> Message.mailFolder
    @Relationship(deleteRule: .cascade, originalName: "messages", inverse: \Message.mailFolder)
    var _messages: [Message] = [] // Should be Ordered Relationship
    
    @Transient
    var messages: [Message] { _messages.sorted(using: KeyPathComparator(\.date, order: .reverse))}
    
    init(modelID: ModelID, name: String, in account: Account) {
        self.modelID  = modelID
        self.name     = name
        self.account  = account
    }
    
    var _graph: String?
    var _google: String?

    var deleteMark = false {
        didSet {
            if deleteMark {
                messages.forEach { $0.deleteMark = true }
            }
        }
    }
    
}

extension MailFolder {
    
    var isBusy: Bool {
        get { AttributesStore[modelID].isBusy }
        set { AttributesStore[modelID].isBusy = newValue }
    }
    
    var appModel: AppModel { .shared }
}

extension MailFolder {
    @Observable
    class AttributesStore {
        var rawValue = [MailFolder.ModelID: MailFolder.Attributes]()
        
        static subscript(modelID: MailFolder.ModelID) -> MailFolder.Attributes {
            get {
                if let properties = shared.rawValue[modelID] { return properties }
                let properties = MailFolder.Attributes()
                shared.rawValue[modelID] = properties
                return properties
            }
            set { shared.rawValue[modelID] = newValue }
        }
    }
    
    struct Attributes {
        var isBusy = false
    }
}

extension MailFolder {
    var localizedName: String {
        switch self.modelID {
        case .google:
            guard let type = google?.type, let id = google?.id.string else { return name }
            switch type {
            case .system:
                // https://developers.google.com/gmail/api/guides/labels
                switch id {
                case "INBOX"              : return String(localized: "Google.MailFolder.INBOX")
                case "SPAM"               : return String(localized: "Google.MailFolder.SPAM")
                case "TRASH"              : return String(localized: "Google.MailFolder.TRASH")
                case "UNREAD"             : return String(localized: "Google.MailFolder.UNREAD")
                case "STARRED"            : return String(localized: "Google.MailFolder.STARRED")
                case "IMPORTANT"          : return String(localized: "Google.MailFolder.IMPORTANT")
                case "SENT"               : return String(localized: "Google.MailFolder.SENT")
                case "DRAFT"              : return String(localized: "Google.MailFolder.DRAFT")
                case "CHAT"               : return String(localized: "Google.MailFolder.CHAT")
                case "CATEGORY_PERSONAL"  : return String(localized: "Google.MailFolder.CATEGORY_PERSONAL")
                case "CATEGORY_SOCIAL"    : return String(localized: "Google.MailFolder.CATEGORY_SOCIAL")
                case "CATEGORY_PROMOTIONS": return String(localized: "Google.MailFolder.CATEGORY_PROMOTIONS")
                case "CATEGORY_UPDATES"   : return String(localized: "Google.MailFolder.CATEGORY_UPDATES")
                case "CATEGORY_FORUMS"    : return String(localized: "Google.MailFolder.CATEGORY_FORUMS")
                default:
                    return name
                }
            case .user: 
                return name
            }
        case .microsoft: 
            guard let wellKnownFolderName = microsoft?.wellKnownFolderName else { return name }
            switch wellKnownFolderName {
            case .archive                  : return String(localized: "Microsoft.MailFolder.archive")
            case .clutter                  : return String(localized: "Microsoft.MailFolder.clutter")
            case .conflicts                : return String(localized: "Microsoft.MailFolder.conflicts")
            case .conversationHistory      : return String(localized: "Microsoft.MailFolder.conversationHistory")
            case .deletedItems             : return String(localized: "Microsoft.MailFolder.deletedItems")
            case .drafts                   : return String(localized: "Microsoft.MailFolder.drafts")
            case .inbox                    : return String(localized: "Microsoft.MailFolder.inbox")
            case .junkEmail                : return String(localized: "Microsoft.MailFolder.junkEmail")
            case .localFailures            : return String(localized: "Microsoft.MailFolder.localFailures")
            case .msgFolderRoot            : return String(localized: "Microsoft.MailFolder.msgFolderRoot")
            case .outbox                   : return String(localized: "Microsoft.MailFolder.outbox")
            case .recoverableItemsDeletions: return String(localized: "Microsoft.MailFolder.recoverableItemsDeletions")
            case .scheduled                : return String(localized: "Microsoft.MailFolder.scheduled")
            case .searchFolders            : return String(localized: "Microsoft.MailFolder.searchFolders")
            case .sentItems                : return String(localized: "Microsoft.MailFolder.sentItems")
            case .serverFailures           : return String(localized: "Microsoft.MailFolder.serverFailures")
            case .syncIssues               : return String(localized: "Microsoft.MailFolder.syncIssues")
            }
        }
    }
    
    var systemImage: String {
        switch self.modelID {
        case .google:
            guard let type = google?.type, let id = google?.id.string else { return name }
            switch type {
            case .system:
                // https://developers.google.com/gmail/api/guides/labels
                switch id {
                case "INBOX"              : return "tray"
                case "SPAM"               : return "xmark.bin"
                case "TRASH"              : return "trash"
                case "UNREAD"             : return "envelope.badge"
                case "STARRED"            : return "star"
                case "IMPORTANT"          : return "bookmark"
                case "SENT"               : return "paperplane"
                case "DRAFT"              : return "doc"
                case "CHAT"               : return "bubble"
                case "CATEGORY_PERSONAL"  : return "person"
                case "CATEGORY_SOCIAL"    : return "person.2"
                case "CATEGORY_PROMOTIONS": return "tag"
                case "CATEGORY_UPDATES"   : return "info.circle"
                case "CATEGORY_FORUMS"    : return "bubble.left.and.bubble.right"
                default:
                    return "folder"
                }
            case .user:
                return "folder"
            }
        case .microsoft:
            guard let wellKnownFolderName = microsoft?.wellKnownFolderName else { return "folder" }
            switch wellKnownFolderName {
            case .archive                  : return "archivebox"
            case .clutter                  : return "shippingbox"
            case .conflicts                : return "bolt.trianglebadge.exclamationmark"
            case .conversationHistory      : return "bubble"
            case .deletedItems             : return "trash"
            case .drafts                   : return "doc"
            case .inbox                    : return "tray"
            case .junkEmail                : return "xmark.bin"
            case .localFailures            : return "exclamationmark.triangle"
            case .msgFolderRoot            : return "tree"
            case .outbox                   : return "tray.and.arrow.up"
            case .recoverableItemsDeletions: return "arrow.triangle.2.circlepath"
            case .scheduled                : return "clock"
            case .searchFolders            : return "magnifyingglass"
            case .sentItems                : return "paperplane"
            case .serverFailures           : return "server.rack"
            case .syncIssues               : return "exclamationmark.arrow.triangle.2.circlepath"
            }
        }
    }
}
            
    /*var graph: MSGraph.MailFolder {
        get {
            // (try? _element.jsonDecode(MSGraph.MailFolder.self)) ?? .init()
            fatalError()
        }
        set {
            guard let graphJSONString: String = try? newValue.jsonString else { return }
            self._element = graphJSONString
            self.id   = newValue.id.rawValue
            self.name = newValue.displayName ?? ""
        }
    }*/


