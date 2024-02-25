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
            switch platform {
            case .microsoft: _ = try await BackgroundModelActor.shared.addSession(.microsoft(microsoftClient.signIn()))
            case .google:    _ = try await BackgroundModelActor.shared.addSession(   .google(   googleClient.signIn()))
            }
        } catch {
            logger.error("\(error)")
        }
    }
}

extension Microsoft.Client {
    func signIn() async throws -> Microsoft.Session {
        try await _msalSignIn().lazySession
    }
}

extension Google.Client {
    func signIn() async throws -> Google.Session {
        try await _gtmSignIn().insertTo(keychain: keychain).lazySession
    }
}
