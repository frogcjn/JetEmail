//
//  GoogleAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/17/24.
//

import Foundation
import AppAuth
import GTMAppAuth
import JetEmailID

public actor GoogleClient : Sendable {
    let      clientID               = "383073233076-bs69m1og40cpgqr4d209hlk40mlmdfo4.apps.googleusercontent.com"
    let   redirectURL               = URL(string: "com.googleusercontent.apps.383073233076-bs69m1og40cpgqr4d209hlk40mlmdfo4:/oauth2callback")!
    let        scopes: [Scope]      = [.email, .profile /* optional*/, .gmailReadOnly, .gmailLabels, .gmailModify]
    let configuration               = AuthSession.configurationForGoogle()
    let  responseType: ResponseType = .code
    
    init(){}
}

extension GoogleClient {
    enum Scope: String, CodableValueType {
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
