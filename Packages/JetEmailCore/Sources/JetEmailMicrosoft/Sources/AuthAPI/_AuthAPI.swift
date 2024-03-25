//
//  File 2.swift
//  
//
//  Created by Cao, Jiannan on 3/20/24.
//

import MSAL
import   func JetEmailFoundation.checkBackgroundThread
import struct JetEmailFoundation.SignInPresentationAnchor
import JetEmailData

extension MicrosoftClient {
    
    var msalClient: MSALClient { get throws {
        checkBackgroundThread()
        
        if let _msalClient { return _msalClient }
        
        let configuration = MSALPublicClientApplicationConfig(
            clientId: clientID,
            redirectUri: redirectURL.absoluteString,
            authority: try MSALAADAuthority(url: authorityURL)
        )
        
        let msalClient = try MSALClient(configuration: configuration)
        _msalClient = msalClient
        return msalClient
    } }
    
    @MainActor
    func _sessions() async throws -> [MicrosoftSession] {
        try await msalClient.allAccounts().asyncMap { @MainActor msalAccount in
            let accountID = try msalAccount.id
            if let session = accountID.session {
                return try await _refresh(session: session)
            }
            return try await _fetchAndRefresh(accountID: accountID)
        }
    }
    
    @MainActor // for webViewParameters
    func _signIn() async throws -> MicrosoftSession {
        let parameters = try MSALInteractiveTokenParameters(scopes: scopes.map(\.rawValue), webviewParameters: SignInPresentationAnchor.sharedWebviewParameters)
        parameters.promptType = .selectAccount
        let sessionItem = try await msalClient.acquireToken(with: parameters).item
        return try await _insertSession(item: sessionItem)
    }
    
    @MainActor // for webViewParameters
    func _signOut(session: MicrosoftSession) async throws -> MicrosoftSession {
        let msalAccount = session._item.msalSession.account
        do {
            let parameters = try MSALSignoutParameters(webviewParameters: SignInPresentationAnchor.sharedWebviewParameters)
            _ = try await msalClient.signout(with: msalAccount, signoutParameters: parameters)
        } catch {
            try await msalClient.remove(msalAccount)
            _ = true
        }
        _ = session.account.id.removeSession()
        return session
    }
    
    @MainActor
    func _fetchAndRefresh(accountID: MicrosoftAccountID) async throws -> MicrosoftSession {
        let msalAccount = try await msalClient.account(forIdentifier: accountID.innerID)
        let parameters = MSALSilentTokenParameters(scopes: scopes.map(\.rawValue), account: msalAccount)
        let sessionItem = try await msalClient.acquireTokenSilent(with: parameters).item
        return try await _insertSession(item: sessionItem)
    }
    
    
    @MainActor // if isExpired, replace the session
    func _refresh(session: MicrosoftSession) async throws -> MicrosoftSession {
        guard await session._isExpired else { return session }
        let parameters = MSALSilentTokenParameters(scopes: scopes.map(\.rawValue), account: session._item.msalSession.account)
        let sessionItem = try await msalClient.acquireTokenSilent(with: parameters).item
        return try await _insertSession(item: sessionItem)
    }
    
    // MARK: - SessionStore

    @MainActor
    func _insertSession(item: MicrosoftSession.Item) async throws -> MicrosoftSession {
        let session = MicrosoftSession(client: self, item: item)
        session.account.id.session = session
        return session
    }
    
    @MainActor
    func _refreshSession(accountID: MicrosoftAccountID) async throws -> MicrosoftSession {
        if let session = accountID.session {
            return try await _refresh(session: session)
        } else {
            return try await _fetchAndRefresh(accountID: accountID)
        }
    }
}

fileprivate extension MicrosoftSession {
    var _isExpired: Bool {
        guard let expiresOn = _item.msalSession.expiresOn else { return false }
        return Date.now >= expiresOn
    }
}

fileprivate extension SignInPresentationAnchor {
    static var sharedWebviewParameters: MSALWebviewParameters { get throws {
        return .init(authPresentationViewController: try sharedKeyViewController)
    } }
    
    /*var webviewParameters: MSALWebviewParameters{ get throws {
        return .init(authPresentationViewController: try presentationViewController)
    } }*/
}
