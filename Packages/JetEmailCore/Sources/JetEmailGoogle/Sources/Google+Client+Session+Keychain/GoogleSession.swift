//
//  GoogleAPI.Account.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/17/24.
//

import GTMAppAuth
import AppAuth
import JetEmailData

public typealias GoogleSessionProtocol = NSObject & AuthSessionDelegate & OIDAuthStateChangeDelegate & OIDAuthStateErrorDelegate
public final class GoogleSession: GoogleSessionProtocol, Sendable {

    public let      client : GoogleClient
    public let     account : GoogleAccount
           let _gtmSession : GTMSession
    
           let keychainItem: Data
    
    init(client: GoogleClient, item: GoogleSessionItem) {
        self.client       = client
        self.account      = item.account
        self._gtmSession  = item.gtmSession
        self.keychainItem = item.keychainItem
        super.init()
        
        _gtmSession.delegate                      = self
        _gtmSession.authState.stateChangeDelegate = self
        _gtmSession.authState.errorDelegate       = self
    }
}


public extension GoogleSession {
    // MARK: - GTMSessionDelegate
    func additionalTokenRefreshParameters(forAuthSession gtmSession: AuthSession) -> [String : String]? {
        return nil
    }
    
    func updateError(forAuthSession gtmSession: AuthSession, originalError: Error, completion: @escaping (Error?) -> Void) {
        completion(originalError)
    }

    // MARK: - OIDAuthStateChangeDelegate
    
    func didChange(_ state: OIDAuthState) {
        Task {
            try await client.updateFrom(session: self)
        }
    }


    // MARK: - OIDAuthStateErrorDelegate
    
    func authState(_ state: OIDAuthState, didEncounterAuthorizationError error: Error) {
        // print(#function, state)
    }
    
    func authState(_ state: OIDAuthState, didEncounterTransientError error: Error) {
        // print(#function, state)
    }
}
