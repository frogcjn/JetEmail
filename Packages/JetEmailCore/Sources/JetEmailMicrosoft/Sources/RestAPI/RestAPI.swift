//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/24/24.
//

import JetEmailData

extension MicrosoftSession : RestAPIProtocol {
    
    // MARK: - Account-MailFolders
    
    public func rootMailFolder() async throws -> MicrosoftMailFolder {
        try await _getMailFolder(systemName: .msgFolderRoot)
    }
    
    public func loadMailFoldersUnderRoot(root: MicrosoftMailFolder, modelStore: ModelStore) async throws {
        var queue: [MicrosoftMailFolderID] = [root.id]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            let childrenMailFolders = try await _getChildFolders(mailFolderID: current)
            let children = try await modelStore.setChildrenMailFolders(resources: childrenMailFolders, parentID: current.generalID, accountID: account.generalID).map { try $0.microsoft }
            queue.append(contentsOf: children)
        }
    }

    /// Rename mail folder with new name.
    /// 
    /// - Seealso: https://learn.microsoft.com/en-us/graph/api/mailfolder-update
    /// - Parameters:
    ///   - displayName: The new name for mail folder.
    ///   - folder: The ID of mail folder which is renamed.
    /// - Returns: A mail folder value with the give `displayName`.
    public func renameMailFolder(_ displayName: String, for folder: MicrosoftMailFolderID) async throws -> MicrosoftMailFolder {
        struct RenameFolderRequestBody : Encodable {
            let displayName: String
        }
        let inner = try await _patchItem(
            url: client.endpointURL.appending(pathComponents: "me", "mailFolders", folder.innerID),
            body: RenameFolderRequestBody(displayName: displayName),
            responseType: _MicrosoftAPI.MicrosoftMailFolderInner.self
        )
        let idToSystemName = try await _idToSystemName
        return inner.outer(accountID: account.id, _idToSystemName: idToSystemName)
    }

    // MARK: - MailFolder-Messages
    
    public func syncMessages(mailFolderID: MicrosoftMailFolderID, modelStore: ModelStore) async throws {
        let checkingPageSize: Int? = 100 // max: 1000, default: 100
        let loadingBatchSize: Int  =  10 // max: 20
        
        // checking
        var newMessageIDs = [MicrosoftMessageID]()
        let (count, idStream) = try await _checkMessageIDs(mailFolderID: mailFolderID, pageSize: checkingPageSize)
        for try await ids in idStream {
            newMessageIDs.append(contentsOf: ids)
            await MainActor.run { [value = newMessageIDs.count] in
                mailFolderID.generalID.loadingMessageState = .checking(value: value, total: count)
            }
        }

        // remove
        let shouldInsertMessageIDs = try await modelStore.setMessagesDeletePart(newMessageIDs: newMessageIDs.map(\.generalID), mailFolderID: mailFolderID.generalID).map { try $0.element.microsoft }
        
        // loading
        guard !shouldInsertMessageIDs.isEmpty else { return }
        let stream = try await _loadMessagesStream(mailFolderID: mailFolderID, messageIDs: shouldInsertMessageIDs, batchSize: loadingBatchSize)
        let total = newMessageIDs.count
        var value = total - shouldInsertMessageIDs.count
        for try await messages in stream {
            value += try await modelStore.insertMessages(sources: messages, mailFolderID: mailFolderID.generalID).count // MSAL to SwiftData
            await MainActor.run { [value] in
                mailFolderID.generalID.loadingMessageState = .loading(value: value, total: total)
            }
        }
    }
        
    // MARK: - Message

    // https://learn.microsoft.com/en-us/graph/api/message-move
    public func moveMessage(messageID: MicrosoftMessageID, fromID: MicrosoftMailFolderID, toID: MicrosoftMailFolderID) async throws -> MicrosoftMessage {
        struct MessageMoveRequestBody : Encodable {
            let destinationId: String
        }
        return try await _postItem(
            url: client.endpointURL.appending(pathComponents: "me", "mailFolders", fromID.innerID, "messages", messageID.innerID, "move"),
            body: MessageMoveRequestBody(destinationId: toID.innerID),
            responseType: _MicrosoftAPI.MicrosoftMessageInner.self).outer(accountID: account.id, raw: nil)
    }
    
    
    // https://learn.microsoft.com/en-us/graph/api/message-get
    public func messageBody(messageID: MicrosoftMessageID) async throws -> MicrosoftMessage {
        let inner: _MicrosoftAPI.MicrosoftMessageInner = try await _getValue(
            url: client.endpointURL.appending(pathComponents: "me", "messages", messageID.innerID, queryItems: .selectForMessageBody)
        )
        let raw = try await _getMultipartData(url: client.endpointURL.appending(pathComponents: "me", "messages", messageID.innerID, "$value"))
        return inner.outer(accountID: account.id, raw: raw)
    }
}

