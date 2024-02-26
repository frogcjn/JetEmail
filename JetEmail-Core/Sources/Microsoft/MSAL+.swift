//
//  MSAL+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/20/24.
//

import MSAL

    public typealias MSALAccount = MSAL.MSALAccount
    public typealias MSALSession = MSAL.MSALResult

public extension Client {
    var _msalAccounts: [Microsoft.MSALAccount] { get throws {
        try _msalClient.allAccounts()
    } }
    
    /*var _msalSessions: [Microsoft.MSALSession] { get async throws {
        try await _msalAccounts.asyncMap{ try await $0.lazyMSALSession }
    } }*/
    
    func _msalSignIn() async throws -> Microsoft.MSALSession {
        return try await _msalClient.acquireToken(with: {
            let parameters = MSALInteractiveTokenParameters(scopes: scopes.map(\.rawValue), webviewParameters: webViewParameters)
            parameters.promptType = .selectAccount
            return parameters
        }())
    }
    
    /*func refreshedSession(msalAccount: Microsoft.MSALAccount) async throws -> Microsoft.Session {
        if let session = try Microsoft.Session[msalAccount] { return session }
        return try await _msalRefreshSession(msalAccount: msalAccount).session
    }*/
    
    func _msalRefreshSession(id: Microsoft.ID) async throws -> Microsoft.MSALSession {
        try await _msalClient.account(forIdentifier: id.string)._msalRefreshMSALSession
    }

    /*func _msalRefreshSession(msalAccount: MSALAccount) async throws -> Microsoft.MSALSession {
        let parameters = MSALSilentTokenParameters(scopes: scopes.map(\.rawValue), account: msalAccount)
        return try await _msalClient.acquireTokenSilent(with: parameters)
        /*
         if let error = error as? MSALSilentTokenAcquisitionError, error == .interactionRequired {
                         self.acquireTokenInteractively()
                     } else if let result = result {
                         // Use the access token from result.accessToken
                     } else {
                         print("Unhandled error: \(error?.localizedDescription ?? "Unknown error")")
                     }
         */
    }*/
    
    func _msalSignout(msalAccount: MSALAccount) async throws -> Bool {
        let parameters = MSALSignoutParameters(webviewParameters: webViewParameters)
        let result = try await _msalClient.signout(with: msalAccount, signoutParameters: parameters)
        return result
    }
}

public extension MSALAccount {
    // force refresh
    var _msalRefreshMSALSession: Microsoft.MSALSession {
        get async throws {
            let client = try await Microsoft.Client.shared
            let parameters = MSALSilentTokenParameters(scopes: client.scopes.map(\.rawValue), account: self)
            return try await client._msalClient.acquireTokenSilent(with: parameters)
        }
    }
}

@Observable
public class SessionStore {
    public static let shared = SessionStore()
    var rawValue = [Microsoft.ID: Microsoft.Session]()
    
    public static subscript(id: Microsoft.ID) -> Microsoft.Session? {
        get { shared.rawValue[id] }
        set { shared.rawValue[id] = newValue }
    }
}


public extension Session {
    static subscript(id: Microsoft.ID) -> Microsoft.Session? {
        get {
            guard let session = SessionStore[id] else { return nil }
            return session
        }
        set { SessionStore[id] = newValue }
    }
}

// MARK: - Session Lazy & Refresh

public extension MSALAccount {
    var lazySession: Microsoft.Session { get async throws {
        if let session = try Microsoft.Session[id] { session }
        else { try await refreshSession }
    } }
    
    var refreshSession: Microsoft.Session { get async throws {
        let (id, username) = try idAndUsername
        let session = Microsoft.Session(accountID: id, username: username, msalSession: try await _msalRefreshMSALSession)
        Microsoft.Session[id]  = session
        return session
    } }
}

public extension MSALSession {
    var lazySession: Microsoft.Session { get throws {
        if let session = try Microsoft.Session[account.id] { session }
        else { try newSession }
    } }
    
    var newSession: Microsoft.Session {
        get throws {
            let (id, username) = try account.idAndUsername
            let session = Microsoft.Session(accountID: id, username: username, msalSession: self)
            Microsoft.Session[id]  = session
            return session
        }
    }
    
    /*var lazyReplacementSession: Microsoft.Session { get throws {
        if let session = try Microsoft.Session[account] {
            session._msalSession = self
            return session
        }
        return try newSession
    } }*/
}

// Microsoft.Session + refreshed

public extension Session {
    
    private var isExpired: Bool {
        guard let expiresOn = _msalSession.expiresOn else { return false }
        return Date.now >= expiresOn
    }
    
    var refreshIfExpired: Microsoft.Session {
        get async throws {
            if !isExpired { return self }
            return try await _msalSession.account.refreshSession
            //_msalSession = try await _msalSession.refresh
            // may need interaction
            //return self
        }
    }
    
    var authorizationHeader: String { get async throws {
        try await refreshIfExpired._msalSession.authorizationHeader
    } }
    
    /*func refreshAccount(_ account: Microsoft.Account) async throws -> Microsoft.Session {
        try await sessionStore.refreshSession(account)
    }*/
    
}
