//
//  MSGraph.Context.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import MSAL // for MSALPublicClientApplication

extension MSGraph {
    final class Client {
        
        // configs
        fileprivate let     clientID = "0ef42f9f-afc7-4463-bcbe-1c6dd4076b40"
        fileprivate let  redirectURL = URL(string: "msauth.me.frogcjn.jet-email://auth")!
        fileprivate let authorityURL = URL(string: "https://login.microsoftonline.com/common")!
                    let  endpointURL = URL(string: "https://graph.microsoft.com/v1.0/me/")!
                    let       scopes = ["user.read", "mail.read"] // request permission to read the profile of the signed-in user

        let            client: MSALPublicClientApplication
        let webViewParameters: MSALWebviewParameters
        
        init() throws {
            let configuration = MSALPublicClientApplicationConfig(
                clientId: clientID,
                redirectUri: redirectURL.absoluteString,
                authority: try MSALAADAuthority(url: authorityURL)
            )
                       client = try MSALPublicClientApplication(configuration: configuration)
            webViewParameters = .init()
        }
        
        func _addAccount() async throws -> MSGraph.Account {
            let parameters = MSALInteractiveTokenParameters(scopes: scopes, webviewParameters: webViewParameters)
            parameters.promptType = .selectAccount
            return try .init(try await client.acquireToken(with: parameters).account) // interactivelty
        }
    }
}

