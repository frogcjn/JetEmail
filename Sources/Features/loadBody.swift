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
        guard !messageID.isBusy else { return }
        messageID.isBusy = true
        defer { messageID.isBusy = false }
        
        do {
            guard let session = try await accountID.refreshSession else { return }   // get Session
            let resource = try await    session.getMessageBody(messageID: messageID) // Session
                       _ = try await modelStore.setMessage    ( resource: resource ) // ModelStore
        } catch {
            logger.error("\(error)")
        }
    }
}
