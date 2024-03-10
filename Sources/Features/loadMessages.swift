//
//  loadMessages.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import JetEmail_Foundation
import JetEmail_Data
import Microsoft

// MARK: Feature: Account - Load Messages

extension AppItemModel<JetEmail_Data.MailFolder> {
    
    @MainActor
    var loadingMessageState: JetEmail_Data.MailFolder.LoadingMessageState {
        get { item.id.loadingMessageState }
        set { item.id.loadingMessageState = newValue }
    }
    
    @MainActor // for .isBusy
    func loadMessages() async {
        guard !loadingMessageState.isLoading else { return }
        loadingMessageState = .start
        defer { loadingMessageState = .none }
        
        do {
            let mailFolder = item
            let account = mailFolder.account
            guard let session = try await account.id.refreshSession else { return }
            switch session {
            case .microsoft(let session):
                guard case .microsoft(let platformID) = mailFolder.id else { return }
                try await loadMessagesProgressing(id: mailFolder.id, innerID: platformID.innerID, session: session)
            case .google(let session): guard case .google(let platformID) = mailFolder.id else { return }
                async let messages = session.getMessages(id: platformID.innerID)
                _ = try await ModelStore.instance.setMessages(googles: messages, in: mailFolder.id) // MSAL to SwiftData
                // _ = try await BackgroundModelActor.instance.setMessages
                // let messages = try await session.getMessages
            }
            
        } catch {
            logger.error("\(error)")
        }
    }
}

@MainActor
private func loadMessagesProgressing(id: JetEmail_Data.MailFolder.ID, innerID: Microsoft.MailFolder.ID, session: Microsoft.Session) async throws {
    var inserts = [JetEmail_Data.Message.ID]()
    
    let (total, stream) = try await session.getMessagesStream(id: innerID)
    id.loadingMessageState = .loading(value: inserts.count, total: total)
    
    for try await messages in stream {
        inserts.append(contentsOf: try await ModelStore.instance.setMessagesInsertPart(microsofts: messages, in: id)) // MSAL to SwiftData
        id.loadingMessageState = .loading(value: inserts.count, total: total)
    }
    _ = try await ModelStore.instance.setMessagesDeletePart(inserts: inserts, in: id)
}
