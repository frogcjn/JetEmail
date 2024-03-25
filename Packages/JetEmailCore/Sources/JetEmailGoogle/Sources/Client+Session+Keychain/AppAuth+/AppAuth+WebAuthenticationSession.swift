//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/12/24.
//
/*
@preconcurrency import AppAuth // @preconcurrency for any OIDExternalUserAgentSession
import SwiftUI
import AuthenticationServices

extension WebAuthenticationSession : @unchecked Sendable {
    var externalUserAgent: any OIDExternalUserAgent {
        ExternalUserAgent(webAuthenticationSession: self)
    }
    
    @MainActor
    fileprivate func authenticate(requestURL: URL, requestRedirectScheme: String) async throws -> URL {
        #if compiler(>=5.10)
        if #available(visionOS 1.1, macOS 14.4, iOS 17.4, *) {
            try await authenticate(
                using: requestURL,
                callback: .customScheme(requestRedirectScheme),
                //preferredBrowserSession: .ephemeral,
                additionalHeaderFields: [:]
            )
        } else {
            try await authenticate(
                using: requestURL,
                callbackURLScheme: requestRedirectScheme
                //preferredBrowserSession: .ephemeral
            )
        }
        #else
        try await authenticate(
            using: requestURL,
            callbackURLScheme: requestRedirectScheme
            //preferredBrowserSession: .ephemeral
        )
        #endif
    }
}

fileprivate final class ExternalUserAgent : NSObject, OIDExternalUserAgent {
    
    let webAuthenticationSession: WebAuthenticationSession
    
    private var _externalUserAgentFlowInProgress: Bool = false
    private var _session: OIDExternalUserAgentSession?
    
    init(webAuthenticationSession: WebAuthenticationSession) {
        self.webAuthenticationSession = webAuthenticationSession
    }
    
    public func present(_ request: any OIDExternalUserAgentRequest, session: any OIDExternalUserAgentSession) -> Bool {
        if _externalUserAgentFlowInProgress { return false }
        guard let requestURL = request.externalUserAgentRequestURL(), let requestRedirectScheme = request.redirectScheme() else { return false }
        
        _externalUserAgentFlowInProgress = true
        _session = session
        
        Task { [webAuthenticationSession] in
            do {
                let resultURL = try await webAuthenticationSession.authenticate(requestURL:requestURL, requestRedirectScheme: requestRedirectScheme)
                session.resumeExternalUserAgentFlow(with: resultURL)
            } catch {
                session.failExternalUserAgentFlowWithError(OIDErrorUtilities.error(with: .userCanceledAuthorizationFlow, underlyingError: error, description: nil))
            }
        }
        return true
    }
    
    public func dismiss(animated: Bool) async {
        if !_externalUserAgentFlowInProgress { return }
        clearUp()
    }
    
    func clearUp() {
        _session = nil
        _externalUserAgentFlowInProgress = false
    }
}
*/

// import SwiftUI
// import AuthenticationServices
/*
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
}*/
