//
//  SignIn.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

// MARK: Feature: Accounts - Sign In

import JetEmailData // for Platform
import JetEmailPlatform

extension AppModel {
    
    @MainActor // for isBusy, WebAuthenticationSession
    func signIn(platform: Platform, delay: Bool = false) async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        do {
            if delay {
                let clock = SuspendingClock()
                try await clock.sleep(for: .seconds(0.5)) // resolve issue when presenting window with orminent in visionOS, delay <= 0.35s will crash
            }
            
            let session = try await Clients.shared.signIn(platform: platform) // get Session
            _ = try await modelStore.insertAccount(session.account)           // ModelStore
        } catch {
            logger.error("\(error)")
        }
    }
}
