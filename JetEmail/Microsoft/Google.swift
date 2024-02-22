//
//  GoogleAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/17/24.
//

import GTMAppAuth
import os

// Google.Client = App + Google

struct Google {
    typealias GTMAuthSession         = GTMAppAuth.AuthSession
    typealias GTMAuthSessionDelegate = GTMAppAuth.AuthSessionDelegate
    
    final class Client : GTMAuthSessionDelegate {
        let      clientID               = "383073233076-bs69m1og40cpgqr4d209hlk40mlmdfo4.apps.googleusercontent.com"
        let   redirectURL               = URL(string: "com.googleusercontent.apps.383073233076-bs69m1og40cpgqr4d209hlk40mlmdfo4:/oauth2callback")!
        let        scopes: [Scope]      = [.email, .profile /* optional*/, .gmailReadOnly]
        let configuration               = AuthSession.configurationForGoogle()
        let  responseType: ResponseType = .code
        
        init(){
            sessionStore = .init(client: self)
        }
        
        var sessionStore: SessionStore!

        // associated properties:
        @MainActor
        var isBusy = false
        let logger = Logger(subsystem: "me.frogcjn.jet-email", category: "GoogleAPI")
    }
}

import Foundation
import AppKit
import AppAuth
import GTMAppAuth
import KeychainAccess


extension Google.Client {
    enum Scope: String {
        case openid
        case email // OIDScopeEmail
        case profile
        case gmailReadOnly = "https://www.googleapis.com/auth/gmail.readonly"
    }
    
    enum ResponseType: String {
        case code // OIDResponseTypeCode
    }
}
