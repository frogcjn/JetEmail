//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/12/24.
//

import AppAuth
import class JetEmailFoundation.Window

extension OIDAuthState {
    
    @MainActor // for window
    static func present(request: OIDAuthorizationRequest, window: JetEmailFoundation.Window) async throws -> OIDAuthState {
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
                    let error: Error = error ?? GoogleAuthError.OIDAuthStateCompletionFail
                    continuation.resume(throwing: error)
                }
            }
            
        }
         withExtendedLifetime(authFlow) {} // keep authFlow after get auth state
        return authState
    }
}

