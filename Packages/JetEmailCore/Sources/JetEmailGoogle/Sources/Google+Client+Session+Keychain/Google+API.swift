//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/20/24.
//

import JetEmailData
import GTMAppAuth
import AppAuth

extension GoogleClient {
    
    @MainActor
    func _sessions() async throws -> [GoogleSession] {
        try await keychain.items.asyncMap { @MainActor sessionItem in
            let accountID = sessionItem.account.id
            let session = accountID.storedSession ?? _insertSession(item: sessionItem)
            return try await _refresh(session: session)
        }
    }
    
    @MainActor  // for SignInPresentationAnchor
    fileprivate func _signIn() async throws -> GoogleSession {
        MainActor.assertIsolated()
        
        let additionalParameters: [String: String] = [
            kIncludeGrantedScopesParameter: "true"
        ]
        // additionalParameters[         kLoginHintParameter "login_hint"] = options.loginHint;
        // additionalParameters[          kAudienceParameter "audience"  ] = options.configuration.serverClientID;
        // additionalParameters[ kSDKVersionLoggingParameter "gpsdk"     ] = GIDVersion();
        // additionalParameters[kEnvironmentLoggingParameter "gidenv"    ] = GIDEnvironment();
        // additionalParameters[      kHostedDomainParameter "hd"        ] = options.configuration.hostedDomain;
        
        let request = OIDAuthorizationRequest(
            configuration: configuration,
            clientId: clientID,
            clientSecret: nil,
            scopes: scopes.map(\.rawValue),
            redirectURL: redirectURL,
            responseType: responseType.rawValue,
            additionalParameters: additionalParameters
        )
        let window = try SignInPresentationAnchor.sharedKeyWindow
        let authState = try await OIDAuthState.present(request: request, window: window)
        let gtmSession = GTMSession(authState: authState)
        let sessionItem = try await keychain.insertItem(gtmSession: gtmSession)
        return _insertSession(item: sessionItem)
    }
    
    
    @MainActor
    fileprivate func _fetchAndRefresh(accountID: GoogleAccountID) async throws -> GoogleSession {
        guard let sessionItem = try await keychain.item(id: accountID) else { throw SessionError.noSession }
        let _: (acessToken: String, idToken: String) = try await withCheckedThrowingContinuation { continuation in
            sessionItem.gtmSession.authState.performAction(freshTokens: { (accessToken, idToken, error) in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: (acessToken: accessToken!, idToken: idToken!))
                }
            })
        }
        return _insertSession(item: sessionItem)
    }
    
    @MainActor // session._gtmSession will notify session to update
    fileprivate func _refresh(session: GoogleSession) async throws -> GoogleSession {
        let _: (acessToken: String, idToken: String) = try await withCheckedThrowingContinuation { continuation in
            session._gtmSession.authState.performAction(freshTokens: { (accessToken, idToken, error) in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: (acessToken: accessToken!, idToken: idToken!))
                }
            })
        }
        return session
    }
    
    // if session._gtmSession update, session will call this
    func updateFrom(session: GoogleSession) async throws {
        _ = try await keychain.updateItem(session._item)
    }
    
    // MARK: - SessionStore
    
    @MainActor
    fileprivate func _insertSession(item: GoogleSessionItem) -> GoogleSession {
        let session = GoogleSession(client: self, item: item)
        sessionStore[session.account.id] = session
        return session
    }
    
    @MainActor
    fileprivate func _refreshSession(accountID: GoogleAccountID) async throws -> GoogleSession {
        if let session = sessionStore[accountID] {
            return try await _refresh(session: session)
        } else {
            return try await _fetchAndRefresh(accountID: accountID)
        }
    }
}

// MARK: - Client API

extension GoogleClient : ClientProtocol {
    @MainActor
    public var sessions: [GoogleSession] { get async throws {
        try await keychain.items.asyncMap { @MainActor sessionItem in
            let accountID = sessionItem.account.id
            let session = accountID.storedSession ?? _insertSession(item: sessionItem)
            return try await _refresh(session: session)
        }
    } }

    @MainActor
    public func signIn() async throws -> GoogleSession {
        try await _signIn()
    }
}

// MARK: - Session API

extension GoogleSession : SessionProtocol {
    public typealias     ClientType = GoogleClient
    public typealias  AccountIDType = GoogleAccountID
    public typealias    AccountType = GoogleAccount
    public typealias MailFolderType = GoogleMailFolder
    public typealias    MessageType = GoogleMessage
    
    
    /* @MainActor // for SessionStore
     public static func sessions(client: GoogleClient) async throws -> [GoogleSession] { // the sessions should be refresh before using to fetch
     try await client.sessions()
     }
     
     @MainActor // for WebAuthenticationSession
     public static func signIn(client: GoogleClient) async throws -> GoogleSession {
     try await client.signIn()
     }
     
     public func signOut() async throws -> GoogleSession {
     try await client.signOut(session: self)
     }*/
    
    // used for request, refresh if neccessary
    
    public var refresh: GoogleSession { get async throws {
        try await client._refresh(session: self)
    } }
    
    @MainActor
    public func signOut() async throws -> GoogleSession {
        _ = try await client.keychain.deleteItem(_item)
        _ = account.id.removeSession()
        return self
    }
}

// MARK: - AccountID API

@MainActor
extension GoogleAccountID  : AccountToSessionProtocol {
    public var storedSession: GoogleSession? {
        SessionStore.shared[self]
    }
    
    public var refreshSession: GoogleSession { get async throws  {
        try await GoogleClient.shared._refreshSession(accountID: self)
    } }
    
    public func removeSession() -> GoogleSession? {
        let session = SessionStore.shared[self]
        SessionStore.shared[self] = nil
        return session
    }
}

/*
@MainActor
extension GoogleAccountID : AccountSessionAPI {

    public var storedSession: GoogleSession? { SessionStore.shared[self] }
    public var refreshSession: GoogleSession? { get async throws {
        try await SessionStore.shared.session(id: self, forceRefresh: false)?.refresh
    } }
    public func removeSession() -> GoogleSession? { SessionStore.shared.remove(id: self) }
}
*/

// MARK: - Session Store

@MainActor
@Observable
class SessionStore {
    var rawValue = [GoogleAccountID: GoogleSession]()
    
    subscript(id: GoogleAccountID) -> GoogleSession? {
        get { rawValue[id] }
        set { rawValue[id] = newValue }
    }
    static let shared = SessionStore()
}
