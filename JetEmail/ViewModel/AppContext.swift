//
//  MSALApp.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/31/24.
//

import SwiftUI
import MSAL

@dynamicMemberLookup
@Observable
class AppContext {
    
    typealias Result = MSALResult
    // configs
    private let          clientID            = "0ef42f9f-afc7-4463-bcbe-1c6dd4076b40"
    private let       redirectURL            = URL(string: "msauth.me.frogcjn.agent://auth")!
    private let      authorityURL            = URL(string: "https://login.microsoftonline.com/common")!
            let  grapEndPointMeURL: URL      = URL(string: "https://graph.microsoft.com/v1.0/me/")!
            let             scopes: [String] = ["user.read"] // request permission to read the profile of the signed-in user
    
    let  webViewParameters: MSALWebviewParameters
    let applicationContext: MSALPublicClientApplication
    
    var user: UserContext?

    var loginHint = ""
    private var _loginResult: MSALResult? {
        get {
            user?._loginResult
        }
        set {
            if let loginResult = newValue {
                self.user = UserContext(appContext: self, loginResult: loginResult)
            } else {
                self.user = nil
            }
        }
    }
    
    unowned var _settings: AppSettings!
    
    init() throws {

        let         authority = try MSALAADAuthority(url: authorityURL)
        let     configuration = MSALPublicClientApplicationConfig(clientId: clientID, redirectUri: redirectURL.absoluteString, authority: authority)
        applicationContext = try MSALPublicClientApplication(configuration: configuration)
        webViewParameters  = MSALWebviewParameters()
        
        Task { await signIn(allowInteractive: false) }
    }
    
    enum EndPointError : Error {
        case description(String)
    }
    
    func signIn(allowInteractive: Bool) async {
        guard user == nil else { return }
        
        (_loginResult, loginHint) = await {
            do {
                return try await _getAccount(allowInteractive: allowInteractive)
            } catch {
                return (nil, "Couldn't sign in account with error: \(error)")
            }
        }()
    }
    
    func signOut() async {
        guard let user else { return }

        (_loginResult, loginHint) = await _signOut(account: user.account)
    }
}

private extension AppContext {
    
    func _signOut(account: MSALAccount) async -> (MSALResult?, String) {
        do {
            // Removes all tokens from the cache for this application for the provided account; - account: The account to remove from the cache
            let parameters = MSALSignoutParameters(webviewParameters: self.webViewParameters)
            parameters.signoutFromBrowser = false // set this to true if you also want to signout from browser or webview
            let success = try await self.applicationContext.signout(with: account, signoutParameters: parameters)
            return (nil, success ? "Sign out completed successfully" : "Sign out completed unsuccessfully")
        } catch {
            return (nil, "Couldn't sign out account with error: \(error)")
        }
    }
    
    func _getAccount(allowInteractive: Bool) async throws -> (MSALResult?, String) {
        
        let account: MSALAccount?
        do {
            let msalParameters = MSALParameters()
            msalParameters.completionBlockQueue = DispatchQueue.main
            (account, _) = try await applicationContext.currentAccount(with: msalParameters)
        } catch {
            throw MSALAppError.getAccount(error)
        }
            
        return try await _getToken(allowInteractive: allowInteractive, account: account)
    }
    
    func _getToken(allowInteractive: Bool, account: MSALAccount?) async throws -> (MSALResult?, String) {
        
        guard let account else {
            // We check to see if we have a current logged in account.
            // If we don't, then we need to sign someone in.
            return try await _getTokenInteractively(allowInteractive: allowInteractive)
        }

        do {
            return try await _geTokenSilently(account: account)
        } catch MSALAppError.getTokenInteractively(let nsError as NSError) where
            allowInteractive &&
            nsError.domain == MSALErrorDomain &&
            nsError.code == MSALError.interactionRequired.rawValue
        {
            // interactionRequired means we need to ask the user to sign-in. This usually happens
            // when the user's Refresh Token is expired or if the user has changed their password
            // among other possible reasons.
            return try await _getTokenInteractively(allowInteractive: allowInteractive)
        }
    }
    
    func _geTokenSilently(account: MSALAccount) async throws -> (MSALResult?, String) {
        do {
            /**
             
             Acquire a token for an existing account silently
             
             - forScopes:           Permissions you want included in the access token received
             in the result in the completionBlock. Not all scopes are
             guaranteed to be included in the access token returned.
             - account:             An account object that we retrieved from the application object before that the
             authentication flow will be locked down to.
             - completionBlock:     The completion block that will be called when the authentication
             flow completes, or encounters an error.
             */
            let parameters = MSALSilentTokenParameters(scopes: scopes, account: account)
            let result = try await applicationContext.acquireTokenSilent(with: parameters)
            return (result, "accessToken=\(result.accessToken)")
        } catch {
            throw MSALAppError.getTokenInteractively(error)
        }
    }
    
    func _getTokenInteractively(allowInteractive: Bool) async throws -> (MSALResult?, String) {
        guard allowInteractive else {
            // We check to see if we have a current logged in account.
            // If we don't, then we need to sign someone in.
            throw MSALAppError.getTokenInteractivelyDoNotAllow
        }
        
        do {
            let parameters = MSALInteractiveTokenParameters(scopes: scopes, webviewParameters: webViewParameters)
            parameters.promptType = .selectAccount
            let result = try await applicationContext.acquireToken(with: parameters)
            return (result, "accessToken=\(result.accessToken)")
        } catch {
            throw MSALAppError.getTokenInteractively(error)
        }
    }
}

enum MSALAppError : Error {
    case getAccount(Error)
    case getTokenInteractivelyDoNotAllow
    case getTokenInteractively(Error)
    case getTokenSilently(Error)
}

// @dynamicMemberLookup
extension AppContext {
    
    subscript<Value>(dynamicMember keyPath: KeyPath<AppSettings, Value>) -> Value {
        _settings[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<AppSettings, Value>) -> Value {
        get {
            _settings[keyPath: keyPath]
        }
        set {
            _settings[keyPath: keyPath] = newValue
        }
    }
}
