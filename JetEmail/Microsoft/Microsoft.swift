//
//  MSAL.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import MSAL
import os

// Google.Client = App + Microsoft

struct Microsoft {
    typealias MSALAccount = MSAL.MSALAccount
    typealias MSALSession = MSAL.MSALResult
    
    final class Client {
        
        // configs
        fileprivate let     clientID          = "0ef42f9f-afc7-4463-bcbe-1c6dd4076b40"
        fileprivate let  redirectURL          = URL(string: "msauth.me.frogcjn.jet-email://auth")!
                    let       scopes: [Scope] = [.userRead, .mailRead] // request permission to read the profile of the signed-in user
        fileprivate let authorityURL          = URL(string: "https://login.microsoftonline.com/common")!
                    let  endpointURL          = URL(string: "https://graph.microsoft.com/v1.0/me/")!
        
        let       _msalClient: MSALPublicClientApplication
        let webViewParameters: MSALWebviewParameters
        
        init() throws {
            let configuration = MSALPublicClientApplicationConfig(
                clientId: clientID,
                redirectUri: redirectURL.absoluteString,
                authority: try MSALAADAuthority(url: authorityURL)
            )
            _msalClient        = try MSALPublicClientApplication(configuration: configuration)
            webViewParameters = .init()
            sessionStore      = SessionStore(client: self)
        }
        
        var sessionStore: SessionStore!

        // associated properties:
        @MainActor
        var isBusy = false
        let logger = Logger(subsystem: "me.frogcjn.jet-email", category: "MicrosoftAPI")
    }
    
}

extension Microsoft.Client {
    enum Scope: String {
        case userRead = "user.read"
        case mailRead = "mail.read"
    }
}
