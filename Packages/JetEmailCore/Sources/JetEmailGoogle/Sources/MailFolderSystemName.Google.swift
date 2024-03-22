//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/20/24.
//

import Foundation
import JetEmailData

fileprivate enum GoogleMailFolderSystemName : String, CaseIterable, CodableValueType, Sendable {
    case inbox              = "INBOX"
    case starred            = "STARRED"
    case snoozed            = "SNOOZED"
    case important          = "IMPORTANT"
    case chat               = "CHAT"
    case sent               = "SENT"
    case scheduled          = "SCHEDULED"
    case draft              = "DRAFT"
    case all                = "ALL"
    case spam               = "SPAM"
    case trash              = "TRASH"
    case unread             = "UNREAD"
    
    case categorySocial     = "CATEGORY_SOCIAL"
    case categoryForums     = "CATEGORY_FORUMS"
    case categoryUpdates    = "CATEGORY_UPDATES"
    case categoryPromotions = "CATEGORY_PROMOTIONS"
    case categoryPersonal   = "CATEGORY_PERSONAL"
}

fileprivate extension GoogleMailFolderSystemName {
    var generalSystemName: MailFolderSystemName {
        switch self {
        case .inbox             : .inbox
        case .starred           : .starred
        case .snoozed           : .snoozed
        case .important         : .important
        case .chat              : .chat
        case .sent              : .sent
        case .scheduled         : .scheduled
        case .draft             : .drafts
        case .all               : .all
        case .spam              : .junk
        case .trash             : .trash
        case .unread            : .unread
        case .categorySocial    : .social
        case .categoryForums    : .forums
        case .categoryUpdates   : .updates
        case .categoryPromotions: .promotions
        case .categoryPersonal  : .personal
        }
    }
}


extension GoogleMailFolderInner {
    fileprivate var googleSystemName: GoogleMailFolderSystemName? {
        .init(rawValue: id)
    }
    
    fileprivate var isSystemFolder: Bool {
        guard let type = type else { return false }
        return type == .system
    }
    
    var systemName: MailFolderSystemName? {
        guard isSystemFolder else { return nil }
        guard let googleSystemName else { return nil }
        return googleSystemName.generalSystemName
    }
}

/*
public extension GoogleMailFolderSystemName {
    var systemOrder: Int {
        switch self {
        case .inbox             : 0
        case .starred           : 1
        case .snoozed           : 2 // ?
        case .important         : 3
        case .chat              : 4
        case .sent              : 5
        case .scheduled         : 6 // ?
        case .draft             : 7
        case .all               : 8 // All Mails
        case .spam              : 9
        case .trash             : 10
        case .unread            : 11 //?
            
        case .categorySocial    : 100
        case .categoryForums    : 101
        case .categoryUpdates   : 102
        case .categoryPromotions: 103
        case .categoryPersonal  : 104
        }
    }
        
    var nameLocalizedKey: String {
        switch self {
        case .inbox             : LocalizedStringResource("Google.MailFolder.INBOX"              ).key
        case .starred           : LocalizedStringResource("Google.MailFolder.STARRED"            ).key
        case .snoozed           : LocalizedStringResource("Google.MailFolder.SNOOZED"            ).key
        case .important         : LocalizedStringResource("Google.MailFolder.IMPORTANT"          ).key
        case .chat              : LocalizedStringResource("Google.MailFolder.CHAT"               ).key
        case .sent              : LocalizedStringResource("Google.MailFolder.SENT"               ).key
        case .scheduled         : LocalizedStringResource("Google.MailFolder.SCHEDULED"          ).key
        case .draft             : LocalizedStringResource("Google.MailFolder.DRAFT"              ).key
        case .all               : LocalizedStringResource("Google.MailFolder.ALL"                ).key
        case .spam              : LocalizedStringResource("Google.MailFolder.SPAM"               ).key
        case .trash             : LocalizedStringResource("Google.MailFolder.TRASH"              ).key
        case .unread            : LocalizedStringResource("Google.MailFolder.UNREAD"             ).key
            
        case .categoryPersonal  : LocalizedStringResource("Google.MailFolder.CATEGORY_PERSONAL"  ).key
        case .categorySocial    : LocalizedStringResource("Google.MailFolder.CATEGORY_SOCIAL"    ).key
        case .categoryPromotions: LocalizedStringResource("Google.MailFolder.CATEGORY_PROMOTIONS").key
        case .categoryUpdates   : LocalizedStringResource("Google.MailFolder.CATEGORY_UPDATES"   ).key
        case .categoryForums    : LocalizedStringResource("Google.MailFolder.CATEGORY_FORUMS"    ).key
        }
    }
    
    var systemImage: String {
        switch self {
        case .inbox             : "tray"
        case .starred           : "star"
        case .snoozed           : "clock"
        case .important         : "bookmark"
        case .chat              : "bubble"
        case .sent              : "paperplane"
        case .scheduled         : "clock"
        case .draft             : "doc"
        case .all               : "tree"
        case .spam              : "xmark.bin"
        case .trash             : "trash"
        case .unread            : "envelope.badge"
        case .categoryPersonal  : "person"
        case .categorySocial    : "person.2"
        case .categoryPromotions: "tag"
        case .categoryUpdates   : "info.circle"
        case .categoryForums    : "bubble.left.and.bubble.right"
        }
    }
}
*/
