//
//  loadBody.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

// MARK: Feature: Message - Load Body

import JetEmailData // for MessageID

extension AppModel {
    
    @MainActor // for .isBusy
    func loadBody(messageID: MessageID, accountID: AccountID) async {
        guard !messageID.isLoadingBody else { return }
        messageID.isLoadingBody = true
        defer { messageID.isLoadingBody = false }
        
        do {
            guard let session = try await accountID.refreshSession else { return }   // get Session
            let resource = try await    session.messageBody(messageID: messageID) // Session
                       _ = try await modelStore.setMessage    ( resource: resource ) // ModelStore
        } catch {
            logger.error("\(error)")
        }
    }
}
