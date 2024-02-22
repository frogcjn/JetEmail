//
//  GoogleAPI.Account.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/17/24.
//

import Security
import GTMAppAuth
import AppAuthCore

/*
Google.Session = Google.Account + GTMAuthSession
*/

extension Google {
    class Session: NSObject, AuthSessionDelegate, OIDAuthStateChangeDelegate, OIDAuthStateErrorDelegate {
        
        unowned
        let sessionStore: SessionStore
        
        let id        : Google.Account.ID
        let username  : String
        var gtmSession: GTMAuthSession
        { didSet { if gtmSession != oldValue { Task { _ = try await sessionStore.updateSession(self) } } } }
        
        let keychain : SecKeychainItem
        
        init(sessionStore: SessionStore, id: Google.Account.ID, username: String, gtmSession: GTMAuthSession, keychain: SecKeychainItem) throws {
            self.sessionStore = sessionStore
            self.id           = id
            self.username     = username
            self.gtmSession  = gtmSession
            self.keychain     = keychain
            super.init()
            
            gtmSession.delegate = self
            gtmSession.authState.stateChangeDelegate = self
            gtmSession.authState.errorDelegate = self
        }
        
        func additionalTokenRefreshParameters(forAuthSession authSession: AuthSession) -> [String : String]? {
            print(#function, authSession)
            return nil
        }
        
        func updateError(forAuthSession authSession: AuthSession, originalError: Error, completion: @escaping (Error?) -> Void) {
            print(#function, authSession, originalError)
            completion(originalError)
        }
        
        func didChange(_ state: OIDAuthState) {
            print(#function, state)
            Task { _ = try await sessionStore.updateSession(self) }
        }
        
        func authState(_ state: OIDAuthState, didEncounterAuthorizationError error: Error) {
            print(#function, state)
        }
        
        func authState(_ state: OIDAuthState, didEncounterTransientError error: Error) {
            print(#function, state)
        }
    }
}

// Session -> Account, KeychainItem

extension Google.Session {
    var keychainItem: Google.SessionKeychainStore.Item {
        (id: id, gtm: gtmSession, keychain: keychain)
    }
}


