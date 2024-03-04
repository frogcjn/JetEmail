//
//  SignIn.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

import JetEmail_Foundation
import Google
import Microsoft

// MARK: Feature: Accounts - Sign In

extension AppModel {
    
    // Feature: Accounts - Sign In
    @MainActor // for isBusy
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
    
    @BackgroundActor
    private func _signIn(platform: Platform) async throws {
        switch platform {
        case .microsoft: _ = try await BackgroundModelActor.shared.addSession(.microsoft(microsoftClient.signIn()))
        case .google:    _ = try await BackgroundModelActor.shared.addSession(   .google(   googleClient.signIn()))
        }
    }
}
