//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/12/24.
//

import AppAuth

extension OIDAuthState {
    
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
}

