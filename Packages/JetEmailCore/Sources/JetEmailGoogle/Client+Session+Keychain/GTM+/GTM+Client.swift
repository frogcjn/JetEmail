//
//  GTM+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/20/24.
//

// import AppKit
@preconcurrency import AppAuthCore
import GTMAppAuth

#if os(iOS) || os(visionOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

fileprivate let kIncludeGrantedScopesParameter = "include_granted_scopes"

extension GoogleClient {
    
    @MainActor  // for window
    func _gtmSignIn() async throws -> AuthSession {
        MainActor.assertIsolated()
        #if os(iOS)
        guard let window = UIApplication.sharedKeyWindow?.rootViewController else { throw AuthError.authorizeNoMainWindow }
    
        #elseif os(visionOS)
        
        guard let window = UIApplication.sharedKeyWindow else { throw AuthError.authorizeNoMainWindow }

        #elseif os(macOS)
        guard let window = NSApplication.sharedKeyWindow else { throw AuthError.authorizeNoMainWindow }
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
                    let error: Error = error ?? AuthError.message("Auth with Google failed.")
                    continuation.resume(throwing: error)
                }
            }
        }
        withExtendedLifetime(authFlow) {} // keep authFlow after get auth state
        
        return AuthSession(authState: authState)
    }
}

extension AuthSession {
    func _refresh() async throws -> (acessToken: String, idToken: String) {
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
