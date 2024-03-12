//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

@preconcurrency import MSAL
import JetEmailID

typealias MSALAccount = MSAL.MSALAccount
typealias MSALSession = MSAL.MSALResult

extension MicrosoftClient {
    
    @MainActor // for webViewParameters
    var webViewParameters: MSALWebviewParameters { get throws {
        MainActor.assertIsolated()
        // TODO:
#if !os(macOS)
        guard let window = UIApplication.sharedKeyWindow, let viewController = window.rootViewController else { throw AuthError.authorizeNoMainWindow }
#else
        guard let window = NSApplication.sharedKeyWindow, let viewController = window.contentViewController else { throw AuthError.authorizeNoMainWindow }
#endif
        return .init(authPresentationViewController: viewController)
    } }
    
    
    @MainActor // for webViewParameters
    func _msalSignIn() async throws -> MSALSession {
        let scopes = MicrosoftClient.scopes.map(\.rawValue)
        
        let parameters = try MSALInteractiveTokenParameters(scopes: scopes, webviewParameters: webViewParameters)
        parameters.promptType = .selectAccount
        return try await _msalClient.acquireToken(with: parameters)
    }
    
    @MainActor // for webViewParameters
    func _msalSignout(msalAccount: MSALAccount) async throws -> Bool {        
        let parameters = try MSALSignoutParameters(webviewParameters: webViewParameters)
        return try await _msalClient.signout(with: msalAccount, signoutParameters: parameters)
    }

    func refresh(id: MicrosoftAccountID) async throws -> MSALSession {
        let scopes = MicrosoftClient.scopes.map(\.rawValue)
        let msalAccount = try _msalClient.account(forIdentifier: id.innerID)
        
        let parameters = MSALSilentTokenParameters(scopes: scopes, account: msalAccount)
        return try await _msalClient.acquireTokenSilent(with: parameters)
    }
}
