//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

import struct Foundation.LocalizedStringResource
import JetEmailID
import JetEmailGoogle

fileprivate extension GoogleMailFolderInner {
    var isSystemFolder: Bool {
        guard let type = type else { return false }
        return type == .system
    }
    
    var systemOrder: Int? {
        guard isSystemFolder else { return nil }
        switch id {
        case "INBOX"              : return 0
        case "STARRED"            : return 1
        case "SNOOZED"            : return 2 // ?
        case "IMPORTANT"          : return 3
        case "CHAT"               : return 4
        case "SENT"               : return 5
        case "SCHEDULED"          : return 6 // ?
        case "DRAFT"              : return 7
        case "ALL"                : return 8 // All Mails
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
    }
        
    var nameLocalizedKey: String? {
        guard isSystemFolder else { return nil }
        switch id {
        case "INBOX"              : return LocalizedStringResource("Google.MailFolder.INBOX").key
        case "STARRED"            : return LocalizedStringResource("Google.MailFolder.STARRED").key
        case "SNOOZED"            : return LocalizedStringResource("Google.MailFolder.SNOOZED").key
        case "IMPORTANT"          : return LocalizedStringResource("Google.MailFolder.IMPORTANT").key
        case "CHAT"               : return LocalizedStringResource("Google.MailFolder.CHAT").key
        case "SENT"               : return LocalizedStringResource("Google.MailFolder.SENT").key
        case "SCHEDULED"          : return LocalizedStringResource("Google.MailFolder.SCHEDULED").key
        case "DRAFT"              : return LocalizedStringResource("Google.MailFolder.DRAFT").key
        case "ALL"                : return LocalizedStringResource("Google.MailFolder.ALL").key
        case "SPAM"               : return LocalizedStringResource("Google.MailFolder.SPAM").key
        case "TRASH"              : return LocalizedStringResource("Google.MailFolder.TRASH").key
        case "UNREAD"             : return LocalizedStringResource("Google.MailFolder.UNREAD").key
            
        case "CATEGORY_PERSONAL"  : return LocalizedStringResource("Google.MailFolder.CATEGORY_PERSONAL").key
        case "CATEGORY_SOCIAL"    : return LocalizedStringResource("Google.MailFolder.CATEGORY_SOCIAL").key
        case "CATEGORY_PROMOTIONS": return LocalizedStringResource("Google.MailFolder.CATEGORY_PROMOTIONS").key
        case "CATEGORY_UPDATES"   : return LocalizedStringResource("Google.MailFolder.CATEGORY_UPDATES").key
        case "CATEGORY_FORUMS"    : return LocalizedStringResource("Google.MailFolder.CATEGORY_FORUMS").key
        default: return nil
        }
    }
    
    var systemImage: String? {
        guard isSystemFolder else { return nil }
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
        default: return nil
        }
    }
}

extension GoogleMailFolderInner {
    var systemInfo: MailFolderSystemInfo? {
        guard isSystemFolder else { return nil }
        return .init(systemOrder: systemOrder, nameLocalizedKey: nameLocalizedKey, systemImage: systemImage)
    }
}

extension GoogleMailFolder {
    public static func all(accountID: GoogleAccountID) -> GoogleMailFolder {
        let inner = GoogleMailFolderInner(id: .init("ALL"), name: "ALL")
        return inner.with(accountID: accountID, systemInfo: inner.systemInfo)
    }
}

