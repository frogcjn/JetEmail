//
//  loadMessages.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import JetEmail_Foundation
import JetEmail_Data
import Microsoft
import Foundation

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
                try await loadMessagesProgressing(id: mailFolder.id, session: session)
            case .google(let session): guard let platformID = mailFolder.id.google else { return }
                async let messages = session.getMessages(id: platformID)
                _ = try await ModelStore.shared.setMessages(googles: messages, in: mailFolder.id) // MSAL to SwiftData
                // _ = try await BackgroundModelActor.instance.setMessages
                // let messages = try await session.getMessages
            }
            
        } catch {
            logger.error("\(error)")
        }
    }
}

@MainActor
private func loadMessagesProgressing(id: JetEmail_Data.MailFolder.ID, session: Microsoft.Session) async throws {
    let newMessageIDs: [JetEmail_Data.Message.ID] = try await session.getMessagesID(in: id.microsoft!).map { $0.general }
    
    // remove
    let firstIndexToLoad = try await ModelStore.shared.setMessagesDeletePart(newMessageIDs: newMessageIDs, in: id)
    
    
    let (total, stream): (total: Int, stream: AsyncThrowingStream<[MicrosoftMessage], Error>)
    
    if let firstIndexToLoad {
       // do {
        (total, stream) = try await session.getMessagesStream(id: id.microsoft!, skip: firstIndexToLoad)
        //}
        /* catch let error as URLError where error.code == .badURL {
            (total, stream) = try await session.getMessagesStream(id: innerID)
        }*/
        var value = firstIndexToLoad
        id.loadingMessageState = .loading(value: value, total: total)
        for try await messages in stream {
            value += try await ModelStore.shared.setMessagesInsertPart(microsofts: messages, in: id).count // MSAL to SwiftData
            id.loadingMessageState = .loading(value: value, total: total)
        }
    }
}
