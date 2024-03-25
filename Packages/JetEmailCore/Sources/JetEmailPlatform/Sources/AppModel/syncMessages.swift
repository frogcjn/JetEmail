//
//  loadMessages.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

// MARK: Feature: MailFolder - Load Messages

import JetEmailData // for MailFolderID

public extension AppModel {
        
    @MainActor // for .isBusy
    func syncMessages(mailFolderID: MailFolderID) async {
        guard !mailFolderID.loadingMessageState.isLoading else { return }
        mailFolderID.loadingMessageState = .start
        defer { mailFolderID.loadingMessageState = .none }
        
        do {
            let session = try await mailFolderID.accountID.refreshSession            // get Session
            try await session.syncMessages(mailFolderID: mailFolderID, modelStore: modelStore) // Session, ModelStore
        } catch {
            logger.error("\(error)")
        }
    }
}
