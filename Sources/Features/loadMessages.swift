//
//  loadMessages.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

// MARK: Feature: Account - Load Messages

import JetEmailID
import JetEmailPlatform

extension AppModel {
        
    @MainActor // for .isBusy
    func loadMessages(mailFolderID: MailFolderID, accountID: AccountID) async {
        guard !mailFolderID.loadingMessageState.isLoading else { return }
        mailFolderID.loadingMessageState = .start
        defer { mailFolderID.loadingMessageState = .none }
        
        do {
            guard let session = try await accountID.refreshSession else { return }                               // get Session
            try await session.loadMessagesProgressing(mailFolderID: mailFolderID, modelStore: ModelStore.shared) // Session, ModelStore
        } catch {
            logger.error("\(error)")
        }
    }
}
