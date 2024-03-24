//
//  File 2.swift
//  
//
//  Created by Cao, Jiannan on 3/20/24.
//

import MSAL
import JetEmailData

fileprivate extension MicrosoftClient {
    
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
            if let session = sessionStore[accountID] {
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
        sessionStore[session.account.id] = session
        return session
    }
    
    @MainActor
    func _refreshSession(accountID: MicrosoftAccountID) async throws -> MicrosoftSession {
        if let session = sessionStore[accountID] {
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



// MARK: - Client API

@MainActor
extension MicrosoftClient : ClientProtocol {
    public var sessions: [MicrosoftSession] { get async throws {
        try await _sessions()
    } }

    @MainActor
    public func signIn() async throws -> MicrosoftSession {
        try await _signIn()
    }
}

// MARK: - Session API

extension MicrosoftSession : SessionProtocol {
    public typealias     ClientType = MicrosoftClient
    public typealias  AccountIDType = MicrosoftAccountID
    public typealias    AccountType = MicrosoftAccount
    public typealias MailFolderType = MicrosoftMailFolder
    public typealias    MessageType = MicrosoftMessage
    
    /*@MainActor // for SessionStore
    static public func sessions(client: MicrosoftClient) async throws -> [MicrosoftSession] { // the sessions should be refresh before using to fetch
        try await client.sessions()
    }

    
    @MainActor
    static public func signIn(client: MicrosoftClient) async throws -> MicrosoftSession {
        try await client.signIn()
    }
    
    @MainActor
    public func signOut() async throws -> MicrosoftSession {
        try await client.signOut(session: self)
    }*/
    
    public var refresh: MicrosoftSession { get async throws {
        try await client._refresh(session: self)
    } }
    
    @MainActor
    public func signOut() async throws -> MicrosoftSession {
        try await client._signOut(session: self)
    }
}

public extension MicrosoftSession {
    private var _authorizationHeader: String {
        _item.msalSession.authorizationHeader
    }
    
    var refreshAuthorizationHeader: String { get async throws {
        try await refresh._authorizationHeader
    } }
}

// MARK: - AccountID API

@MainActor
extension MicrosoftAccountID  : AccountToSessionProtocol {
    public var storedSession: MicrosoftSession? {
        SessionStore.shared[self]
    }
    
    public var refreshSession: MicrosoftSession { get async throws  {
        try await MicrosoftClient.shared._refreshSession(accountID: self)
    } }
    
    public func removeSession() -> MicrosoftSession? {
        let session = SessionStore.shared[self]
        SessionStore.shared[self] = nil
        return session
    }
}

// used for checking status
/*
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
*/

// MARK: - Session Store

@MainActor
@Observable
class SessionStore {
    var rawValue = [MicrosoftAccountID: MicrosoftSession]()
    
    subscript(id: MicrosoftAccountID) -> MicrosoftSession? {
        get { rawValue[id] }
        set { rawValue[id] = newValue }
    }
    
    static var shared = SessionStore()
}
