//
//  loadMessages.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import JetEmailFoundation
import JetEmailData
import JetEmailMicrosoft
import JetEmailGoogle
import Foundation
import JetEmailID

// MARK: Feature: Account - Load Messages

extension AppItemModel<MailFolder> {
    
    @MainActor
    var loadingMessageState: MailFolder.LoadingMessageState {
        get { item.resourceID.loadingMessageState }
        set { item.resourceID.loadingMessageState = newValue }
    }
    
    @MainActor // for .isBusy
    func loadMessages() async {
        guard !loadingMessageState.isLoading else { return }
        loadingMessageState = .start
        defer { loadingMessageState = .none }
        
        do {
            let mailFolder = item
            let account = mailFolder.account
            guard let session = try await account.resourceID.refreshSession else { return }
            switch session {
            case .microsoft(let session): try await loadMessagesProgressing(id: mailFolder.resourceID, session: session)
            case .google(let session): try await loadMessagesProgressing(id: mailFolder.resourceID, session: session)
                /*guard let platformID = mailFolder.resourceID.google else { return }
                async let messages = session.getMessages(id: platformID)
                _ = try await ModelStore.shared.setMessages(googles: messages, in: mailFolder.resourceID) // MSAL to SwiftData*/
            }
            
        } catch {
            logger.error("\(error)")
        }
    }
}

@MainActor
private func loadMessagesProgressing(id: MailFolderID, session: MicrosoftSession) async throws {
    let newMessageIDs: [MessageID] = try await session.getMessagesID(in: id.microsoft!).map { $0.general }
    
    // remove
    let firstIndexToLoad = try await ModelStore.shared.setMessagesDeletePart(newMessageIDs: newMessageIDs, in: id).first?.offset
    
    
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
            value += try await ModelStore.shared.setMessagesInsertPart(resources: messages.map(MessageResource.microsoft), mailFolderID: id, accountID: session.generalID).count // MSAL to SwiftData
            id.loadingMessageState = .loading(value: value, total: total)
        }
    }
}

@MainActor
private func loadMessagesProgressing(id: MailFolderID, session: GoogleSession) async throws {
    let newMessageIDs: [MessageID] = try await session.xxxgetMessagesID(in: id.google!).map { $0.general }
    
    // remove
    let shouldInsertMessageIDs = try await ModelStore.shared.setMessagesDeletePart(newMessageIDs: newMessageIDs, in: id).map(\.element.google!)
    
    
    
    if !shouldInsertMessageIDs.isEmpty  {
       // do {
        let stream = try await session.getMessagesStream(ids: shouldInsertMessageIDs, format: .metadata)
        //}
        /* catch let error as URLError where error.code == .badURL {
            (total, stream) = try await session.getMessagesStream(id: innerID)
        }*/
        let total = newMessageIDs.count
        var value = total - shouldInsertMessageIDs.count

        id.loadingMessageState = .loading(value: value, total: total)
        for try await messages in stream {
            value += try await ModelStore.shared.setMessagesInsertPart(resources: messages.map(MessageResource.google), mailFolderID: id, accountID: session.generalID).count // MSAL to SwiftData
            id.loadingMessageState = .loading(value: value, total: total)
        }
    }
}
