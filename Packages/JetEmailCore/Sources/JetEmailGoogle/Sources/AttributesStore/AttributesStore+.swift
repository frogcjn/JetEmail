//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/24/24.
//

import JetEmailData

// MARK: - AttributedStore for Microsoft Account

extension GoogleAccountID.AttributesStore {
    static var shared = AttributesStore()
}

@MainActor
extension GoogleAccountID {
    typealias AttributesStore = JetEmailData.AttributesStore<GoogleAccountID, Attributes>
    struct Attributes : AttributesProtocol {
        var session : GoogleSession?
    }
    var session: GoogleSession? {
        get { AttributesStore.shared[self].session }
        nonmutating set { AttributesStore.shared[self].session = newValue }
    }
}

/*
// MARK: - Session Store

@MainActor
@Observable
class SessionStore {
    var rawValue = [GoogleAccountID: GoogleSession]()
    
    subscript(id: GoogleAccountID) -> GoogleSession? {
        get { rawValue[id] }
        set { rawValue[id] = newValue }
    }
    static let shared = SessionStore()
}
*/
