//
//  LoadAccounts.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

// MARK: Feature: Accounts - Load Accounts

extension AppModel {
    func loadAccounts() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            let sessions = try await Microsoft.Client.shared.sessions.map(Session.microsoft) + Google.Client.shared.sessions.map(Session.google)
            _ = try await BackgroundModelActor.shared.setSessions(sessions) // load session from local keychain
        } catch {
            logger.error("\(error)")
        }
    }
}

extension Microsoft.Client {
    var sessions: [Microsoft.Session] { get async throws {
        try await _msalAccounts.asyncMap { try await $0.lazySession }
    } }
}

extension Google.Client {
    var sessions: [Google.Session] { get async throws {
        try await keychain.items.map(\.lazySession)
    } }
}

extension BackgroundModelActor {
    func setSessions(_ sessions: [Session]) async throws -> [PersistentID<Account>] {
        BackgroundModelActor.assertIsolated()
        do {
            // inserts
            let inserts: [Account] = try sessions.map(modelContext._insertAccount(session:))
            
            // others: not have session
            let others = try modelContext._fetchAccountNotIn(Array(inserts), in: .google)
            others.forEach { $0.session = nil }
            
            // save
            try modelContext.save()
            
            // return
            return inserts.map(\.persistentID)
        } catch {
            modelContext.rollback()
            throw error
        }
    }
}
