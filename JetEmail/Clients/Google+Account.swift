//
//  GoogleAPI.Account.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/17/24.
//

import Security
import Google

/*
Google.Session = Google.Account + GTMAuthSession
*/
/*
extension Google {
    class Session: SessionProtocol {
                let  accountID         : Google.ID
                let  username   : String
                let  gtmSession : GTMSession
        // { didSet { if gtmSession != oldValue { Task { _ = try await updateKeychainItem() } } } }
          
                let keychainItem: SecKeychainItem
         
        
        init(accountID: Google.ID, username: String, gtmSession: GTMSession, keychainItem: SecKeychainItem) {
            self.accountID    = accountID
            self.username     = username
            self.gtmSession   = gtmSession
            self.keychainItem = keychainItem
            super.init()
            
            gtmSession.delegate = self
            gtmSession.authState.stateChangeDelegate = self
            gtmSession.authState.errorDelegate = self
        }
        
        func additionalTokenRefreshParameters(forAuthSession gtmSession: GTMSession) -> [String : String]? {
            return nil
        }
        
        func updateError(forAuthSession gtmSession: GTMSession, originalError: Error, completion: @escaping (Error?) -> Void) {
            completion(originalError)
        }
        
        func didChange(_ state: OpenIDState) {
            Task { _ = try await updateKeychainItem() }
        }
        
        func authState(_ state: OpenIDState, didEncounterAuthorizationError error: Error) {
            print(#function, state)
        }
        
        func authState(_ state: OpenIDState, didEncounterTransientError error: Error) {
            print(#function, state)
        }
        
        fileprivate func updateKeychainItem() async throws {
            _ = try await Google.Client.shared.keychain.updateItem(item)
        }
        
        func refresh() async throws {
            _ = try await gtmSession.refresh()
        }
    }
}




// Google.GTMSession -> Google.SessionKeychain.Item
extension Google.GTMSession {
    func insertTo(keychain: Google.Keychain) async throws -> Google.Keychain.SessionItem {
        try await keychain.insertItem(gtmSession: self)
    }
    
    
}


extension Google.Keychain.SessionItem {
    
    func deleteFrom(keychain: Google.Keychain) async throws -> Google.Keychain.SessionItem {
        try await keychain.deleteItem(self)
    }
}

// Google.Session -> Account, KeychainItem*/
extension Google.Session {
    var account: Account { .init(modelID: modelID, username: username) }
    // var item: Google.Keychain.SessionItem { .init(accountID: accountID, username: username, gtmSession: gtmSession, keychainItem: keychainItem) }
}

