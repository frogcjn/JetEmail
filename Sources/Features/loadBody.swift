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
            try await _loadBody()
        } catch {
            logger.error("\(error)")
        }
    }
    
    @BackgroundActor
    func _loadBody() async throws {
        let message = item
        let account = message.mailFolder.account

        guard let session = try await account.refreshedIfExpiredSession else { return }
        
        switch session {
        case .microsoft(let session):
            guard case .microsoft(let messageID) = message.modelID else { return }
            
            let microsoftMessage = try await session.getMessage(microsoftID: messageID) // load from MSAL
            _ = try await BackgroundModelActor.shared.setMessage(microsoft: microsoftMessage, to: message.modelID) // MSAL to SwiftData
            
        case .google(let session):
            guard case .google(let messageID) = message.modelID else { return }
            var googleMessage = try await session.getMessage(id: messageID, format: .full)
            googleMessage.raw = try await session.getMessage(id: messageID, format: .raw).raw
            _ = try await BackgroundModelActor.shared.setMessage(google: googleMessage, to: message.modelID) // MSAL to SwiftData
        }
    }
}

