//
//  loadBody.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import JetEmailID
import JetEmailData
import JetEmailGoogle

// MARK: Feature: Message - Load Body

extension AppItemModel<Message> {
    
    @MainActor
    var isBusy: Bool {
        get { item.isBusy }
        set { item.isBusy = newValue }
    }
    
    @MainActor // for .isBusy
    func loadBody() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            guard let session = try await item.mailFolder.account.resourceID.refreshSession else { return }
            try await _loadBody(messageID: item.resourceID, session: session)
        } catch {
            logger.error("\(error)")
        }
    }
}


fileprivate func _loadBody(messageID: MessageID, session: Session) async throws {
    checkBackgroundThread()
    switch session {
    case .microsoft(let session):
        let microsoftMessageID = messageID.microsoft!
        
        async let microsoftMessage = session.getMessageBody(id: microsoftMessageID) // load from MSAL
        _ = try await ModelStore.shared.setMessage(resource: .microsoft(microsoftMessage), to: messageID) // MSAL to SwiftData
        
    case .google(let session):
        let googleMessageID = messageID.google!
        let message = try await session.getMessageBody(id: googleMessageID)
        _ = try await ModelStore.shared.setMessage(resource: .google(message), to: messageID) // MSAL to SwiftData
    }
}
