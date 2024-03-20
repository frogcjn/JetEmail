//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/20/24.
//

// MARK: - AccountSessionAPI
// used for checking status

import JetEmailData

@MainActor
extension MicrosoftAccountID : AccountSessionAPI {
    public var storedSession: MicrosoftSession? { SessionStore.shared[self] }
    public var refreshSession: MicrosoftSession? { get async throws {
        let session = try await SessionStore.shared.session(id: self, forceRefresh: false)
        return try await session.refresh
    } }
    public func removeSession() -> MicrosoftSession? { SessionStore.shared.remove(id: self) }
}
