//
//  File.swift
//  
//

import JetEmailID
import JetEmailData

@MainActor
extension AccountID {
    public var refreshSession: Session? { get async throws {
        try await platformCase?.refreshSession
    } }
}

@MainActor
extension Account {
    public var refreshSession: Session? { get async throws {
        try await resourceID.refreshSession
    } }
}
