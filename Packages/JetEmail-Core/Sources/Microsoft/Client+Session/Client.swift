//
//  MSAL.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import JetEmail_Foundation
@preconcurrency import MSAL
public typealias MSALAccount = MSAL.MSALAccount
public typealias MSALSession = MSAL.MSALResult

public final class Client : Sendable {
         static let       scopes: [Scope] = [.userRead, .mailRead] // request permission to read the profile of the signed-in user
         static let  endpointURL          = URL(string: "https://graph.microsoft.com/v1.0/me/")!
    
    fileprivate let     clientID          = "0ef42f9f-afc7-4463-bcbe-1c6dd4076b40"
    fileprivate let  redirectURL          = URL(string: "msauth.me.frogcjn.jet-email://auth")!

    fileprivate let authorityURL          = URL(string: "https://login.microsoftonline.com/common")!
    
    public let       _msalClient: MSALPublicClientApplication
    
    public init() async throws {
        let configuration = MSALPublicClientApplicationConfig(
            clientId: clientID,
            redirectUri: redirectURL.absoluteString,
            authority: try MSALAADAuthority(url: authorityURL)
        )
        _msalClient = try await Task.detached { [configuration] in
            checkBackgroundThread()
            return try MSALPublicClientApplication(configuration: configuration)
        }.value
    }
}
    

public extension Client {
    enum Scope: String, Sendable {
        case userRead = "user.read"
        case mailRead = "mail.read"
    }
}

