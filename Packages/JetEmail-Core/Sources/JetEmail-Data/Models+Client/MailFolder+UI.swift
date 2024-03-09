//
//  MailFolder+UI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

public extension MailFolder {
    var isSystemFolder: Bool {
        switch self.id {
        case .google:
            guard let type = google?.type else { return false }
            return type == .system
        case .microsoft:
            return microsoft?.wellKnownFolderName != nil
        }
    }
    
    var localizedName: String {
        switch self.id {
        case .google:
            guard let type = google?.type, let id = google?.id.rawValue else { return name }
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
        switch self.id {
        case .google:
            guard let type = google?.type, let id = google?.id.rawValue else { return name }
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
