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
        guard !isBusy else { return }
        isBusy = true
        print("loadBody start")

        defer { 
            isBusy = false
            print("loadBody end")
        }
        do {
            let message = item
            let account = message.mailFolder.account
            guard let session = try await account.refreshedIfExpiredSession else { return }
            
            switch session {
            case .microsoft(let session):
                guard case .microsoft(let messageID) = message.modelID else { return }
                
                let microsoftMessage = try await session.getMessage(microsoftID: messageID) // load from MSAL
                _ = try await BackgroundModelActor.shared.setMessage(microsoft: microsoftMessage, to: item.modelID) // MSAL to SwiftData
                
            case .google(let session):
                guard case .google(let messageID) = message.modelID else { return }
                var googleMessage = try await session.getMessage(id: messageID, format: .full)
                googleMessage.raw = try await session.getMessage(id: messageID, format: .raw).raw
                _ = try await BackgroundModelActor.shared.setMessage(google: googleMessage, to: item.modelID) // MSAL to SwiftData
            }
        } catch {
            logger.error("\(error)")
        }
    }
}
