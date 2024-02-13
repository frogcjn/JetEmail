//
//  AppViewModel.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/12/24.
//

import SwiftUI
import SwiftData
import MSAL

@dynamicMemberLookup
@Observable
class AppViewModel {
    
    // App Settings
    var appSettings: AppSettings
    
    // Model Context
    var modelContext: ModelContext
    
    // MSAL Context
    var msalContext: MSALContext
    
    @MainActor
    init(appSettings: AppSettings, modelContext: ModelContext, msalContext: MSALContext) {
        self.appSettings = appSettings
        self.modelContext = modelContext
        self.msalContext = msalContext
    }
}

extension AppViewModel {

    
    /// Add an account to `modelContext`.
    func addAccount() async throws {
        let account = try await _msalContext.addMSALAccount().model
        
        // insert or update
        modelContext.insert(account) // if id existed, just update
        try modelContext.save()
    }
    
    /// Remove an account from `modelContext`.
    /// - Parameter account: the account to remove.
    func removeAccount(_ account: Account) async throws {
        try await msalContext.removeMSALAccount(for: account)
        
        // delete
        modelContext.delete(account)
        try modelContext.save()
    }
    
    /// sync all accounts from msalContext to `modelContext`.
    /// - Parameter accounts: Accounts from SwiftData. default is nil, which means this function will query all Accounts from SwiftData.
    func syncAccountsFromMSAL(accounts: [Account]? = nil) throws {
        let accounts = try accounts ?? modelContext.fetch(FetchDescriptor<Account>())

        let msalAccounts = try msalContext.msalAccounts()
        
        let idToMSALAccount: [String: MSALAccount] = .init(uniqueKeysWithValues: msalAccounts.compactMap { msalAccount in
            guard let id = msalAccount.identifier else { return nil }
            return (id, msalAccount)
        })
        
        let ids = Set(idToMSALAccount.keys).subtracting(accounts.map(\.id)) // ids contains in MSAL but not in SwiftData
        let accountsToAdd = ids.compactMap { id in try? idToMSALAccount[id]?.model }
        
        // update
        accountsToAdd.forEach { modelContext.insert($0) }
        try modelContext.save()
    }
}


// @dynamicMemberLookup
extension AppViewModel {
    
    // App Settings
    subscript<Value>(dynamicMember keyPath: KeyPath<AppSettings, Value>) -> Value {
        appSettings[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<AppSettings, Value>) -> Value {
        get { appSettings[keyPath: keyPath] }
        set { appSettings[keyPath: keyPath] = newValue }
    }
    
    // Model Context
    subscript<Value>(dynamicMember keyPath: KeyPath<ModelContext, Value>) -> Value {
        modelContext[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<ModelContext, Value>) -> Value {
        get { modelContext[keyPath: keyPath] }
        set { modelContext[keyPath: keyPath] = newValue }
    }
    
    // MSAL Context
    subscript<Value>(dynamicMember keyPath: KeyPath<MSALContext, Value>) -> Value {
        msalContext[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<MSALContext, Value>) -> Value {
        get { msalContext[keyPath: keyPath] }
        set { msalContext[keyPath: keyPath] = newValue }
    }
}
