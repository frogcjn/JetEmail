//
//  GoogleAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/17/24.
//

import Foundation

// Google.Client = App + Google

struct Google {

    final class Client {
        let      clientID               = "383073233076-bs69m1og40cpgqr4d209hlk40mlmdfo4.apps.googleusercontent.com"
        let   redirectURL               = URL(string: "com.googleusercontent.apps.383073233076-bs69m1og40cpgqr4d209hlk40mlmdfo4:/oauth2callback")!
        let        scopes: [Scope]      = [.email, .profile /* optional*/, .gmailReadOnly, .gmailLabels]
        let configuration               = GTMSession.configurationForGoogle()
        let  responseType: ResponseType = .code
        
        init(){}
        
        let  keychain = Keychain.shared
        
        //@MainActor
        //var isBusy = false
        //let logger = Logger(subsystem: "me.frogcjn.jet-email", category: "GoogleAPI")
    }
}


extension Google.Client {
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
