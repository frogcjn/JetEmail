//
//  MSALApp.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/31/24.
//
/*
import MSAL

extension Microsoft.Client {
    
    /*func addAccount() async throws -> Microsoft.Session {
        try await sessionStore.signInSession()
    }*/
    
    var accounts: [Microsoft.Account] {
        get throws {
            print("Microsoft.Client.accounts")
            
            // access MSALAcount from keychain
            let msalAccounts = try _msalClient.allAccounts()
            
            // map MSALAccount to Microsoft.Account
            return try msalAccounts.map { try $0.microsoftAccount(client: self) }
        }
    }
    
    /*func deleteAccount(id: Microsoft.ID) async throws -> Microsoft.Account {
        print("Microsoft.Client.deleteAccount")
        let account = try await account(id: id)
        try _msalClient.remove(account.msalAccount)
        return account
        /*
         try await sessionStore.deleteSession(account: account)?.account ?? account
         let parameters = MSALSignoutParameters(webviewParameters: webViewParameters)
         let result = try await _msalClient.signout(with: msalAccount, signoutParameters: parameters)
         return result
         */
    }
    

    func hasAccount(id: Microsoft.ID) async -> Bool {
        (try? await account(id: id)) != nil
    }
    
    func hasSession(id: Microsoft.ID) async throws -> Bool {
        (try await sessionStore.session(id: id)) != nil
    }*/
}

extension Microsoft.Account {
    
    var refreshedSession: Microsoft.Session { get async throws {
        try await client.sessionStore.refreshedSession(account: self)
    } }
    
    var authorizationHeader: String { get async throws {
        try await refreshedSession.msalSession.authorizationHeader
    } }
    
    /*func refreshAccount(_ account: Microsoft.Account) async throws -> Microsoft.Session {
        try await sessionStore.refreshSession(account)
    }*/
}



/*extension Microsoft.Account {
    var session: Microsoft.Session? {
        get async throws { try await client.sessionStore.session(id: id) }
    }*/
    
    /*var refreshedSession: Microsoft.Session {
        get async throws {
            if let session = try await session, !session.isExpired { return session }
            return try await client.refreshAccount(self)
        }
    }
}*/


extension Microsoft {
    actor SessionStore {
        unowned let client: Microsoft.Client
        init(client: Microsoft.Client) { self.client = client }
        
        private var _rawValue = [Microsoft.ID: Session]()

        fileprivate func signInSession() async throws -> Session {
            
            // MSALSession get from sign-in process
            let msalSession = try await client._msalSignin()
            let id = try msalSession.id
            
            // try to find existed session
            if let session = try await session(id: id) {
                // if exists: update the msalSession
                session.msalSession = msalSession
                return session
            }
            
            return try _storeSession(msalSession: msalSession)
        }
        
        fileprivate func refreshedSession(account: Microsoft.Account) async throws -> Session {
            if let session = try await session(id: account.id), !session.isExpired { return session }
            return try await refreshSession(account)
        }

        
        fileprivate func session(id: Microsoft.ID) async throws -> Session? {
            let msalAccount = try client._msalClient.allAccounts().first { $0.identifier == id.string }
            
            guard let msalAccount else {
                // Not found item in keychain
                _rawValue.removeValue(forKey: id)
                return nil
            }
            
            // Found item in keychain, and session store
            if let stored = _rawValue[id] { return stored }
            
            // Found item in keychain, but not session store
            let msalSession = try await client._msalRefresh(msalAccount: msalAccount)
            return try _storeSession(msalSession: msalSession)
        }
        
        private func refreshSession(_ account: Microsoft.Account) async throws -> Session {
            let msalSession = try await client._msalRefresh(msalAccount: account.msalAccount)
            
            // try to find existed session
            if let session = try await session(id: account.id) {
                // if exists: update the msalSession
                session.msalSession = msalSession
                return session
            }
            
            let session = try _storeSession(msalSession: msalSession)
            return session
        }
        
        /*var sessions: [Session] { // session in memory
            /*get async throws {
                // access MSALAccounts from keychain
                let msalAccounts = try client.msalClient.allAccounts()
                

                // map account items to existed or creating sessions
                let sessions = try msalAccounts.map { msalAccount throws in
                    guard let stringID = msalAccount.identifier else { throw Microsoft.AuthError.accountNoIDOrUsername }
                    let id = Microsoft.ID(string: stringID)
                    if let stored = _rawValue[id] {
                        // storeAccount.gtmSession
                        assert(stored.msalSession.account == msalAccount)
                        return stored
                    } else {
                        // access MSALSessions from keychain
                        let msalSessions = msalAccounts.map { client._msalRefreshedRequest(msalAccount: $0) }
                        
                        return try _createAndStoreSession(item: item)
                    }
                }
                
                // removing sessions not existed in keychain
                let existedIDs = sessions.map(\.id)
                let removingIDs = _rawValue.keys.filter { !existedIDs.contains($0) }
                for id in removingIDs {
                    _rawValue.removeValue(forKey: id)
                }
                return sessions
                
                return try items.map { try Microsoft.Account(client: self, msal: $0) }
                _msalRefreshedRequest
                Array(_rawValue.values)
            }*/
            return []
        }*/
        

        

        
        /*func deleteSession(account: Microsoft.Account) async throws -> Session? {
            let id = account.id
            let result = try await client._msalSignoutRequest(msalAccount: account.msalAccount)
            
            if let storedSession = _rawValue[id] {
                _rawValue.removeValue(forKey: id)
                return storedSession
            }
            return nil
        }
        
        func updateSession(_ session: Session) -> Session? {
            _rawValue[session.id] = session
            return session
        }*/
        
        private func _storeSession(msalSession: MSALSession) throws -> Microsoft.Session {
            let id = try msalSession.id
            guard let username = msalSession.account.username else { throw Microsoft.AuthError.accountNoIDOrUsername }
            
            let session = Microsoft.Session(sessionStore: self, id: id, username: username, msalSession: msalSession)
            _rawValue[id] = session
            return session
        }
    }
}


extension Microsoft.Session {
    fileprivate var isExpired: Bool {
        guard let expiresOn = msalSession.expiresOn else { return false }
        return Date.now >= expiresOn
    }
}

*/
