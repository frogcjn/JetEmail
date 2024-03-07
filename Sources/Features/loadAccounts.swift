//
//  LoadAccounts.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

// MARK: Feature: Accounts - Load Accounts

import JetEmail_Foundation
import Foundation

extension AppModel {
    
    @MainActor // for isBusy
    func loadAccounts() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            _ = try await ModelStore.instance.setSessions(Client.sessions) // load session from local keychain
        } catch {
            logger.error("\(error)")
        }
    }
}



extension ModelStore {
    func setSessions(_ sessions: [Session]) async throws -> [Account.PersistentID] {
        checkBackgroundThread()
        do {
            // inserts
            let inserts: [Account] = try sessions.map(modelContext._insertAccount(session:))
            
            // others: not have session
            let otherModelIDs = try modelContext._fetchAccountNotIn(Array(inserts), in: .google).map(\.modelID)
            await otherModelIDs.forEachTask { @MainActor in $0.session = nil }
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
