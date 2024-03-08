//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/8/24.
//

@preconcurrency import MSAL

extension Client {
    
    @MainActor // for webViewParameters
    var webViewParameters: MSALWebviewParameters { get throws {
        MainActor.assertIsolated()
        // TODO:
#if !os(macOS)
        guard let window = UIApplication.sharedKeyWindow, let ViewController = window.rootViewController else { throw AuthError.authorizeNoMainWindow }
#else
        guard let window = NSApplication.sharedKeyWindow, let viewController = window.contentViewController else { throw AuthError.authorizeNoMainWindow }
#endif
        return .init(authPresentationViewController: viewController)
    } }
    
    
    // @MainActor // for webViewParameters
    func _msalSignIn() async throws -> MSALSession {
        let scopes = Client.scopes.map(\.rawValue)
        
        let parameters = try await MSALInteractiveTokenParameters(scopes: scopes, webviewParameters: webViewParameters)
        parameters.promptType = .selectAccount
        return try await _msalClient.acquireToken(with: parameters)
    }
    
    // @MainActor // for webViewParameters
    func _msalSignout(msalAccount: MSALAccount) async throws -> Bool {        
        let parameters = try await MSALSignoutParameters(webviewParameters: webViewParameters)
        return try await _msalClient.signout(with: msalAccount, signoutParameters: parameters)
    }

    func _forceRefresh(id: ID) async throws -> MSALSession {
        let scopes = Client.scopes.map(\.rawValue)
        let msalAccount = try _msalClient.account(forIdentifier: id.rawValue)
        
        let parameters = MSALSilentTokenParameters(scopes: scopes, account: msalAccount)
        return try await _msalClient.acquireTokenSilent(with: parameters)
    }
}
