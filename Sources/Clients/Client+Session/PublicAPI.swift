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
import JetEmail_ID

@MainActor
extension AccountID {
    
    var storedSession: JetEmail_Data.Session? {
        switch platformCase {
        case .microsoft(let id): id.storedSession.map(Session.microsoft)
        case    .google(let id): id.storedSession.map(Session.google   )
        default: nil
        }
    }
    
    var sessionState: SessionState {
        storedSession != nil ? .hasSession : .noSession
    }
    
    var refreshSession: JetEmail_Data.Session? { get async throws {
        switch platformCase {
        case .microsoft(let id): try await JetEmail_Data.Session.microsoft(id.refreshMicrosoftSession)
        case    .google(let id): try await id.refreshGoogleSession.map(JetEmail_Data.Session.google)
        default: nil
        }
    } }
    
    func removeSession() -> JetEmail_Data.Session? {
        switch platformCase {
        case .microsoft(let id): id.removeSession().map(JetEmail_Data.Session.microsoft)
        case    .google(let id): id.removeSession().map(JetEmail_Data.Session.google)
        default: nil
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
