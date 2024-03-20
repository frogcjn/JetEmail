//
//  LoadAccounts.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

// MARK: Feature: Accounts - Load Accounts

extension AppModel {
    
    @MainActor // for isBusy
    func loadAccounts() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            let sessions = try await clients.sessions                                     // Clients
            let (_, deletes) =  try await modelStore.setAccounts(sessions.map(\.account)) // ModelStore
            try await deletes.forEachTask { _ = await $0.removeSession() }                // Sessions
        } catch {
            logger.error("\(error)")
        }
    }
}
