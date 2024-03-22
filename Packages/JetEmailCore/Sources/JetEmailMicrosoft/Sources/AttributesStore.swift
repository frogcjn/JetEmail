//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/22/24.
//

import JetEmailData
import struct Foundation.URL

@MainActor
extension MicrosoftAccountID {
    typealias AttributesStore = JetEmailData.AttributesStore<MicrosoftAccountID, Attributes>
    struct Attributes : AttributesProtocol {
        var idToWellKnownFolderName : [MicrosoftMailFolderID: MicrosoftMailFolderSystemName]?
        public init() {}
    }
    var idToWellKnownFolderName: [MicrosoftMailFolderID: MicrosoftMailFolderSystemName]? {
        get { AttributesStore.shared[self].idToWellKnownFolderName }
        nonmutating set { AttributesStore.shared[self].idToWellKnownFolderName = newValue }
    }
}


extension MicrosoftAccountID.AttributesStore {
    static var shared = AttributesStore()
}

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
}
