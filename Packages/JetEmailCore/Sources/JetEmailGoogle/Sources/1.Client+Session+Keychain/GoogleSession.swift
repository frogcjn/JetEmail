//
//  GoogleAPI.Account.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/17/24.
//

import GTMAppAuth
import AppAuth
import JetEmailData

public typealias GoogleSessionProtocol = NSObject & AuthSessionDelegate & OIDAuthStateChangeDelegate & OIDAuthStateErrorDelegate & SessionProtocol
public final class GoogleSession: GoogleSessionProtocol, Sendable {

    public let      client : GoogleClient
    public let     account : GoogleAccount
           let        _item: Item
        
    init(client: GoogleClient, _item: Item) {
        self.client  = client
        self.account = _item.account
        self._item   = _item
        super.init()
        
        _item.gtmSession.delegate                      = self
        _item.gtmSession.authState.stateChangeDelegate = self
        _item.gtmSession.authState.errorDelegate       = self
    }
    
    struct Item : ValueType, Sendable {
        let        account: GoogleAccount
        let     gtmSession: GTMSession
        let   keychainItem: Data
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
            try await client._updateFrom(session: self)
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

