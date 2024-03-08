//
//  Microsoft+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/22/24.
//

import Foundation
import Google
import Microsoft
import JetEmail_Data

@MainActor
extension JetEmail_Data.Account.ID {
    
    var storedSession: JetEmail_Data.Session? {
        get {
            switch self {
            case .microsoft(let id): Microsoft.SessionStore.shared[id].map(Session.microsoft)
            case .google(let id):       Google.SessionStore.shared[id].map(Session.google)
            }
        }
        nonmutating set {
            switch self {
            case .microsoft(let id): Microsoft.SessionStore.shared[id] = newValue?.microsoft
            case .google   (let id):    Google.SessionStore.shared[id] = newValue?.google
            }
        }
    }
    
    var refreshSession: JetEmail_Data.Session? { get async throws {
        switch self {
        case .microsoft(let id): return .microsoft(try await id.sessionRefreshIfExpired)
        default: ()
        }
        if let storedSession {
            switch storedSession {
            case .microsoft: fatalError()
            case .google(let googleSession):
                try await googleSession.refresh()
                return .google(googleSession)
            }
        } else {
            switch self {
            case .microsoft: fatalError()
            case .google(let id): return try await (Google.Keychain.shared.item(id: id)?.lazySession).map(Session.google)
            }
        }
    } }
}


