//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/20/24.
//

import typealias JetEmailFoundation.CodableValueType
import JetEmailData

// MARK: - WellKnownFolderName

// Well-known folder names https://learn.microsoft.com/en-us/graph/api/resources/mailfolder
extension _MicrosoftAPI {
    enum MicrosoftMailFolderSystemName : String, CaseIterable, CodableValueType, Sendable {
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
}

extension _MicrosoftAPI.MicrosoftMailFolderSystemName {
    var systemName: MailFolderSystemName {
        switch self {
        case .msgFolderRoot:             .root
        case .archive:                   .archive
        case .clutter:                   .clutter
        case .conflicts:                 .conflicts
        case .conversationHistory:       .chat
        case .deletedItems:              .trash
        case .drafts:                    .drafts
        case .inbox:                     .inbox
        case .junkEmail:                 .junk
        case .outbox:                    .outbox
        case .recoverableItemsDeletions: .recoverableItemsDeletions
        case .scheduled:                 .scheduled
        case .searchFolders:             .searchFolders
        case .sentItems:                 .sent
        case .localFailures:             .localFailures
        case .serverFailures:            .serverFailures
        case .syncIssues:                .syncIssues
        }
    }
}

/*
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



/*
//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/8/24.
//

import JetEmailData


public extension MicrosoftMailFolder {
    

    
    /*
     Contacts 1 The Contacts folder.
     DeletedItems 2 The Deleted Items folder.
     ArchiveDeletedItems    22 The Deleted Items folder in the archive mailbox.
     ArchiveMsgFolderRoot    21 The root of the message folder hierarchy in the archive mailbox.
     ArchiveRecoverableItemsDeletions    24
     The root of the folder hierarchy of recoverable items that have been soft-deleted from the Deleted Items folder of the archive mailbox.
     ArchiveRecoverableItemsPurges    26
     The root of the hierarchy of recoverable items that have been hard-deleted from the Deleted Items folder of the archive mailbox.
     ArchiveRecoverableItemsRoot    23
     The root of the Recoverable Items folder hierarchy in the archive mailbox.
     ArchiveRecoverableItemsVersions    25
     The root of the Recoverable Items versions folder hierarchy in the archive mailbox.
     ArchiveRoot    20
     The root of the folder hierarchy in the archive mailbox.
     Calendar    0
     The Calendar folder.
     Conflicts    28
     The Conflicts folder. The Conflicts field is applicable for clients that target Exchange Online and versions of Exchange starting with Exchange Server 2013.

     ConversationHistory    33
     The Conversation History folder. The ConversationHistory field is applicable for clients that target Exchange Online and versions of Exchange starting with Exchange Server 2013.

     Drafts    3
     The Drafts folder.
     Inbox    4
     The Inbox folder.
     Journal    5
     The Journal folder.
     JunkEmail    13
     The Junk E-mail folder.
     LocalFailures    29
     The Local Failures folder. The LocalFailures field is applicable for clients that target Exchange Online and versions of Exchange starting with Exchange Server 2013.
     MsgFolderRoot    10
     The root of the message folder hierarchy.
     Notes    6
     The Notes folder.
     Outbox    7
     The Outbox folder.
     PublicFoldersRoot    11
     The root of the Public Folders hierarchy.
     QuickContacts    32
     The Quick Contacts folder. The QuickContacts field is applicable for clients that target Exchange Online and versions of Exchange starting with Exchange Server 2013.
     RecipientCache    31
     The Recipient Cache folder. The RecipientCache field is applicable for clients that target Exchange Online and versions of Exchange starting with Exchange Server 2013.
     RecoverableItemsDeletions    17
     The root of the folder hierarchy of recoverable items that have been soft-deleted from the Deleted Items folder.
     RecoverableItemsPurges    19
     The root of the folder hierarchy of recoverable items that have been hard-deleted from the Deleted Items folder.
     RecoverableItemsRoot    16
     The root of the Recoverable Items folder hierarchy.
     RecoverableItemsVersions    18
     The root of the Recoverable Items versions folder hierarchy in the archive mailbox.
     Root    12
     The root of the mailbox.
     SearchFolders    14
     The Search Folders folder, also known as the Finder folder.
     SentItems    8
     The Sent Items folder.
     ServerFailures    30
     The Server Failures folder. The ServerFailures field is applicable for clients that target Exchange Online and versions of Exchange starting with Exchange Server 2013.
     SyncIssues    27
     The Sync Issues folder. The SyncIssues field is applicable for clients that target Exchange Online and versions of Exchange starting with Exchange Server 2013.
     Tasks    9
     The Tasks folder.
     ToDoSearch    34
     The To Do Search folder. The ToDoSearch field is applicable for clients that target Exchange Online and versions of Exchange starting with Exchange Server 2013.
     VoiceMail    15
     The Voicemail folder.
     */
}
*/
*/
