//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/22/24.
//

import JetEmailData

// MARK: - AttributedStore for Microsoft Account

extension MicrosoftAccountID.AttributesStore {
    static var shared = AttributesStore()
}

@MainActor
extension MicrosoftAccountID {
    typealias AttributesStore = JetEmailData.AttributesStore<MicrosoftAccountID, Attributes>
    struct Attributes : AttributesProtocol {
        var _idToSystemName : [MicrosoftMailFolderID: _MicrosoftAPI.MicrosoftMailFolderSystemName]?
        var session : MicrosoftSession?
    }
    var _idToSystemName: [MicrosoftMailFolderID: _MicrosoftAPI.MicrosoftMailFolderSystemName]? {
        get { AttributesStore.shared[self]._idToSystemName }
        nonmutating set { AttributesStore.shared[self]._idToSystemName = newValue }
    }
    var session: MicrosoftSession? {
        get { AttributesStore.shared[self].session }
        nonmutating set { AttributesStore.shared[self].session = newValue }
    }
}

/*
 import struct Foundation.URL
 // MARK: - AttributedStore for Microsoft MailFolder

@MainActor
extension MicrosoftMailFolderID {
    typealias AttributesStore = JetEmailData.AttributesStore<MicrosoftMailFolderID, Attributes>
    struct Attributes : AttributesProtocol {
        var deltaLink : URL?
        public init() {}
    }
    var deltaLink: URL? {
        get { AttributesStore.shared[self].deltaLink }
        nonmutating set { AttributesStore.shared[self].deltaLink = newValue }
    }
}

extension MicrosoftMailFolderID.AttributesStore {
    static var shared = AttributesStore()
}*/

