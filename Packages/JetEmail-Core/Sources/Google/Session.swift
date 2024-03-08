//
//  GoogleAPI.Account.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/17/24.
//

import Security
import Observation
import Foundation
import JetEmail_Foundation

@preconcurrency import GTMAppAuth

//public extension Google {
public final class Session: SessionProtocol, Sendable {
    public let  accountID  : Google.ID
    public let  username   : String
    public let  gtmSession : GTMSession
    // { didSet { if gtmSession != oldValue { Task { _ = try await updateKeychainItem() } } } }
      
    public let keychainItem: Data
     
    
    public init(accountID: Google.ID, username: String, gtmSession: GTMSession, keychainItem: Data) {
        self.accountID    = accountID
        self.username     = username
        self.gtmSession   = gtmSession
        self.keychainItem = keychainItem
        super.init()
        
        gtmSession.delegate = self
        gtmSession.authState.stateChangeDelegate = self
        gtmSession.authState.errorDelegate = self
    }
    
    public func additionalTokenRefreshParameters(forAuthSession gtmSession: GTMSession) -> [String : String]? {
        return nil
    }
    
    public func updateError(forAuthSession gtmSession: GTMSession, originalError: Error, completion: @escaping (Error?) -> Void) {
        completion(originalError)
    }
    
    public func didChange(_ state: OpenIDState) {
        Task { _ = try await updateKeychainItem() }
    }
    
    public func authState(_ state: OpenIDState, didEncounterAuthorizationError error: Error) {
        // print(#function, state)
    }
    
    public func authState(_ state: OpenIDState, didEncounterTransientError error: Error) {
        // print(#function, state)
    }
    
    fileprivate func updateKeychainItem() async throws {
        _ = try await Google.Keychain.shared.updateItem(item)
    }
    
    public func refresh() async throws {
        _ = try await gtmSession.refresh()
    }
}
// }

// GTMSession -> Keychain

public extension GTMSession {
    func insertTo(keychain: Google.Keychain) async throws -> Google.Keychain.SessionItem {
        try await keychain.insertItem(gtmSession: self)
    }
}

// Keychain -> Keychain

/*public extension Keychain.SessionItem {
    func deleteFrom(keychain: Google.Keychain) async throws -> Google.Keychain.SessionItem {
        try await keychain.deleteItem(self)
    }
}*/

// Session -> Keychain

public extension Session {
    var item: Keychain.SessionItem { .init(accountID: accountID, username: username, gtmSession: gtmSession, keychainItem: keychainItem) }
}


// KeyChain -> Session

@MainActor
public extension Google.Keychain.SessionItem {
    var lazySession: Google.Session {
        if let session = Google.SessionStore.shared[accountID] {
            assert(session.keychainItem == keychainItem)
            return session
        }
        return newSession
    }
    
    var newSession: Google.Session {
        let session = Google.Session(accountID: accountID, username: username, gtmSession: gtmSession, keychainItem: keychainItem)
        Google.SessionStore.shared[accountID]  = session
        return session
    }
    
    /*var lazyReplacementSession: Google.Session {
        if let session = Google.Session[id] {
            session.gtmSession = gtmSession
            assert(session.keychainItem === keychainItem)
            return session
        }
        return newSession
    }*/
    
}
