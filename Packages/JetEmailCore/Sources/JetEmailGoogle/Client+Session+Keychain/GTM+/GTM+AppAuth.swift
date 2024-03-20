//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/12/24.
//

import AppAuth
import JetEmailData
import SwiftUI
import AuthenticationServices

extension OIDAuthState {
    
    @MainActor // for WebAuthenticationSession
    static func present(request: OIDAuthorizationRequest, webAuthenticationSession: WebAuthenticationSession)  async throws -> OIDAuthState {
        try await present(request: request, externalUserAgent: webAuthenticationSession.externalUserAgent)
    }
    
    @MainActor
    static func present(request: OIDAuthorizationRequest, externalUserAgent: any OIDExternalUserAgent) async throws -> OIDAuthState {
        //var authFlow: OIDExternalUserAgentSession?
        let authState = try await withCheckedThrowingContinuation { continuation in
            OIDAuthState.authState(byPresenting: request, externalUserAgent: externalUserAgent) { state, error in
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
        // withExtendedLifetime(authFlow) {} // keep authFlow after get auth state
        return authState
    }
    
    @MainActor // for window
    static func present(request: OIDAuthorizationRequest, window: JetEmailData.Window) async throws -> OIDAuthState {
        var authFlow: OIDExternalUserAgentSession?
#if os(iOS)
guard let anchor = window.rootViewController else { throw SignInPresentationAnchorError.authorizeNoMainViewController }
#else
let anchor = window
#endif

        let authState = try await withCheckedThrowingContinuation { continuation in
            authFlow = OIDAuthState.authState(byPresenting: request, presenting: anchor) { state, error in
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
        return authState
    }
}

