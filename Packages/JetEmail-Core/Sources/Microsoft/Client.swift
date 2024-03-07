//
//  MSAL.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

@preconcurrency import MSAL
import JetEmail_Foundation

// Google.Client = App + Microsoft

public final class Client : Sendable {
    
    // configs
    fileprivate let     clientID          = "0ef42f9f-afc7-4463-bcbe-1c6dd4076b40"
    fileprivate let  redirectURL          = URL(string: "msauth.me.frogcjn.jet-email://auth")!
         public let       scopes: [Scope] = [.userRead, .mailRead] // request permission to read the profile of the signed-in user
    fileprivate let authorityURL          = URL(string: "https://login.microsoftonline.com/common")!
         static let  endpointURL          = URL(string: "https://graph.microsoft.com/v1.0/me/")!
    
    public let       _msalClient: MSALPublicClientApplication
    //public let webViewParameters: MSALWebviewParameters
    
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
       //webViewParameters = .init(authPresentationViewController: <#T##UIViewController#>)
    }
    
}
    

public extension Client {
    enum Scope: String, Sendable {
        case userRead = "user.read"
        case mailRead = "mail.read"
    }
}


public extension Client {
    // account for request
    /*func account(id: Microsoft.ID) async throws -> Microsoft.Account {
        
        // access MSALAcount from keychain
        let msalAccount = try _msalClient.account(forIdentifier: id.string)
        
        // map MSALAccount to Microsoft.Account
        return try msalAccount.microsoftAccount(client: self)
        /*let parameters = MSALAccountEnumerationParameters(identifier: id.rawValue)
         // parameters.returnOnlySignedInAccounts = true
         guard let account = try await client.accountsFromDevice(for: parameters).first else {
         throw MSGraphError.noAccountFound
         }
         return try .init(account)*/
    }*/
    
}
