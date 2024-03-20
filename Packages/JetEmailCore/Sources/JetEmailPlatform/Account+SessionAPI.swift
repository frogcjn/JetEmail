//
//  File.swift
//  
//

import JetEmailData
import JetEmailData

@MainActor
extension AccountID : AccountSessionAPI {
    public var storedSession: Session? {
        platformCase?.storedSession
    }
    
    public func removeSession() -> Session? {
        platformCase?.removeSession()
    }
    
    public var refreshSession: Session? { get async throws {
        try await platformCase?.refreshSession
    } }
}

@MainActor
extension Account : AccountSessionAPI {
    public var storedSession: Session? {
        resourceID.platformCase?.storedSession
    }
    
    public func removeSession() -> Session? {
        resourceID.platformCase?.removeSession()
    }
    
    public var refreshSession: Session? { get async throws {
        try await resourceID.platformCase?.refreshSession
    } }
}
