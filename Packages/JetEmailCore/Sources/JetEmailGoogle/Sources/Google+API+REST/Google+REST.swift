//
//  Google+Request.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

import Foundation
import SwiftData
import JetEmailData
import JetEmailFoundation // for Tree
@preconcurrency import GoogleAPIClientForREST_Gmail

// MARK: - Microsoft.Context: Account-MailFolders API

public extension GoogleSession {
    
    // MARK: - Account-MailFolders
    
    func rootMailFolder() -> GoogleMailFolder {
        .all(accountID: account.id)
    }
    
    func loadMailFoldersUnderRoot(root: GoogleMailFolder, modelStore: ModelStore) async throws {
        let tree = try await mailFolderTree(rootElement: root)
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
    
    // MARK: - MailFolder-Messages
    func loadMessages(mailFolderID: GoogleMailFolderID, modelStore: ModelStore) async throws {
        
        let newMessageIDs: [MessageID] = try await getMessagesID(in: mailFolderID).map { $0.generalID }
        
        // remove
        let shouldInsertMessageIDs = try await modelStore.setMessagesDeletePart(newMessageIDs: newMessageIDs, mailFolderID: mailFolderID.generalID).compactMap(\.element.platformCase?.google)
        
        
        guard !shouldInsertMessageIDs.isEmpty else { return }
        // do {
        let stream = try await getMessagesStream(messageIDs: shouldInsertMessageIDs, format: .metadata)
        //}
        /* catch let error as URLError where error.code == .badURL {
         (total, stream) = try await session.getMessagesStream(id: innerID)
         }*/
        let total = newMessageIDs.count
        var value = total - shouldInsertMessageIDs.count
        
        await MainActor.run { [value] in
            mailFolderID.generalID.loadingMessageState = .loading(value: value, total: total)
        }
        for try await messages in stream {
            value += try await modelStore.setMessagesInsertPart(resources: messages, mailFolderID: mailFolderID.generalID).count // MSAL to SwiftData
            await MainActor.run { [value] in
                mailFolderID.generalID.loadingMessageState = .loading(value: value, total: total)
            }
        }
    }
    
    /*@MainActor // for id.loadingMessageState
    func loadMessagesMain(mailFolderID: GoogleMailFolderID, modelContext: ModelContext) async throws {
        
        let newMessageIDs: [MessageID] = try await getMessagesID(in: mailFolderID).map { $0.generalID }
        
        // remove
        let shouldInsertMessageIDs = try await modelContext.setMessagesDeletePart(newMessageIDs: newMessageIDs, mailFolderID: mailFolderID.generalID).compactMap(\.element.platformCase?.google)
        
        
        if !shouldInsertMessageIDs.isEmpty  {
            // do {
            let stream = try await getMessagesStream(ids: shouldInsertMessageIDs, format: .metadata)
            //}
            /* catch let error as URLError where error.code == .badURL {
             (total, stream) = try await session.getMessagesStream(id: innerID)
             }*/
            let total = newMessageIDs.count
            var value = total - shouldInsertMessageIDs.count
            
            mailFolderID.generalID.loadingMessageState = .loading(value: value, total: total)
            for try await messages in stream {
                value += try modelContext.setMessagesInsertPart(resources: messages, mailFolderID: mailFolderID.generalID).count // MSAL to SwiftData
                mailFolderID.generalID.loadingMessageState = .loading(value: value, total: total)
            }
        }
    }*/
    
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/modify
    func moveMessage(messageID: GoogleMessageID, fromID: GoogleMailFolderID, toID: GoogleMailFolderID) async throws -> GoogleMessage {
        try await service.execute(GTLRGmail_Message.self) {
            let accountID = account.id.innerID
            let messageID = messageID.innerID
            
            let request = GTLRGmail_ModifyMessageRequest()
            request.removeLabelIds =  [fromID.innerID]
            request.addLabelIds = [toID.innerID]
            
            let query = GTLRGmailQuery_UsersMessagesModify.query(withObject: request, userId: accountID, identifier: messageID)
            return query
        }.messageInner.with(accountID: account.id)
    }
    
    // MARK: - Message

    
    func messageBody(messageID: GoogleMessageID) async throws -> GoogleMessage {
        let full = try await getMessage(id: messageID, format: .full)
        let raw  = try await getMessage(id: messageID, format: .raw).raw
        let message = try full.with(accountID: account.id, raw: raw)
        return message
    }
    
    /*func getMessages(ids: [GoogleMessageID]) async throws -> [GoogleMessage] {
        return try await getMessages(ids: ids, format: .metadata).map { try $0.with(accountID: account.id) }
    }*/
    

    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/get
    /*private func getMessages(ids: [GoogleMessageID], fields: String? = nil, format: GetMessageFormat) async throws -> [GoogleMessageInner] {
        if ids.count > 100 {
            let first100 = ids.prefix(100)
            let rest = ids.dropFirst(100)
            let result = try await getMessages(ids: Array(first100), fields: fields, format: format) + getMessages(ids: Array(rest), fields: fields, format: format)
            return result
        }
        
        let batchResult = try await service.execute(GTLRBatchResult.self) {
            GTLRBatchQuery(queries: ids.map { [accountID = account.id.innerID] in
                let query = GTLRGmailQuery_UsersMessagesGet.query(withUserId: accountID, identifier: $0.innerID)
                query.fields = fields
                query.format = format.rawValue
                return query
            })
        }
        
        return if let messagesDict = batchResult.successes as? [String: GTLRGmail_Message] {
            try messagesDict.values.map { try $0.messageInner }
        } else {
            fatalError()
        }
    }*/

    
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/get
    /*func getMessages(mailFolderID: MailFolder.ID) async throws -> [Message] {
        try await getItems("mailFolders", "\(microsoftID)", "messages", queryItems: [
            .orderBy(name: "receivedDateTime", .descending),
            .select(
                "id",
                "subject",
                "createdDateTime",
                "lastModifiedDateTime",
                "receivedDateTime",
                "sentDateTime",
                "sender",
                "from",
                "toRecipients",
                "replyTo",
                "ccRecipients",
                "bccRecipients",
                "bodyPreview"
            )
        ])
    }*/
}

