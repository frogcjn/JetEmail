//
//  MSAL+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/20/24.
//

import MSAL

extension Microsoft.Client {
    func _msalSignin() async throws -> MSALResult {
        let parameters = {
            let parameters = MSALInteractiveTokenParameters(scopes: scopes.map(\.rawValue), webviewParameters: webViewParameters)
            parameters.promptType = .selectAccount
            return parameters
        }()
        return try await _msalClient.acquireToken(with: parameters)
    }
    
    func _msalRefresh(msalAccount: MSALAccount) async throws -> MSALResult {
        let parameters = MSALSilentTokenParameters(scopes: scopes.map(\.rawValue), account: msalAccount)
        return try await _msalClient.acquireTokenSilent(with: parameters)
    }
    
    /*func _msalSignoutRequest(msalAccount: MSALAccount) async throws -> Bool {
        let parameters = MSALSignoutParameters(webviewParameters: webViewParameters)
        let result = try await _msalClient.signout(with: msalAccount, signoutParameters: parameters)
        return result
    }*/
}
