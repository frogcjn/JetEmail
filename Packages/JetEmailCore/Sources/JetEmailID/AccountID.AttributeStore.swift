//
//  Account.AttributeStore.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import JetEmailFoundation

public enum MicrosoftWellKnownFolderName : String, CaseIterable, CodableValueType, Sendable {
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

@MainActor
public extension AccountID {
    typealias AttributesStore = JetEmailID.AttributesStore<AccountID, Attributes>
    struct Attributes : AttributesProtocol {
        public var isBusy = false
        public var idToWellKnownFolderName : [MailFolderID: MicrosoftWellKnownFolderName]?
        public var loadedMailFolder = false
        public init() {}
    }
}

extension AccountID.AttributesStore {
    static var shared = AttributesStore()
}


@MainActor
public extension AccountID {
    var isBusy: Bool {
        get { AccountID.AttributesStore.shared[self].isBusy }
        nonmutating set { AccountID.AttributesStore.shared[self].isBusy = newValue }
    }
    
    var idToWellKnownFolderName: [MailFolderID: MicrosoftWellKnownFolderName]? {
        get { AccountID.AttributesStore.shared[self].idToWellKnownFolderName }
        nonmutating set { AccountID.AttributesStore.shared[self].idToWellKnownFolderName = newValue }
    }
    
    var loadedMailFolder: Bool {
        get { AccountID.AttributesStore.shared[self].loadedMailFolder }
        nonmutating set {AccountID.AttributesStore.shared[self].loadedMailFolder = newValue }
    }
}