// MARK: - FilePrivate Functions

fileprivate extension GoogleSession {
    // google mailfolder path-name algrithm
    func mailFolderTree(rootElement: GoogleMailFolder) async throws -> Tree<GoogleMailFolder> {
        let tree = Tree(rootElement: rootElement)
        
        // copy name to path
        let elements = try await getMailFolders()
        var pathToNode = Dictionary(uniqueKeysWithValues: elements.compactMap { element in element.path.map { (path: $0, node: TreeNode(element: element)) } })
        // var pathToNode = [String : TreeNode<GoogleMailFolder>]()
        pathToNode[""] = tree.root
            
        for (key: path, value: node) in pathToNode.sorted(using: KeyPathComparator(\.key)) {
            if node.element.id == tree.root.element.id { continue }
            let components = path.components(separatedBy: "/")
            
            var (parent, processedName) = (tree.root, path)
            for lastComponentCount in 1..<components.count {
                let previousComponents = components.dropLast(lastComponentCount).joined(separator: "/") // try name component count
                let lastComponent = components.suffix(lastComponentCount).joined(separator: "/")
                if let node = pathToNode[previousComponents] { // find parent
                    (parent, processedName) = (node, lastComponent)
                    break
                }
            }
            (node.parent, node.element) = (parent, node.element.with(processedName: processedName))
            parent.children.append(node)
        }
        
        return tree
    }
    
    private func getMailFolders() async throws -> [GoogleMailFolder] {
        let response = try await service.execute(GTLRGmail_ListLabelsResponse.self) {
            GTLRGmailQuery_UsersLabelsList.query(withUserId: account.id.innerID)
        }
        guard let labels = response.labels else { throw GmailApiError.failedToParseData(response) }
        return try labels.map { try $0.mailFolder.with(accountID: account.id) }
            //.sorted { "\($0.type?.rawValue)" > "\($1.type?.rawValue)" }
            //.filter { $0.type == .user || $0.path == "SPAM" || $0.path == "INBOX"}
            //.sorted(using: KeyPathComparator(\MailFolder.name))
    }
}

