//
//  Account.AttributeStore.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import JetEmailFoundation
import JetEmailID
import JetEmailMicrosoft

@MainActor
public extension Account {
    typealias AttributesStore = JetEmailData.AttributesStore<Account, String, Attributes>
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
        get { resourceID.isBusy }
        set { resourceID.isBusy = newValue }
    }
    
    var idToWellKnownFolderName: [MicrosoftMailFolderID: MicrosoftMailFolder.WellKnownFolderName]? {
        get { resourceID.idToWellKnownFolderName }
        set { resourceID.idToWellKnownFolderName = newValue }
    }
    
    var loadedMailFolder: Bool {
        get { resourceID.loadedMailFolder }
        set { resourceID.loadedMailFolder = newValue }
    }
}

@MainActor
public extension Account.ResourceID {
    var isBusy: Bool {
        get { Account.AttributesStore.shared[uniqueID].isBusy }
        nonmutating set { Account.AttributesStore.shared[uniqueID].isBusy = newValue }
    }
    
    var idToWellKnownFolderName: [MicrosoftMailFolderID: MicrosoftMailFolder.WellKnownFolderName]? {
        get { Account.AttributesStore.shared[uniqueID].idToWellKnownFolderName }
        nonmutating set { Account.AttributesStore.shared[uniqueID].idToWellKnownFolderName = newValue }
    }
    
    var loadedMailFolder: Bool {
        get { Account.AttributesStore.shared[uniqueID].loadedMailFolder }
        nonmutating set {Account.AttributesStore.shared[uniqueID].loadedMailFolder = newValue }
    }
}
