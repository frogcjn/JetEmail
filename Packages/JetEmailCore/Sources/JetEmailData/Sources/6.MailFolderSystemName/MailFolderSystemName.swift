//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/20/24.
//

import Foundation

public enum MailFolderSystemName : String, CaseIterable, CodableValueType, Sendable {
    
    case root
    case all
    
    case inbox
    case starred
    case snoozed
    case important
    case chat
    case sent  // microsoft: sentItems
    case scheduled
    case drafts // google: draft
    case junk  // microsoft: junkEmail
    case trash // microsoft: deletedItems
    case unread
    
    case social
    case forums
    case updates
    case promotions
    case personal
    
    case archive
    case clutter
    case conflicts
    case outbox
    case recoverableItemsDeletions
    case searchFolders
    
    case localFailures
    case serverFailures
    case syncIssues
    
}

extension MailFolderSystemName {
    var localized : String {
        .init(localized: .init(localizedKey), bundle: .module)
    }
}

public extension MailFolderSystemName {
    var systemOrder: Int {
        switch self {
        case .root                     : 0
        case .all                      : 1 // All Mails
            
        case .inbox                    : 10
        case .starred                  : 11
        case .important                : 12
        case .unread                   : 13 //?
        
        case .drafts                   : 20
        case .sent                     : 21
        case .outbox                   : 22
        case .snoozed                  : 23 // ?
        case .scheduled                : 24 // ?
            
        case .archive                  : 30
            
        case .trash                    : 40
        case .junk                     : 41

        case .chat                     : 50
        case .clutter                  : 51
    
        case .social                   : 100
        case .forums                   : 101
        case .updates                  : 102
        case .promotions               : 103
        case .personal                 : 104

        case .searchFolders            : 200
            
        case .recoverableItemsDeletions: 201
        case .conflicts                : 202
        case .localFailures            : 203
        case .serverFailures           : 204
        case .syncIssues               : 205
        }
    }
        
    var localizedKey: String {
        switch self {
        case .inbox                    : LocalizedStringResource("Inbox"                      ).key
        case .starred                  : LocalizedStringResource("Starred"                    ).key
        case .snoozed                  : LocalizedStringResource("Snoozed"                    ).key
        case .important                : LocalizedStringResource("Important"                  ).key
        case .chat                     : LocalizedStringResource("Chat"                       ).key
        case .sent                     : LocalizedStringResource("Sent"                       ).key
        case .scheduled                : LocalizedStringResource("Scheduled"                  ).key
        case .drafts                   : LocalizedStringResource("Drafts"                     ).key
        case .all                      : LocalizedStringResource("All"                        ).key
        case .trash                    : LocalizedStringResource("Trash"                      ).key
        case .unread                   : LocalizedStringResource("Unread"                     ).key
        case .personal                 : LocalizedStringResource("Personal"                   ).key
        case .social                   : LocalizedStringResource("Social"                     ).key
        case .promotions               : LocalizedStringResource("Promotions"                 ).key
        case .updates                  : LocalizedStringResource("Updates"                    ).key
        case .forums                   : LocalizedStringResource("Forums"                     ).key
        case .archive                  : LocalizedStringResource("Archive"                    ).key
        case .clutter                  : LocalizedStringResource("Clutter"                    ).key
        case .conflicts                : LocalizedStringResource("Conflicts"                  ).key
        case .junk                     : LocalizedStringResource("Junk"                       ).key
        case .localFailures            : LocalizedStringResource("Local Failures"             ).key
        case .root                     : LocalizedStringResource("Root"                       ).key
        case .outbox                   : LocalizedStringResource("Outbox"                     ).key
        case .recoverableItemsDeletions: LocalizedStringResource("Recoverable Items Deletions").key
        case .searchFolders            : LocalizedStringResource("Search Folders"             ).key
        case .serverFailures           : LocalizedStringResource("Server Failures"            ).key
        case .syncIssues               : LocalizedStringResource("Sync Issues"                ).key
        }
    }
    
    var systemImage: String {
        switch self {
        case .inbox                    : "tray"
        case .starred                  : "star"
        case .important                : "bookmark"
        case .chat                     : "bubble"
        case .sent                     : "paperplane"
        case .snoozed                  : "clock"
        case .scheduled                : "clock"
        case .drafts                   : "doc"
        case .all                      : "mail.stack"
        case .root                     : "tree"
        case .junk                     : "xmark.bin"
        case .trash                    : "trash"
        case .unread                   : "envelope.badge"
        case .personal                 : "person"
        case .social                   : "person.2"
        case .promotions               : "tag"
        case .updates                  : "info.circle"
        case .forums                   : "bubble.left.and.bubble.right"
        case .archive                  : "archivebox"
        case .clutter                  : "shippingbox"
        case .conflicts                : "bolt.trianglebadge.exclamationmark"
        case .localFailures            : "exclamationmark.triangle"
        case .outbox                   : "tray.and.arrow.up"
        case .recoverableItemsDeletions: "arrow.triangle.2.circlepath"
        case .searchFolders            : "magnifyingglass"
        case .serverFailures           : "server.rack"
        case .syncIssues               : "exclamationmark.arrow.triangle.2.circlepath"
        }
    }
}
