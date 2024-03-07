//
//  GoogleAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/17/24.
//

import Foundation
@preconcurrency import AppAuth

// Google.Client = App + Google

public final class Client : Sendable {
    public let      clientID               = "383073233076-bs69m1og40cpgqr4d209hlk40mlmdfo4.apps.googleusercontent.com"
    public let   redirectURL               = URL(string: "com.googleusercontent.apps.383073233076-bs69m1og40cpgqr4d209hlk40mlmdfo4:/oauth2callback")!
    public let        scopes: [Scope]      = [.email, .profile /* optional*/, .gmailReadOnly, .gmailLabels, .gmailModify]
    public let configuration               = GTMSession.configurationForGoogle()
    public let  responseType: ResponseType = .code
    
    public init(){}
}


public extension Client {
    enum Scope: String, Sendable {
        case openid
        case email // OIDScopeEmail
        case profile
        case gmail         = "https://mail.google.com/"
        case gmailReadOnly = "https://www.googleapis.com/auth/gmail.readonly"
        case gmailLabels   = "https://www.googleapis.com/auth/gmail.labels"
        case gmailModify   = "https://www.googleapis.com/auth/gmail.modify"
    }
    
    enum ResponseType: String, Sendable {
        case code // OIDResponseTypeCode
    }
}
