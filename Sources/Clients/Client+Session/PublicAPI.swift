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
        switch self {
        case .microsoft(let id): id.storedSession.map(Session.microsoft)
        case .google   (let id): id.storedSession.map(Session.google)
        }
    }
    
    var sessionState: SessionState {
        storedSession != nil ? .hasSession : .noSession
    }
    
    var refreshSession: JetEmail_Data.Session? { get async throws {
        switch self {
        case .microsoft(let id): return .microsoft(try await id.refreshSession)
        case .google   (let id): return try await id.refreshSession.map(Session.google)
        }
    } }
    
    func removeSession() -> JetEmail_Data.Session? {
        switch self {
        case .microsoft(let id): id.removeSession().map(Session.microsoft)
        case .google   (let id): id.removeSession().map(Session.google)
        }
    }
}


extension JetEmail_Data.Session {
    var refresh: JetEmail_Data.Session { get async throws {
        switch self {
        case .microsoft(let session): return .microsoft(try await session.refresh)
        case .google   (let session): return .google(try await session.refresh)
        }
    } }
}
