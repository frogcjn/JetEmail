//
//  moveAccounts.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import Foundation
import JetEmail_Foundation
import JetEmail_Data

// MARK: Feature: Accounts - Move Accounts

extension AppModel {
    
    @MainActor // for isBusy
    func moveAccounts(_ accounts: [Account], fromOffsets source: IndexSet, toOffset destination: Int) async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            try await _moveAccounts(accounts.map(\.resourceID), fromOffsets: source, toOffset: destination)
        } catch {
            logger.error("\(error)")
        }
    }
    
    // @BackgroundActor
    private func _moveAccounts(_ accounts: [AccountID], fromOffsets source: IndexSet, toOffset destination: Int) async throws {
        checkBackgroundThread()
        _ = try await ModelStore.shared.moveAccounts(appModel: self, ids: accounts, fromOffsets: source, toOffset: destination)
    }
}
