//
//  MSAL+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/20/24.
//

import MSAL

extension Microsoft {
    typealias MSALAccount = MSAL.MSALAccount
    typealias MSALSession = MSAL.MSALResult
}

extension Microsoft.Client {
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

extension Microsoft.MSALAccount {
    // force refresh
    var _msalRefreshMSALSession: Microsoft.MSALSession {
        get async throws {
            let client = try await Microsoft.Client.shared
            let parameters = MSALSilentTokenParameters(scopes: client.scopes.map(\.rawValue), account: self)
            return try await client._msalClient.acquireTokenSilent(with: parameters)
        }
    }
}
