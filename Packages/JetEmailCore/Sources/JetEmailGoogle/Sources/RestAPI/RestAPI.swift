//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/24/24.
//

@preconcurrency import GoogleAPIClientForREST_Gmail // @preconcurrency for GTLRGmail_Message, GTLRGmail_ListMessagesResponse

import class JetEmailFoundation.Tree // for Tree
import class JetEmailFoundation.TreeNode
import       JetEmailData

extension GoogleSession : RestAPIProtocol {
    
    // MARK: - Account-MailFolders
    
    public func rootMailFolder() -> GoogleMailFolder {
        .all(accountID: account.id)
    }
    
    public func loadMailFoldersUnderRoot(root: GoogleMailFolder, modelStore: ModelStore) async throws {
        let tree = try await _mailFolderTree(rootElement: root)
        var queue: [TreeNode<GoogleMailFolder>] = [tree.root]
        while !queue.isEmpty {
            let                node = queue.removeFirst()
            let       childrenNodes = node.children
            let childrenMailFolders = node.children.map(\.element)
            let    parentMailFolder = node.element
            
            _ = try await modelStore.setChildrenMailFolders(resources: childrenMailFolders, parentID: parentMailFolder.generalID, accountID: account.generalID)
            
            queue.append(contentsOf: childrenNodes)
        }
    }

    public func renameMailFolder(_ displayName: String, for folder: GoogleMailFolderID) async throws -> GoogleMailFolder {
        .init(id: .init(accountID: account.id, innerID: "empty"), _inner: .init(id: "empty"))
    }

    // MARK: - MailFolder-Messages
    
    public func syncMessages(mailFolderID: GoogleMailFolderID, modelStore: ModelStore) async throws {
        let checkingPageSize: Int? = 100 // max: 500, default: 100
        
        // loadingBatchSize: max: 100
        // loadingMaxTaskCount: max: Int.max. bestMax: 2. If more than 2, some message will drop in Swift async stream.
        let loading = (batchSize: 50, maxTaskCount: 2)
        
        var newMessageIDs = [GoogleMessageID]()
        let (idEstimateCount, idStream) = try await _checkMessageIDs(mailFolderID: mailFolderID, pageSize: checkingPageSize)
        for try await ids in idStream {
            newMessageIDs.append(contentsOf: ids)
            await MainActor.run { [value = newMessageIDs.count] in
                mailFolderID.generalID.loadingMessageState = .checking(value: value, total: max(value, idEstimateCount))
            }
        }
        
        // remove
        let shouldInsertMessageIDs = try await modelStore.setMessagesDeletePart(newMessageIDs: newMessageIDs.map { $0.generalID }, mailFolderID: mailFolderID.generalID).map { try $0.element.google }
        
        guard !shouldInsertMessageIDs.isEmpty else { return }
        let stream = try await _getMessagesStream(mailFolderID: mailFolderID, messageIDs: shouldInsertMessageIDs, batchSize: loading.batchSize, maxTaskCount: loading.maxTaskCount)
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
    
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/modify
    public func moveMessage(messageID: GoogleMessageID, fromID: GoogleMailFolderID, toID: GoogleMailFolderID) async throws -> GoogleMessage {
        let accountID = account.id.innerID
        let messageID = messageID.innerID
        
        let request = GTLRGmail_ModifyMessageRequest()
        request.removeLabelIds =  [fromID.innerID]
        request.addLabelIds = [toID.innerID]
        
        let query = GTLRGmailQuery_UsersMessagesModify.query(withObject: request, userId: accountID, identifier: messageID)
        
        return try await service.execute(query, responseType: GTLRGmail_Message.self).messageInner.outer(accountID: account.id, raw: nil)
    }
    
    
    public func messageBody(messageID: GoogleMessageID) async throws -> GoogleMessage {
        let full = try await _getMessage(messageID: messageID, format: .full)
        let raw  = try await _getMessage(messageID: messageID, format: .raw).raw
        let message = try full.outer(accountID: account.id, raw: raw)
        return message
    }
}
