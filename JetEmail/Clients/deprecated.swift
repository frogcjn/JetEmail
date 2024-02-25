//
//  Model+GoogleAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/18/24.
//

// MARK: - Model <-> MSGraph
/*
extension Account {
    convenience init(google: Google.Account, orderIndex: Int) throws {
        self.init(
            modelID: google.modelID,
            username: google.username,
            orderIndex: orderIndex
        )
    }
    
    func update(google: Google.Account, deleteMark: Bool = false) {
        if self.modelID == google.modelID && self.username == google.username && self.deleteMark == deleteMark { return }
        self.deleteMark = deleteMark
        self.modelID  = google.modelID
        self.username = google.username
    }
    /*
    var googleAccount: Google.Account? {
        @available(macOS, unavailable, message: "Parse Use graph(_ client: MSGraph) instead.")
        @available(iOS, unavailable, message: "Parse Use graph(_ client: MSGraph) instead.")
        get {
            nil // should use graph(_:)
            // self.graph
        }
        set {
            guard let google = newValue else { return }
            self.modelID  = google.modelID
            self.username = google.username
        }
    }*/
}

*/

/*.onChange(of: account.hasAccount, initial: true) {
    Task {
        await account.updateState()
    }
}
.onChange(of: account.hasSession, initial: true) {
    Task {
        await account.updateState()
    }
}*/


/*// Feature: Accounts - Remove Account
/// Remove an account from `MSGraph.Context` and `ModelContext`.
/// - Parameter account: the account to remove.
@MainActor // for isAppModelBusy, item.isBusy
func removeAccountForGoogle(_ model: Account) async {
    await model.removeAccount()
}*/

/*// Feature: Accounts - Remove Account
/// Remove an account from `MSGraph.Context` and `ModelContext`.
/// - Parameter account: the account to remove.
@MainActor // for isAppModelBusy, item.isBusy
func removeAccount(_ model: Account) async {
    await AppItemModel(context: self, item: model).delete()
}*/



/*func loadMailFolders(account accountPersistentID: PersistentID<Account>) async throws {
    BackgroundModelActor.assertIsolated()
    
    let account = self[accountPersistentID]!
    
    switch try await account.refreshedIfExpiredSession {
    case .microsoft(let session):
        let microsoftRoot = try await session.getRootMailFolder()
        let root = try modelContext.setRootMailFolder(microsoft: microsoftRoot, in: account.persistentID)
        
        var queue: [MailFolder] = [root]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            
            let microsofts = try await session.getChildFolders(microsoftID: .init(string: current.platformID))
            let children = try modelContext.setChildrenMailFolders(microsofts: microsofts, parentID: current.persistentID, in: account.persistentID)
            
            queue.append(contentsOf: children)
        }
    case .google(let session):
        let googles = try await session.getMailFolders()
        try modelContext._setMailFolders(googles: googles, in: account)
    default:
        return
    }
}*/

/// Set all messages from graphContext to `ModelContainer`.
/// - Parameters:
///   - elements: Messages from  `MSGraph.Context`.
///   - mailFolder: mai
/// - Returns: Messages from `ModelContainer`.

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

//
//  MSAL.Account.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

// Account = Client + Account.ID

import MSAL // for MSALAccount
/*
extension Microsoft {
    struct Account {
        let client  : Client

        let id         : ID
        let username   : String
        let msalAccount: MSALAccount
        
        fileprivate init(client: Client, id: ID, username: String, msalAccount: MSALAccount) {
            self.client = client
            self.id = id
            self.username = username
            self.msalAccount = msalAccount
        }
    }
}
*/

// Microsoft.Session -> Miccrosoft.Account

/*extension Microsoft.Session {
    /*func account(client: Microsoft.Client) -> Microsoft.Account {
        .init(client: client, id: id, username: username, msalAccount: msalSession.account)
    }*/
}

// MSALAccount -> Microsoft.Account

extension MSALAccount {
    func microsoftAccount(client: Microsoft.Client) throws -> Microsoft.Account {
        guard let id = identifier, let username = username else { throw Microsoft.AuthError.accountNoIDOrUsername }
        return Microsoft.Account(client: client, id: .init(string: id), username: username, msalAccount: self)
    }
}*/


//
//  Google.Account.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/20/24.
//

// Account = Client + Account.ID
/*
extension Google {
    struct Account {
        let client  : Client

        let id      : ID
        let username: String
        
        fileprivate init(client: Client, id: ID, username: String) {
            self.client = client
            self.id = id
            self.username = username
        }

    }
}*/
/*
extension Google.Session {
    var account: Google.Account {
        .init(client: sessionStore.client, id: id, username: username)
    }
}
*/
