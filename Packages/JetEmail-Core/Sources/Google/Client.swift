//
//  GoogleAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/17/24.
//

import Foundation
import GTMAppAuth

// Google.Client = App + Google


public final class Client {
    public let      clientID               = "383073233076-bs69m1og40cpgqr4d209hlk40mlmdfo4.apps.googleusercontent.com"
    public let   redirectURL               = URL(string: "com.googleusercontent.apps.383073233076-bs69m1og40cpgqr4d209hlk40mlmdfo4:/oauth2callback")!
    public let        scopes: [Scope]      = [.email, .profile /* optional*/, .gmailReadOnly, .gmailLabels]
    public let configuration               = GTMSession.configurationForGoogle()
    public let  responseType: ResponseType = .code
    
    public init(){}
    
    public let  keychain = Keychain.shared
    
    //@MainActor
    //var isBusy = false
    //let logger = Logger(subsystem: "me.frogcjn.jet-email", category: "GoogleAPI")
}



public extension Client {
    enum Scope: String {
        case openid
        case email // OIDScopeEmail
        case profile
        case gmailReadOnly = "https://www.googleapis.com/auth/gmail.readonly"
        case gmailLabels   = "https://www.googleapis.com/auth/gmail.labels"
    }
    
    enum ResponseType: String {
        case code // OIDResponseTypeCode
    }
}