fileprivate extension GoogleSession {
    // pageSize => $top: 1-1000, default: 1000
    func getMessagesID(in mailFolderID: GoogleMailFolderID, pageSize: Int? = 1000) async throws -> [GoogleMessageID] {
        let ids: [GoogleMessageID] = try await getFolderMessageIDs(id: mailFolderID).map { .init(accountID: mailFolderID.accountID,  innerID: $0.id) }
        return ids
    }
    
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/list
    private func getFolderMessageIDs(id: GoogleMailFolderID) async throws -> [GoogleMessageInner] {
        let response = try await service.execute(GTLRGmail_ListMessagesResponse.self) {
            let query = GTLRGmailQuery_UsersMessagesList.query(withUserId: account.id.innerID)
            query.labelIds = [id.innerID]
            query.maxResults = 500
            return query
        }
        
        guard let messages = response.messages else { throw GmailApiError.failedToParseData(response) }
        return try messages.map{ try $0.messageInner }
    }
    
    func getMessagesStream(messageIDs: [GoogleMessageID], fields: String? = nil, format: GetMessageFormat) async throws -> AsyncThrowingStream<[GoogleMessage], Error> {
        .init { continuation in Task { [service] in
            do {
                let chunkSize = 10
                var rest = messageIDs[...]
                
                while rest.count > 0 {
                    let chunk = rest.prefix(chunkSize)
                    rest = rest.dropFirst(chunkSize)
                    
                    let batchResult = try await service.execute(GTLRBatchResult.self) {
                        GTLRBatchQuery(queries: chunk.map { [accountID = account.id.innerID] in
                            let query = GTLRGmailQuery_UsersMessagesGet.query(withUserId: accountID, identifier: $0.innerID)
                            query.fields = fields
                            query.format = format.rawValue
                            return query
                        })
                    }
                    
                    guard let messagesDict = batchResult.successes as? [String: GTLRGmail_Message] else { fatalError() } // TODO: fatalError replace with error
                    let result: [GoogleMessage] = try messagesDict.values.map { try $0.messageInner.with(accountID: account.id) }
                    
                    continuation.yield(result)
                    await Task.yield()
                }
                
                continuation.finish()
            } catch {
                continuation.finish(throwing: error)
            }
        } }
    }
}

fileprivate extension GoogleSession {
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/get
    func getMessage(id: GoogleMessageID, fields: String? = nil, format: GetMessageFormat) async throws -> GoogleMessageInner {
        try await service.execute(GTLRGmail_Message.self) {
            let query = GTLRGmailQuery_UsersMessagesGet.query(withUserId: account.id.innerID, identifier: id.innerID)
            query.fields = fields
            query.format = format.rawValue
            return query
        }.messageInner
        
        /*try await getItem("messages", "\(microsoftID)", queryItems: [
         .select(
         "id",
         "subject",
         "createdDateTime",
         "lastModifiedDateTime",
         "receivedDateTime",
         "sentDateTime",
         "sender",
         "from",
         "toRecipients",
         "replyTo",
         "ccRecipients",
         "bccRecipients",
         "bodyPreview",
         "body"
         // "uniqueBody"
         )
         ])*/
    }
}


// MARK: - Others

fileprivate extension GoogleSession {
    var service: GTLRGmailService {
        let service = GTLRGmailService()
        service.authorizer = _gtmSession
        service.shouldFetchNextPages = true
        return service
    }
}

fileprivate enum GetMessageFormat: String, Sendable {
    case raw
    case full
    case metadata
    case minimal
}

fileprivate extension GTLRGmailService {
    func execute<Q: GTLRQueryProtocol, T: NSObject & Sendable>( _ type: T.Type = T.self, query: () -> Q) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            executeQuery(query()) { (ticket: GTLRServiceTicket, object: Any?, error: Error?) in
                if let error { return continuation.resume(throwing: GmailApiError.convert(from: error as NSError)) }
                guard let result = object as? T else { return continuation.resume(throwing: AppErr.cast(T.description())) }
                Task {
                    continuation.resume(returning: result)
                }
            }
        }
    }
}

fileprivate extension GoogleMessageInner {
    func with(accountID: GoogleAccountID, raw: Data? = nil) throws -> GoogleMessage {
        try .init(id: .init(accountID: accountID, innerID: id), inner: self, raw: raw)
    }
}

