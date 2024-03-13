//
//  GTM+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/20/24.
//

// import AppKit
@preconcurrency import AppAuthCore
import GTMAppAuth

import SwiftUI
import AuthenticationServices

#if os(iOS) || os(visionOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

import JetEmailID

fileprivate let kIncludeGrantedScopesParameter = "include_granted_scopes"

extension GoogleClient {
    
    
    @MainActor  // for WebAuthenticationSession
    func _gtmSignIn() async throws -> AuthSession {
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
        return AuthSession(authState: authState)
    }
}

extension AuthSession {
    func _refresh() async throws -> (acessToken: String, idToken: String) {
        try await withCheckedThrowingContinuation { continuation in
            authState.performAction(freshTokens: { (accessToken, idToken, error) in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: (acessToken: accessToken!, idToken: idToken!))
                }
            })
        }
    }
}





