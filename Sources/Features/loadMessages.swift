//
//  loadMessages.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import JetEmail_Foundation

// MARK: Feature: Account - Load Messages

extension AppItemModel<MailFolder> {
    
    var isBusy: Bool {
        get { item.isBusy }
        set { item.isBusy = newValue }
    }
    
    @MainActor // for .isBusy
    func loadMessages() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            try await _loadMessages()
        } catch {
            logger.error("\(error)")
        }
    }
    
    @BackgroundActor
    private func _loadMessages() async throws {
        let mailFolder = item
        let account = mailFolder.account
        guard let session = try await account.refreshedIfExpiredSession else { return }
        switch session {
        case .microsoft(let session):
            guard case .microsoft(let mailFolderID) = mailFolder.modelID else { return }
            let messages = try await session.getMessages(microsoftID: mailFolderID) // load from MSAL
            _ = try await BackgroundModelActor.shared.setMessages(microsofts: messages, in: mailFolder.persistentID) // MSAL to SwiftData
        case .google(let session):
            guard case .google(let mailFolderID) = mailFolder.modelID else { return }
            let messages = try await session.getMessages(mailFolderID: mailFolderID)
            _ = try await BackgroundModelActor.shared.setMessages(googles: messages, in: mailFolder.persistentID) // MSAL to SwiftData
            // _ = try await BackgroundModelActor.shared.setMessages
            // let messages = try await session.getMessages
        }
    }
}
