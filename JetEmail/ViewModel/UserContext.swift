//
//  MSALAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/31/24.
//

import Foundation
import MSAL

@dynamicMemberLookup
@Observable
class UserContext {
    private var _appContext: AppContext
    private var _loginResult: AppContext.Result
    var account: MSALAccount { _loginResult.account }
    var accessToken: String { _loginResult.accessToken }
    
    var mailFoldersRequest: Microsoft.Graph.MailFolder.RequestBuilder
    
    init(appContext: AppContext, loginResult: AppContext.Result) {
        _appContext = appContext
        _loginResult = loginResult
        mailFoldersRequest = .init()
        mailFoldersRequest._userContext = self
    }
}

// @dynamicMemberLookup
extension UserContext {
    
    subscript<Value>(dynamicMember keyPath: KeyPath<AppContext, Value>) -> Value {
        _appContext[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<AppContext, Value>) -> Value {
        get {
            _appContext[keyPath: keyPath]
        }
        set {
            _appContext[keyPath: keyPath] = newValue
        }
    }
    
    subscript<Value>(dynamicMember keyPath: KeyPath<Microsoft.Graph.MailFolder.RequestBuilder, Value>) -> Value {
        mailFoldersRequest[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Microsoft.Graph.MailFolder.RequestBuilder, Value>) -> Value {
        get {
            mailFoldersRequest[keyPath: keyPath]
        }
        set {
            mailFoldersRequest[keyPath: keyPath] = newValue
        }
    }
}
