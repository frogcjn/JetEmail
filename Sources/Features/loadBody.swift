//
//  loadBody.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import JetEmail_Foundation

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
            guard let session = try await item.mailFolder.account.modelID.refreshedIfExpiredSession else { return }
            try await _loadBody(messageModelID: item.modelID, session: session)
        } catch {
            logger.error("\(error)")
        }
    }
}


fileprivate func _loadBody(messageModelID: Message.ModelID, session: Session) async throws {
    checkBackgroundThread()
    switch session {
    case .microsoft(let session):
        guard case .microsoft(let messageID) = messageModelID else { return }
        
        async let microsoftMessage = session.getMessage(microsoftID: messageID) // load from MSAL
        _ = try await ModelStore.instance.setMessage(microsoft: microsoftMessage, to: messageModelID) // MSAL to SwiftData
        
    case .google(let session):
        guard case .google(let messageID) = messageModelID else { return }
        var googleMessage = try await session.getMessage(id: messageID, format: .full)
        googleMessage.raw = try await session.getMessage(id: messageID, format: .raw).raw
        _ = try await ModelStore.instance.setMessage(google: googleMessage, to: messageModelID) // MSAL to SwiftData
    }
}
