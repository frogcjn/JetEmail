//
//  MailFolder+UI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//


public extension MailFolder {
    var isSystemFolder: Bool {
        switch id {
        case .google:
            guard let type = google?.type else { return false }
            return type == .system
        case .microsoft:
            return microsoft?.wellKnownFolderName != nil
        }
    }
    
    var systemOrder: Int? {
        guard isSystemFolder else { return nil }
        switch id {
        case .google:
            switch name {
            case "INBOX"              : return 0
            case "STARRED"            : return 1
            case "SNOOZED"            : return 2 // ?
            case "IMPORTANT"          : return 3
            case "CHAT"               : return 4
            case "SENT"               : return 5
            case "SCHEDULED"          : return 6 // ?
            case "DRAFT"              : return 7
            case ""                   : return 8
            case "SPAM"               : return 9
            case "TRASH"              : return 10
            case "UNREAD"             : return 11 //?
                
            case "CATEGORY_SOCIAL"    : return 100
            case "CATEGORY_FORUMS"    : return 101
            case "CATEGORY_UPDATES"   : return 102
            case "CATEGORY_PROMOTIONS": return 103
            case "CATEGORY_PERSONAL"  : return 104
            
            default: return nil
            }
            
        case .microsoft:
            guard let wellKnownFolderName = microsoft?.wellKnownFolderName else { return nil }
            switch wellKnownFolderName {
            case .inbox                    : return 0
            case .drafts                   : return 1
            case .archive                  : return 2
            case .sentItems                : return 3
            case .deletedItems             : return 4
            case .junkEmail                : return 5
            case .outbox                   : return 6
            case .scheduled                : return 7
                // 便笺
            case .conversationHistory      : return Int.max
            default: return nil
            }
                
            /*case .clutter                  : return String(localized: "Microsoft.MailFolder.clutter")
            case .conflicts                : return String(localized: "Microsoft.MailFolder.conflicts")
            case .localFailures            : return String(localized: "Microsoft.MailFolder.localFailures")
            case .msgFolderRoot            : return String(localized: "Microsoft.MailFolder.msgFolderRoot")
            case .recoverableItemsDeletions: return String(localized: "Microsoft.MailFolder.recoverableItemsDeletions")
            case .searchFolders            : return String(localized: "Microsoft.MailFolder.searchFolders")
            case .serverFailures           : return String(localized: "Microsoft.MailFolder.serverFailures")
            case .syncIssues               : return String(localized: "Microsoft.MailFolder.syncIssues")*/
                
        }
    }
    
    
    var localizedName: String {
        switch id {
        case .google:
            guard let type = google?.type else { return name }
            switch type {
            case .system:
                // https://developers.google.com/gmail/api/guides/labels
                switch name {
                    
                case "INBOX"              : return String(localized: "Google.MailFolder.INBOX", bundle: .module)
                case "STARRED"            : return String(localized: "Google.MailFolder.STARRED", bundle: .module)
                case "SNOOZED"            : return String(localized: "Google.MailFolder.SNOOZED", bundle: .module)
                case "IMPORTANT"          : return String(localized: "Google.MailFolder.IMPORTANT", bundle: .module)
                case "CHAT"               : return String(localized: "Google.MailFolder.CHAT", bundle: .module)
                case "SENT"               : return String(localized: "Google.MailFolder.SENT", bundle: .module)
                case "SCHEDULED"          : return String(localized: "Google.MailFolder.SCHEDULED", bundle: .module)
                case "DRAFT"              : return String(localized: "Google.MailFolder.DRAFT", bundle: .module)
                case ""                   : return String(localized: "Google.MailFolder.", bundle: .module)
                case "SPAM"               : return String(localized: "Google.MailFolder.SPAM", bundle: .module)
                case "TRASH"              : return String(localized: "Google.MailFolder.TRASH", bundle: .module)
                case "UNREAD"             : return String(localized: "Google.MailFolder.UNREAD", bundle: .module)

                case "CATEGORY_PERSONAL"  : return String(localized: "Google.MailFolder.CATEGORY_PERSONAL", bundle: .module)
                case "CATEGORY_SOCIAL"    : return String(localized: "Google.MailFolder.CATEGORY_SOCIAL", bundle: .module)
                case "CATEGORY_PROMOTIONS": return String(localized: "Google.MailFolder.CATEGORY_PROMOTIONS", bundle: .module)
                case "CATEGORY_UPDATES"   : return String(localized: "Google.MailFolder.CATEGORY_UPDATES", bundle: .module)
                case "CATEGORY_FORUMS"    : return String(localized: "Google.MailFolder.CATEGORY_FORUMS", bundle: .module)
                default:
                    return name
                }
            case .user:
                return name
            }
        case .microsoft:
            guard let wellKnownFolderName = microsoft?.wellKnownFolderName else { return name }
            switch wellKnownFolderName {
            case .archive                  : return String(localized: "Microsoft.MailFolder.archive", bundle: .module)
            case .clutter                  : return String(localized: "Microsoft.MailFolder.clutter", bundle: .module)
            case .conflicts                : return String(localized: "Microsoft.MailFolder.conflicts", bundle: .module)
            case .conversationHistory      : return String(localized: "Microsoft.MailFolder.conversationHistory", bundle: .module)
            case .deletedItems             : return String(localized: "Microsoft.MailFolder.deletedItems", bundle: .module)
            case .drafts                   : return String(localized: "Microsoft.MailFolder.drafts", bundle: .module)
            case .inbox                    : return String(localized: "Microsoft.MailFolder.inbox", bundle: .module)
            case .junkEmail                : return String(localized: "Microsoft.MailFolder.junkEmail", bundle: .module)
            case .localFailures            : return String(localized: "Microsoft.MailFolder.localFailures", bundle: .module)
            case .msgFolderRoot            : return String(localized: "Microsoft.MailFolder.msgFolderRoot", bundle: .module)
            case .outbox                   : return String(localized: "Microsoft.MailFolder.outbox", bundle: .module)
            case .recoverableItemsDeletions: return String(localized: "Microsoft.MailFolder.recoverableItemsDeletions", bundle: .module)
            case .scheduled                : return String(localized: "Microsoft.MailFolder.scheduled", bundle: .module)
            case .searchFolders            : return String(localized: "Microsoft.MailFolder.searchFolders", bundle: .module)
            case .sentItems                : return String(localized: "Microsoft.MailFolder.sentItems", bundle: .module)
            case .serverFailures           : return String(localized: "Microsoft.MailFolder.serverFailures", bundle: .module)
            case .syncIssues               : return String(localized: "Microsoft.MailFolder.syncIssues", bundle: .module)
            }
        }
    }
    
    var systemImage: String {
        switch id {
        case .google:
            guard let type = google?.type, let innerID = google?.id.rawValue else { return name }
            switch type {
            case .system:
                // https://developers.google.com/gmail/api/guides/labels
                switch innerID {
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
