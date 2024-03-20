//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

@preconcurrency import MSAL
import JetEmailData

// MARK: - SessionProtocol

extension MicrosoftSession : SessionProtocol {
    
    public func signOut() async throws -> MicrosoftSession {
        _ = try await MicrosoftClient.shared._msalSignout(msalAccount: _msalSession.account)
        _ = await account.id.removeSession()
        return self
    }
    
    public var refresh: MicrosoftSession { get async throws {
        if !_isExpired { return self }
        return try await SessionStore.shared.session(id: account.id, forceRefresh: true)
    } }
    
    fileprivate var _isExpired: Bool {
       guard let expiresOn = _msalSession.expiresOn else { return false }
       return Date.now >= expiresOn
   }
    
}

// MARK: - Authorization Header

public extension MicrosoftSession {
    var authorizationHeader: String { get async throws {
        try await refresh._msalSession.authorizationHeader
    } }
}
