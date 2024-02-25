//
//  loadBody.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

// MARK: Feature: Message - Load Body

extension AppItemModel<Message> {
    // @MainActor // for .isBusy
    func loadBody() async {
        /*guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }*/
        
        do {
            let message = item
            let account = message.mailFolder.account
            guard let session = try await account.refreshedIfExpiredSession else { return }
            
            switch session {
            case .microsoft(let session):
                guard case .microsoft(let messageID) = message.modelID else { return }
                
                let microsoftMessage = try await session.getMessageBody(microsoftID: messageID) // load from MSAL
                _ = try await BackgroundModelActor.shared.setMessage(microsoft: microsoftMessage, to: item.modelID) // MSAL to SwiftData
                
            case .google(let session):
                guard case .google(let messageID) = message.modelID else { return }
                let googleMessage = try await session.getMessageBody(id: messageID)
                _ = try await BackgroundModelActor.shared.setMessage(google: googleMessage, to: item.modelID) // MSAL to SwiftData
            }
        } catch {
            logger.error("\(error)")
        }
    }
}
