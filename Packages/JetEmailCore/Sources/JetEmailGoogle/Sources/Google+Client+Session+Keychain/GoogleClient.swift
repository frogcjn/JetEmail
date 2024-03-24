//
//  GoogleAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/17/24.
//
import JetEmailData
import AppAuth
import GTMAppAuth

public actor GoogleClient {
    
    @MainActor
    public static let shared = GoogleClient()
    
    let      clientID                  = "383073233076-bs69m1og40cpgqr4d209hlk40mlmdfo4.apps.googleusercontent.com"
    let   redirectURL                  = URL(string: "com.googleusercontent.apps.383073233076-bs69m1og40cpgqr4d209hlk40mlmdfo4:/oauth2callback")!
    let        scopes: [Scope]         = [.email, .profile /* optional*/, .gmailReadOnly, .gmailLabels, .gmailModify]
    let configuration                  = GTMSession.configurationForGoogle()
    let  responseType: ResponseType    = .code
    let kIncludeGrantedScopesParameter = "include_granted_scopes"
    init(){}
    
    @MainActor
    var  sessionStore: SessionStore { .shared }
    var      keychain: Keychain     { .shared }
}

extension GoogleClient {
    enum Scope: String, CodableValueType, Sendable {
        case openid
        case email // OIDScopeEmail
        case profile
        case gmail         = "https://mail.google.com/"
        case gmailReadOnly = "https://www.googleapis.com/auth/gmail.readonly"
        case gmailLabels   = "https://www.googleapis.com/auth/gmail.labels"
        case gmailModify   = "https://www.googleapis.com/auth/gmail.modify"
    }
    
    enum ResponseType: String, CodableValueType, Sendable {
        case code // OIDResponseTypeCode
    }
}

struct GoogleSessionItem : ValueType, Sendable {
    let        account: GoogleAccount
    let     gtmSession: GTMSession
    let   keychainItem: Data
}

public typealias GTMSessionDelegate  = AuthSessionDelegate
public typealias GTMSession         = AuthSession
       typealias GTMConfiguration   = OIDServiceConfiguration

extension        GTMSession : @unchecked Sendable {}
extension  GTMConfiguration : @unchecked Sendable {}
