//
//  GoogleAPI.Account.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/17/24.
//

@preconcurrency import GTMAppAuth
import AppAuth
import JetEmailID

public typealias GoogleSessionProtocol = NSObject & AuthSessionDelegate & OIDAuthStateChangeDelegate & OIDAuthStateErrorDelegate
public final class GoogleSession: GoogleSessionProtocol, PlatformSpecificCase, Sendable {
    public var platformCaseGeneralID: AccountID { accountID.general }
        
    public let  accountID  : GoogleAccountID
    public let  username   : String
    public let _gtmSession : AuthSession
    
           let keychainItem: Data
    
    init(accountID: GoogleAccountID, username: String, gtmSession: AuthSession, keychainItem: Data) {
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


public extension GoogleSession {
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
