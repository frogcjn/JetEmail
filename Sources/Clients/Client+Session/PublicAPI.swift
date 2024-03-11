//
//  Microsoft+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/22/24.
//

import Foundation
import JetEmailGoogle
import JetEmailMicrosoft
import JetEmailData
import JetEmailID

@MainActor
extension AccountID {
    
    var storedSession: Session? {
        switch platformCase {
        case .microsoft(let id): id.storedSession.map(Session.microsoft)
        case    .google(let id): id.storedSession.map(Session.google   )
        default: nil
        }
    }
    
    var sessionState: SessionState {
        storedSession != nil ? .hasSession : .noSession
    }
    
    var refreshSession: Session? { get async throws {
        switch platformCase {
        case .microsoft(let id): try await Session.microsoft(id.refreshMicrosoftSession)
        case    .google(let id): try await id.refreshGoogleSession.map(Session.google)
        default: nil
        }
    } }
    
    func removeSession() -> Session? {
        switch platformCase {
        case .microsoft(let id): id.removeSession().map(Session.microsoft)
        case    .google(let id): id.removeSession().map(Session.google)
        default: nil
        }
    }
}


extension Session {
    var refresh: Session { get async throws {
        switch self {
        case .microsoft(let session): return .microsoft(try await session.refresh)
        case .google   (let session): return .google(try await session.refresh)
        }
    } }
}
