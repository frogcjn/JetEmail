//
//  GTM+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/20/24.
//

// import AppKit
import Foundation
import AppAuth
import AppAuthCore
import GTMAppAuth
import JetEmail_Foundation

#if canImport(UIKit)
import UIKit
#endif

fileprivate let kIncludeGrantedScopesParameter = "include_granted_scopes"

//public extension Google {
public typealias GTMSession         = GTMAppAuth.AuthSession
public typealias GTMSessionDelegate = GTMAppAuth.AuthSessionDelegate
public typealias SessionProtocol    = NSObject & GTMSessionDelegate & OIDAuthStateChangeDelegate & OIDAuthStateErrorDelegate
public typealias OpenIDState        = OIDAuthState
//}

public extension Google.Client {
    
    @MainActor  // for window
    func _gtmSignIn() async throws -> GTMSession {
        MainActor.assertIsolated()
        #if os(iOS)
        guard let window = UIApplication.sharedKeyWinwdow?.rootViewController else { throw Google.AuthError.authorizeNoMainWindow }
    
        #elseif os(visionOS)
        
        guard let window = UIApplication.sharedKeyWinwdow else { throw Google.AuthError.authorizeNoMainWindow }

        #elseif os(macOS)
        guard let window = NSApplication.shared.windows.first else { throw Google.AuthError.authorizeNoMainWindow }
        #endif
        
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
        
        var authFlow: OIDExternalUserAgentSession?
        
        let authState = try await withCheckedThrowingContinuation { continuation in
            // guard authorizationFlow is not existe
            
            
            
            
            authFlow = OIDAuthState.authState(byPresenting: request, presenting: window) { state, error in
                // Brings this app to the foreground.
                // NSRunningApplication.current.activate(options: [.activateAllWindows, .activateAllWindows])
                if let state = state {
                    continuation.resume(returning: state)
                } else {
                    let error: Error = error ?? Google.AuthError.message("Auth with Google failed.")
                    continuation.resume(throwing: error)
                }
            }
        }
        withExtendedLifetime(authFlow) {} // keep authFlow after get auth state
        
        return AuthSession(authState: authState)
    }
}

extension GTMSession {
    func refresh() async throws -> (acessToken: String, idToken: String) {
        try await withCheckedThrowingContinuation { continuation in
            authState.performAction(freshTokens: { (accessToken, idToken, error) in
                if let error {
                    continuation.resume(throwing: error)
                }
                continuation.resume(returning: (acessToken: accessToken!, idToken: idToken!))
            })
        }
    }
}
