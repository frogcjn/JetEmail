//
//  GoogleAPI.Client.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/17/24.
//

import Foundation
import AppKit
import AppAuth
import GTMAppAuth
import KeychainAccess

extension GoogleAPI {
    enum Scope: String {
        case openid
        case email // OIDScopeEmail
        case profile
        case gmailReadOnly = "https://www.googleapis.com/auth/gmail.readonly"
    }
    
    enum ResponseType: String {
        case code // OIDResponseTypeCode
    }
    
    
    final class Client {
        private let configuration              = AuthSession.configurationForGoogle()
        private let     clientID               = "383073233076-bs69m1og40cpgqr4d209hlk40mlmdfo4.apps.googleusercontent.com"
        private let redirectURL                = URL(string: "com.googleusercontent.apps.383073233076-bs69m1og40cpgqr4d209hlk40mlmdfo4:/oauth2callback")!
        // private let clientSecret              = no client secret
        private let       scopes: [Scope]      = [.email, .profile /* optional*/, .gmailReadOnly]
        private let responseType: ResponseType = .code
        private let successURL                 = URL(string: "http://openid.github.io/AppAuth-iOS/redirect/")

        init() {
        }
            
        fileprivate func authorize() async throws -> AuthSession {
            
            guard let window = await NSApp.mainWindow else {
                throw GoogleAPI.AuthError.noMainWindow
            }
            
            
            let additionalParameters: [String: String] = [
                /*kIncludeGrantedScopesParameter*/ "include_granted_scopes": "true"
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
            
            var authFlow: OIDExternalUserAgentSession?
            
            let authSession = try await withCheckedThrowingContinuation { continuation in
                // guard authorizationFlow is not existe
                authFlow = OIDAuthState.authState(byPresenting: request, presenting: window) { state, error in
                    // Brings this app to the foreground.
                    // NSRunningApplication.current.activate(options: [.activateAllWindows, .activateAllWindows])
                    if let state = state {
                        continuation.resume(returning: AuthSession(authState: state))
                    } else {
                        let error: Error = error ?? AuthError.message("Auth with Google failed.")
                        continuation.resume(throwing: error)
                    }
                }
                
            }
            
            withExtendedLifetime(authFlow) {} // keep session after get auth state
            
            return authSession
        }
        
        func _addAccount() async throws -> GoogleAPI.Account {
            try await authorize().account
        }
    }
}


fileprivate extension AuthSession {
    var account: GoogleAPI.Account {
        let account = GoogleAPI.Account(id: userID!, email: userEmail!)
        account.authSession = self
        return account
    }
}

extension GoogleAPI.Account {
    var keychain: Keychain {
        Keychain(service: "me.frogcjn.jet-email")
    }
    
    var authSession: AuthSession? {
        get {
            if let data = keychain[data: id] {
                return try? NSKeyedUnarchiver.unarchivedObject(ofClass: AuthSession.self, from: data)
            }
            return nil
        }
        nonmutating set {
            guard let newValue = newValue, newValue.canAuthorize else {
                keychain[id] = nil
                return
            }
            let data = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false)
            keychain[data: id] = data
        }
    }
}
