//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

import JetEmail_Foundation

// MARK: - WellKnownFolderName
// Well-known folder names https://learn.microsoft.com/en-us/graph/api/resources/mailfolder?view=graph-rest-1.0#methods
public extension MailFolder {
    
    enum WellKnownFolderName : String, CaseIterable, CodableValueType {
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
    
    /*
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
     Contacts    1
     The Contacts folder.
     ConversationHistory    33
     The Conversation History folder. The ConversationHistory field is applicable for clients that target Exchange Online and versions of Exchange starting with Exchange Server 2013.
     DeletedItems    2
     The Deleted Items folder.
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
