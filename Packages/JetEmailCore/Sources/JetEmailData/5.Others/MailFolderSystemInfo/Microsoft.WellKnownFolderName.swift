//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/20/24.
//

import Foundation

public enum MicrosoftMailFolderSystemName : String, CaseIterable, CodableValueType, Sendable {
    case msgFolderRoot             = "msgfolderroot"
    case archive
    case clutter
    case conflicts
    case conversationHistory       = "conversationhistory"
    case deletedItems              = "deleteditems"
    case drafts
    case inbox
    case junkEmail                 = "junkemail"
    case localFailures             = "localfailures"
    case outbox
    case recoverableItemsDeletions = "recoverableitemsdeletions"
    case scheduled
    case searchFolders             = "searchfolders"
    case sentItems                 = "sentitems"
    case serverFailures            = "serverfailures"
    case syncIssues                = "syncissues"
}

public extension MicrosoftMailFolderSystemName {
    var systemInfo: MailFolderSystemInfo? {
        .init(systemOrder: systemOrder, nameLocalizedKey: nameLocalizedKey, systemImage: systemImage)
    }
}

public extension MicrosoftMailFolderSystemName {
    var systemOrder: Int? {
        switch self {
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
        
    var nameLocalizedKey: String? {
        switch self {
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
    
    var systemImage: String? {
        switch self {
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
