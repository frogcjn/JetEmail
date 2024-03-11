//
//  LoadAccounts.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

// MARK: Feature: Accounts - Load Accounts

import JetEmailFoundation
import Foundation

extension AppModel {
    
    @MainActor // for isBusy
    func loadAccounts() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            _ = try await ModelStore.shared.setSessions(Client.sessions) // load session from local keychain
        } catch {
            logger.error("\(error)")
        }
    }
}


