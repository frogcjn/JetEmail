//
//  File.swift
//  
//

import JetEmailData

@MainActor
extension PlatformEnum<MicrosoftAccountID, GoogleAccountID> {
    public var storedSession: Session? {
        return Session.storedSession(accountID: self)
    }
    
    public func removeSession()-> Session? {
        return Session.removeSession(accountID: self)
    }
    
    public var refreshSession: Session? { get async throws {
        return try await Session.refreshSession(accountID: self)
    } }
}

@MainActor
extension AccountID {
    public var storedSession: Session? {
        platformCase?.storedSession
    }
    
    public func removeSession()-> Session? {
        platformCase?.removeSession()
    }
    
    public var refreshSession: Session? { get async throws {
        try await platformCase?.refreshSession
    } }
}



@MainActor
extension Account {
    public var storedSession: Session? {
        resourceID.storedSession
    }
    
    public func removeSession() -> Session? {
        resourceID.removeSession()
    }
    
    public var refreshSession: Session? { get async throws {
        try await resourceID.refreshSession
    } }
}
