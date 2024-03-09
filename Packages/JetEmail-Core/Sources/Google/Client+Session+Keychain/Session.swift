//
//  GoogleAPI.Account.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/17/24.
//

@preconcurrency import GTMAppAuth
import AppAuth

public final class Session: NSObject & AuthSessionDelegate & OIDAuthStateChangeDelegate & OIDAuthStateErrorDelegate, Sendable {
    public let  accountID  : ID
    public let  username   : String
           let _gtmSession : AuthSession
    
           let keychainItem: Data
    
    init(accountID: ID, username: String, gtmSession: AuthSession, keychainItem: Data) {
        self.accountID    = accountID
        self.username     = username
        self._gtmSession  = gtmSession
        self.keychainItem = keychainItem
        super.init()
        
        gtmSession.delegate                      = self
        gtmSession.authState.stateChangeDelegate = self
        gtmSession.authState.errorDelegate       = self
    }
}


public extension Session {
    // MARK: - AuthSessionDelegate
    func additionalTokenRefreshParameters(forAuthSession gtmSession: AuthSession) -> [String : String]? {
        return nil
    }
    
    func updateError(forAuthSession gtmSession: AuthSession, originalError: Error, completion: @escaping (Error?) -> Void) {
        completion(originalError)
    }

    // MARK: - OIDAuthStateChangeDelegate
    
    func didChange(_ state: OIDAuthState) {
        Task { _ = try await Keychain.shared.updateItem(_item) }
    }


    // MARK: - OIDAuthStateErrorDelegate
    
    func authState(_ state: OIDAuthState, didEncounterAuthorizationError error: Error) {
        // print(#function, state)
    }
    
    func authState(_ state: OIDAuthState, didEncounterTransientError error: Error) {
        // print(#function, state)
    }
}
