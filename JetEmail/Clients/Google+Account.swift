//
//  Google+Account.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/19/24.
//

/*

extension Google.Client {
    
    func addAccount() async throws -> Google.Session {
        try await sessionStore.signInSession()
    }
    
    var accounts: [Google.Account] {
        get async throws { try await sessionStore.sessions.map(\.account) }
    }
    
    func deleteAccount(id: Google.ID) async throws -> Google.Account? {
        try await sessionStore.deleteSession(id: id)?.account
    }
    
    func account(id: Google.ID) async throws -> Google.Account {
        guard let account = try await sessionStore.session(id: id)?.account else { throw Google.AuthError.noAccountFound }
        return account
    }
    
    /*func refreshAccount(_ account: Google.Account) async throws -> Google.Session? {
        try await sessionStore.refreshSession(account: account)
    }*/
    
    func hasAccount(id: Google.ID) async -> Bool {
        (try? await account(id: id)) != nil
    }
    
    func hasSession(id: Google.ID) async throws -> Bool {
        (try await sessionStore.session(id: id)) != nil
    }
}


extension Google.Client {
    /*func signInSession() async throws -> Google.SessionKeychainStore.Item {
        let gtmSession = try await _gtmSignIn()
        guard let stringID = gtmSession.userID, let username = gtmSession.userEmail else { throw Google.AuthError.accountNoIDOrUsername }
        let id = Google.ID(string: stringID)
        // add session
        
        // try to find existed session
        if let session = try await session(id: id) {
            // if existed update the gtmSession
            session.gtmSession = gtmSession // trigger update session
            return session
        }
        
        // try to add to keychain
        let item = try await SessionKeychainStore.shared.addItem(id: id, username: username, gtm: gtmSession)
        
        // find duplicated existed keychain item add fail
        guard let item else { throw Google.AuthError.sessionStoreAddFail  }
        
        // add success
        return item
        // return try _storeSession(item: item)
    }*/
}

extension Google {
    
    actor SessionStore {
        unowned let client: Google.Client
        init(client: Google.Client) { self.client = client }
        
        private var _rawValue = [Google.ID: Google.Session]()

        func signInSession() async throws -> Google.Session {
            let gtmSession = try await client._gtmSignIn()
            guard let stringID = gtmSession.userID, let username = gtmSession.userEmail else { throw Google.AuthError.accountNoIDOrUsername }
            let id = Google.ID(string: stringID)
            // add session
            
            // try to find existed session
            if let session = try await session(id: id) {
                // if existed update the gtmSession
                session.gtmSession = gtmSession // trigger update session
                return session
            }
            
            // try to add to keychain
            let item = try await SessionKeychainStore.shared.addItem(id: id, username: username, gtm: gtmSession)
            
            // find duplicated existed keychain item add fail
            guard let item else { throw Google.AuthError.sessionStoreAddFail  }
            
            // add success
            return try _storeSession(item: item)
        }
        
        var sessions: [Google.Session] {
            get async throws {
                // access from keychain
                let items = try await SessionKeychainStore.shared.items()
                
                // map keychain items to existed or creating sessions
                let sessions = try items.map { item throws in
                    if let storeAccount = _rawValue[item.id] {
                        // storeAccount.gtmSession
                        assert(storeAccount.keychain === item.keychain)
                        return storeAccount
                    } else {
                        return try _storeSession(item: item)
                    }
                }
                
                // removing sessions not existed in keychain
                let existedIDs = sessions.map(\.id)
                let removingIDs = _rawValue.keys.filter { !existedIDs.contains($0) }
                for id in removingIDs {
                    _rawValue.removeValue(forKey: id)
                }
                return sessions
            }
        }
        
        fileprivate func deleteSession(id: Google.ID) async throws -> Google.Session? {
            if let item = try await SessionKeychainStore.shared.item(id: id) {
                _ = try await SessionKeychainStore.shared.deleteItem(item)
            }
            
            if let storedSession = _rawValue[id] {
                _rawValue.removeValue(forKey: id)
                return storedSession
            }
            return nil
        }
        
        fileprivate func session(id: Google.ID) async throws -> Google.Session? {
            let item = try await SessionKeychainStore.shared.item(id: id)
            
            guard let item else {
                // Not found item in keychain
                _rawValue.removeValue(forKey: id)
                return nil
            }
            
            // Found item in keychain, and session store
            if let stored = _rawValue[id] {
                // storeAccount.gtm == item.gtm
                assert(stored.keychain === item.keychain)
                return stored
            }
            
            // Found item in keychain, but not session store
            return try _storeSession(item: item)
        }
        

        
        /*private func refreshSession(account: Google.Account) async throws -> Google.Session? {
                                
         }*/
        
        func updateSession(_ session: Session) async throws -> Session {
            let id = session.id
            
            // update keychain
            let item = try await SessionKeychainStore.shared.updateItem(session.keychainItem)
            
            // varify sessionStore
            if let storedSession = _rawValue[id] {
                assert(storedSession === self)
                return storedSession
            } else {
                return try _storeSession(item: item)
            }
        }
        
        /*fileprivate func refreshedSession(account: Microsoft.Account) async throws -> Session {
            if let session = try await session(id: account.id), !session.isExpired { return session }
            return try await refreshSession(account)
        }*/
        
        private func refreshSession(_ session: Session) async throws -> Session {
            _ = try await session._gtmRefresh() // will trgger update session
            return session
        }
        
        private func _storeSession(item: SessionKeychainStore.Item) throws -> Google.Session {
            guard let username = item.gtm.userEmail else { throw Google.AuthError.accountNoIDOrUsername }
            let id = item.id
            let session = try Google.Session(sessionStore: client.sessionStore, id: id, username: username, gtmSession: item.gtm, keychain: item.keychain)
            _rawValue[id] = session
            return session
        }
    }
}
/*

*/
/*
extension Google.Account {
    init(session: Google.Session) {
        self.init(client: session.sessionStore.client, id: session.id, username: session.username)
    }
}*/
*/
