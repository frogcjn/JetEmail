//
//  MailFolder+UI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

// isSystemFolder
// systemOrder
// localized: LocalizedStringResource
// systemImage
import JetEmailGoogle
import JetEmailMicrosoft
import Foundation
import JetEmailID

public extension PlatformCase<MicrosoftMailFolder, GoogleMailFolder> {
    var isSystemFolder: Bool {
        switch self {
        case .google(let google):
            guard let type = google.data.type else { return false }
            return type == .system
        case .microsoft(let microsoft):
            return microsoft.wellKnownFolderName != nil
        }
    }
    
    var systemOrder: Int? {
        guard isSystemFolder else { return nil }
        switch self {
        case .google(let google):
            switch google.data.name {
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
            
        case .microsoft(let microsoft):
            guard let wellKnownFolderName = microsoft.wellKnownFolderName else { return nil }
            switch wellKnownFolderName {
            case .inbox                    : return 0
            case .drafts                   : return 1
            case .archive                  : return 2
            case .sentItems                : return 3
            case .deletedItems             : return 4
            case .junkEmail                : return 5
            case .outbox                   : return 6
            case .scheduled                : return 7
            case .clutter                  : return 8
                // 便笺
            case .conversationHistory      : return Int.max
            default: return nil
            }
                
            /* return String(localized: "Microsoft.MailFolder.clutter")
            case .conflicts                : return String(localized: "Microsoft.MailFolder.conflicts")
            case .localFailures            : return String(localized: "Microsoft.MailFolder.localFailures")
            case .msgFolderRoot            : return String(localized: "Microsoft.MailFolder.msgFolderRoot")
            case .recoverableItemsDeletions: return String(localized: "Microsoft.MailFolder.recoverableItemsDeletions")
            case .searchFolders            : return String(localized: "Microsoft.MailFolder.searchFolders")
            case .serverFailures           : return String(localized: "Microsoft.MailFolder.serverFailures")
            case .syncIssues               : return String(localized: "Microsoft.MailFolder.syncIssues")*/
                
        }
    }
    
    var nameLocalizedKey: String? {
        switch self {
        case .google(let google):
            guard let type = google.data.type else { return nil }
            switch type {
            case .system:
                // https://developers.google.com/gmail/api/guides/labels
                switch google.data.name {
                    
                case "INBOX"              : return LocalizedStringResource("Google.MailFolder.INBOX").key
                case "STARRED"            : return LocalizedStringResource("Google.MailFolder.STARRED").key
                case "SNOOZED"            : return LocalizedStringResource("Google.MailFolder.SNOOZED").key
                case "IMPORTANT"          : return LocalizedStringResource("Google.MailFolder.IMPORTANT").key
                case "CHAT"               : return LocalizedStringResource("Google.MailFolder.CHAT").key
                case "SENT"               : return LocalizedStringResource("Google.MailFolder.SENT").key
                case "SCHEDULED"          : return LocalizedStringResource("Google.MailFolder.SCHEDULED").key
                case "DRAFT"              : return LocalizedStringResource("Google.MailFolder.DRAFT").key
                case ""                   : return LocalizedStringResource("Google.MailFolder.").key
                case "SPAM"               : return LocalizedStringResource("Google.MailFolder.SPAM").key
                case "TRASH"              : return LocalizedStringResource("Google.MailFolder.TRASH").key
                case "UNREAD"             : return LocalizedStringResource("Google.MailFolder.UNREAD").key

                case "CATEGORY_PERSONAL"  : return LocalizedStringResource("Google.MailFolder.CATEGORY_PERSONAL").key
                case "CATEGORY_SOCIAL"    : return LocalizedStringResource("Google.MailFolder.CATEGORY_SOCIAL").key
                case "CATEGORY_PROMOTIONS": return LocalizedStringResource("Google.MailFolder.CATEGORY_PROMOTIONS").key
                case "CATEGORY_UPDATES"   : return LocalizedStringResource("Google.MailFolder.CATEGORY_UPDATES").key
                case "CATEGORY_FORUMS"    : return LocalizedStringResource("Google.MailFolder.CATEGORY_FORUMS").key
                default:
                    return nil
                }
            case .user:
                return nil
            }
        case .microsoft(let microsoft):
            guard let wellKnownFolderName = microsoft.wellKnownFolderName else { return nil }
            switch wellKnownFolderName {
            case .archive                  : return LocalizedStringResource("Microsoft.MailFolder.archive").key
            case .clutter                  : return LocalizedStringResource("Microsoft.MailFolder.clutter").key
            case .conflicts                : return LocalizedStringResource("Microsoft.MailFolder.conflicts").key
            case .conversationHistory      : return LocalizedStringResource("Microsoft.MailFolder.conversationHistory").key
            case .deletedItems             : return LocalizedStringResource("Microsoft.MailFolder.deletedItems").key
            case .drafts                   : return LocalizedStringResource("Microsoft.MailFolder.drafts").key
            case .inbox                    : return LocalizedStringResource("Microsoft.MailFolder.inbox").key
            case .junkEmail                : return LocalizedStringResource("Microsoft.MailFolder.junkEmail").key
            case .localFailures            : return LocalizedStringResource("Microsoft.MailFolder.localFailures").key
            case .msgFolderRoot            : return LocalizedStringResource("Microsoft.MailFolder.msgFolderRoot").key
            case .outbox                   : return LocalizedStringResource("Microsoft.MailFolder.outbox").key
            case .recoverableItemsDeletions: return LocalizedStringResource("Microsoft.MailFolder.recoverableItemsDeletions").key
            case .scheduled                : return LocalizedStringResource("Microsoft.MailFolder.scheduled").key
            case .searchFolders            : return LocalizedStringResource("Microsoft.MailFolder.searchFolders").key
            case .sentItems                : return LocalizedStringResource("Microsoft.MailFolder.sentItems").key
            case .serverFailures           : return LocalizedStringResource("Microsoft.MailFolder.serverFailures").key
            case .syncIssues               : return LocalizedStringResource("Microsoft.MailFolder.syncIssues").key
            }
        }
    }
    
    var systemImage: String? {
        switch self {
        case .google(let google):
            guard let type = google.data.type else { return nil }
            switch type {
            case .system:
                // https://developers.google.com/gmail/api/guides/labels
                switch google.id.innerID {
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
                    return nil
                }
            case .user:
                return nil
            }
        case .microsoft(let microsoft):
            guard let wellKnownFolderName = microsoft.wellKnownFolderName else { return nil }
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
