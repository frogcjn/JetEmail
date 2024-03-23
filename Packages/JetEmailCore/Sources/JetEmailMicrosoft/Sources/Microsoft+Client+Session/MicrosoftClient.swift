//
//  MSAL.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import JetEmailData
@preconcurrency import MSAL

public actor MicrosoftClient : Sendable {
    static      public let       scopes: [Scope] = [.userRead, .mailReadWrite, .mailSend, .mailboxSettingsReadWrite] // request permission to read the profile of the signed-in user
    static      public let  endpointURL          = URL(string: "https://graph.microsoft.com/v1.0/")!
    
           fileprivate let     clientID          = "0ef42f9f-afc7-4463-bcbe-1c6dd4076b40"
           fileprivate let  redirectURL          = URL(string: "msauth.me.frogcjn.jet-email://auth")!
           fileprivate let authorityURL          = URL(string: "https://login.microsoftonline.com/common")!
                       let _msalClient: MSALPublicClientApplication
    
    init() throws {
        checkBackgroundThread()
        
        let configuration = MSALPublicClientApplicationConfig(
            clientId: clientID,
            redirectUri: redirectURL.absoluteString,
            authority: try MSALAADAuthority(url: authorityURL)
        )
        
        _msalClient = try MSALPublicClientApplication(configuration: configuration)
    }
}
    

extension MicrosoftClient {
    // https://learn.microsoft.com/en-us/graph/permissions-reference#mail-permissions
    public enum Scope: String, CodableValueType, Sendable {
        case userRead                 = "User.Read"
        
        // mail
        
        case mailReadBasic            = "Mail.ReadBasic"
        case mailReadBasicAll         = "Mail.ReadBasic.All"
        case mailReadBasicShared      = "Mail.ReadBasic.Shared"

        case mailRead                 = "Mail.Read"
        case mailReadShared           = "Mail.Read.Shared"

        case mailReadWrite            = "Mail.ReadWrite"
        case mailReadWriteShared      = "Mail.ReadWrite.Shared"
        
        case mailSend                 = "Mail.Send"
        case mailSendShared           = "Mail.Send.Shared"
        
        case mailboxSettingsRead      = "MailboxSettings.Read"
        case mailboxSettingsReadWrite = "MailboxSettings.ReadWrite"
    }
}
