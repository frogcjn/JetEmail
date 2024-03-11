//
//  SignIn.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

import JetEmailID
import JetEmailGoogle
import JetEmailMicrosoft
import JetEmailData

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
    
    // @BackgroundActor
    private func _signIn(platform: Platform) async throws {
        switch platform {
        case .microsoft: _ = try await ModelStore.shared.addSession(.microsoft(MicrosoftClient.shared.signIn()))
        case .google:    _ = try await ModelStore.shared.addSession(   .google(   GoogleClient.shared.signIn()))
        default: fatalError() // TODO: Throw Error
        }
    }
}
