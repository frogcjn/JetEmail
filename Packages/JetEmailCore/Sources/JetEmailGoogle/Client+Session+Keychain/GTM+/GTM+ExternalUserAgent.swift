//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/12/24.
//

@preconcurrency import AppAuth
import SwiftUI
import AuthenticationServices


// extension WebAuthenticationSession: @unchecked Sendable {}

extension WebAuthenticationSession {
    var externalUserAgent: any OIDExternalUserAgent {
        ExternalUserAgent(webAuthenticationSession: self)
    }
}

fileprivate class ExternalUserAgent : NSObject, OIDExternalUserAgent, @unchecked Sendable {
    
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
        
        Task {
            await task(requestURL: requestURL, requestRedirectScheme: requestRedirectScheme, session: session)
        }
        return true
    }
    
    func task(requestURL: URL, requestRedirectScheme: String, session: any OIDExternalUserAgentSession) async {
        do {
            let resultURL: URL
            
            if #available(visionOS 1.1, macOS 14.4, iOS 17.4, *) {
                resultURL = try await webAuthenticationSession.authenticate(
                    using: requestURL,
                    callback: .customScheme(requestRedirectScheme),
                    //preferredBrowserSession: .ephemeral,
                    additionalHeaderFields: [:]
                )
            } else {
                resultURL = try await webAuthenticationSession.authenticate(
                    using: requestURL,
                    callbackURLScheme: requestRedirectScheme
                    //preferredBrowserSession: .ephemeral
                )
            }
                
            session.resumeExternalUserAgentFlow(with: resultURL)
        } catch {
            session.failExternalUserAgentFlowWithError(OIDErrorUtilities.error(with: .userCanceledAuthorizationFlow, underlyingError: error, description: nil))
        }
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
