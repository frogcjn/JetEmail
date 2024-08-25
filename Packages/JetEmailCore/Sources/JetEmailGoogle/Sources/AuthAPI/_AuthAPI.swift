//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/20/24.
//

import GTMAppAuth
import AppAuth

import struct JetEmailFoundation.SignInPresentationAnchor
import JetEmailData

extension GoogleClient {
    
    @MainActor
    func _sessions() async throws -> [GoogleSession] {
        try await keychain.items.asyncMap { @MainActor sessionItem in
            let accountID = sessionItem.account.id
            let session = accountID.cachedSession ?? _insertSession(item: sessionItem)
            return try await _refresh(session: session)
        }
    }
    
    @MainActor  // for SignInPresentationAnchor
    func _signIn() async throws -> GoogleSession {
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
            scopes: scopes,
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
    func _fetchAndRefresh(accountID: GoogleAccountID) async throws -> GoogleSession {
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
    func _refresh(session: GoogleSession) async throws -> GoogleSession {
        let _: (acessToken: String, idToken: String) = try await withCheckedThrowingContinuation { continuation in
            session._item.gtmSession.authState.performAction(freshTokens: { (accessToken, idToken, error) in
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
    func _updateFrom(session: GoogleSession) async throws {
        _ = try await keychain.updateItem(session._item)
    }
    
    // MARK: - SessionStore
    
    @MainActor
    func _insertSession(item: GoogleSession.Item) -> GoogleSession {
        let session = GoogleSession(client: self, _item: item)
        session.account.id.session = session
        return session
    }
    
    @MainActor
    func _refreshSession(accountID: GoogleAccountID) async throws -> GoogleSession {
        if let session = accountID.session {
            return try await _refresh(session: session)
        } else {
            return try await _fetchAndRefresh(accountID: accountID)
        }
    }
}
