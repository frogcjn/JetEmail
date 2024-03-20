//
//  moveAccounts.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

// MARK: Feature: Accounts - Move Accounts

import struct Foundation.IndexSet
import JetEmailID
import JetEmailPlatform

extension AppModel {
    
    @MainActor // for isBusy
    func moveAccounts(accountIDs: [AccountID], fromOffsets source: IndexSet, toOffset destination: Int) async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            _ = try await ModelStore.shared.moveAccounts(accountIDs: accountIDs, fromOffsets: source, toOffset: destination) // ModelStore
        } catch {
            logger.error("\(error)")
        }
    }
}
