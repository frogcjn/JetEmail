//
//  moveAccounts.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import Foundation

// MARK: Feature: Accounts - Move Accounts

extension AppModel {
    
    // @MainActor
    func moveAccounts(_ accounts: [Account], fromOffsets source: IndexSet, toOffset destination: Int) async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            _ = try await BackgroundModelActor.shared.moveAccounts(appModel: self, ids: accounts.map(\.persistentID), fromOffsets: source, toOffset: destination)
        } catch {
            logger.error("\(error)")
        }
    }
}
