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
import SwiftUI
import AuthenticationServices

// MARK: Feature: Accounts - Sign In

extension AppModel {
    
    // Feature: Accounts - Sign In
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
            
            switch platform {
            case .microsoft:
                _ = try await ModelStore.shared.addSession(.microsoft(MicrosoftClient.shared.signIn()))
            case .google:
                _ = try await ModelStore.shared.addSession(   .google(   GoogleClient.shared.signIn()))
            default: fatalError() // TODO: Throw Error
            }
        } catch {
            logger.error("\(error)")
        }
    }
    
}


