//
//  SignIn.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

// MARK: Feature: Accounts - Sign In

extension AppModel {
    
    // Feature: Accounts - Sign In
    // @MainActor // for isAppModelBusy
    func signIn(platform: Platform) async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            try await _signIn(platform: platform)
        } catch {
            logger.error("\(error)")
        }
    }
}

