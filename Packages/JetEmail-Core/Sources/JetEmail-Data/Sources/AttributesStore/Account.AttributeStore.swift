//
//  Account.AttributeStore.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import JetEmail_Foundation
import Microsoft

@MainActor
public extension Account {
    typealias AttributesStore = JetEmail_Data.AttributesStore<Account.ID, Account.Attributes>
    struct Attributes : AttributesProtocol {
        public var isBusy = false
        public var idToWellKnownFolderName : [MicrosoftMailFolderID: MicrosoftMailFolder.WellKnownFolderName]?
        public var loadedMailFolder = false
        public init() {}
    }
}

@MainActor
public extension Account {
    var isBusy: Bool {
        get { id.isBusy }
        set { id.isBusy = newValue }
    }
    
    var idToWellKnownFolderName: [MicrosoftMailFolderID: MicrosoftMailFolder.WellKnownFolderName]? {
        get { id.idToWellKnownFolderName }
        set { id.idToWellKnownFolderName = newValue }
    }
    
    var loadedMailFolder: Bool {
        get { id.loadedMailFolder }
        set { id.loadedMailFolder = newValue }
    }
}

@MainActor
public extension Account.ID {
    var isBusy: Bool {
        get { AttributesStore.shared[self].isBusy }
        nonmutating set { AttributesStore.shared[self].isBusy = newValue }
    }
    
    var idToWellKnownFolderName: [MicrosoftMailFolderID: MicrosoftMailFolder.WellKnownFolderName]? {
        get { AttributesStore.shared[self].idToWellKnownFolderName }
        nonmutating set { AttributesStore.shared[self].idToWellKnownFolderName = newValue }
    }
    
    var loadedMailFolder: Bool {
        get { AttributesStore.shared[self].loadedMailFolder }
        nonmutating set { AttributesStore.shared[self].loadedMailFolder = newValue }
    }
}
