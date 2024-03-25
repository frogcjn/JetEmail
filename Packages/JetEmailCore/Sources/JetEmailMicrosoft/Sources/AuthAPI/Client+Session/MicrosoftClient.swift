//
//  MSAL.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import typealias JetEmailFoundation.CodableValueType
import JetEmailData
import MSAL

public actor MicrosoftClient {
    
    @MainActor
    public static var shared = MicrosoftClient()
    
    let  endpointURL         = URL(string: "https://graph.microsoft.com/v1.0/")!
    let     clientID         =             "0ef42f9f-afc7-4463-bcbe-1c6dd4076b40"
    let  redirectURL         = URL(string: "msauth.me.frogcjn.jet-email://auth")!
    let authorityURL         = URL(string: "https://login.microsoftonline.com/common")!
    let      scopes: [Scope] = [.userRead, .mailReadWrite, .mailSend, .mailboxSettingsReadWrite] // request permission to read the profile of the signed-in user
    
    var _msalClient: MSALClient?
    
    init() {}
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

typealias MSALAccount = MSAL.MSALAccount
typealias MSALSession = MSAL.MSALResult
typealias MSALClient  = MSAL.MSALPublicClientApplication

extension                        MSALClient: @unchecked Sendable {}
extension                       MSALAccount: @unchecked Sendable {}
extension                       MSALSession: @unchecked Sendable {}
extension MSALPublicClientApplicationConfig: @unchecked Sendable {}
extension    MSALInteractiveTokenParameters: @unchecked Sendable {}
extension         MSALSilentTokenParameters: @unchecked Sendable {}
extension             MSALSignoutParameters: @unchecked Sendable {}
