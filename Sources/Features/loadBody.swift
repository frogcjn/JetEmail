//
//  loadBody.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import JetEmail_Foundation
import JetEmail_Data
import Google

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
            guard let session = try await item.mailFolder.account.id.refreshSession else { return }
            try await _loadBody(messageID: item.id, session: session)
        } catch {
            logger.error("\(error)")
        }
    }
}


fileprivate func _loadBody(messageID: Message.ID, session: JetEmail_Data.Session) async throws {
    checkBackgroundThread()
    switch session {
    case .microsoft(let session):
        let microsoftMessageID = messageID.microsoft!
        
        async let microsoftMessage = session.getMessage(id: microsoftMessageID) // load from MSAL
        _ = try await ModelStore.instance.setMessage(microsoft: .init(session, data: microsoftMessage), to: messageID) // MSAL to SwiftData
        
    case .google(let session):
        let googleMessageID = messageID.google!
        var googleMessage = try await session.getMessage(id: googleMessageID, format: .full)
        googleMessage.raw = try await session.getMessage(id: googleMessageID, format: .raw).raw
        _ = try await ModelStore.instance.setMessage(google: .init(session, data: googleMessage), to: messageID) // MSAL to SwiftData
    }
}
