//
//  loadMessages.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import JetEmail_Foundation

// MARK: Feature: Account - Load Messages

extension AppItemModel<MailFolder> {
    
    @MainActor
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
            let mailFolder = item
            let account = mailFolder.account
            guard let session = try await account.modelID.refreshedIfExpiredSession else { return }
            try await _loadMessages(mailFolderPersistentID: mailFolder.persistentID, mailFolderModelID: mailFolder.modelID, session: session)
        } catch {
            logger.error("\(error)")
        }
    }
    

}

// @BackgroundActor
private func _loadMessages(mailFolderPersistentID: MailFolder.PersistentID, mailFolderModelID: MailFolder.ModelID, session: Session) async throws {
    checkBackgroundThread()
    switch session {
    case .microsoft(let session):
        guard case .microsoft(let mailFolderID) = mailFolderModelID else { return }
        async let messages = session.getMessages(microsoftID: mailFolderID) // load from MSAL
        _ = try await ModelStore.instance.setMessages(microsofts: messages, in: mailFolderPersistentID) // MSAL to SwiftData
    case .google(let session):
        guard case .google(let mailFolderID) = mailFolderModelID else { return }
        async let messages = session.getMessages(mailFolderID: mailFolderID)
        _ = try await ModelStore.instance.setMessages(googles: messages, in: mailFolderPersistentID) // MSAL to SwiftData
        // _ = try await BackgroundModelActor.instance.setMessages
        // let messages = try await session.getMessages
    }
}
