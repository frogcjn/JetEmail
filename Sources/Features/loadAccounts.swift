//
//  LoadAccounts.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

// MARK: Feature: Accounts - Load Accounts

import JetEmail_Foundation

extension AppModel {
    
    @MainActor // for isBusy
    func loadAccounts() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            try await _loadAccounts()
        } catch {
            logger.error("\(error)")
        }
    }
    
    @BackgroundActor
    private func _loadAccounts() async throws {
        let sessions = try await Client.sessions
        _ = try await BackgroundModelActor.shared.setSessions(sessions) // load session from local keychain
    }
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
