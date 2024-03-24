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
@preconcurrency import GoogleAPIClientForREST_Gmail // @preconcurrency for GTLRGmail_Message, GTLRGmail_ListMessagesResponse

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
    func syncMessages(mailFolderID: GoogleMailFolderID, modelStore: ModelStore) async throws {
        let checkingPageSize: Int? = 100 // max: 500, default: 100
        
        // loadingBatchSize: max: 100
        // loadingMaxTaskCount: max: Int.max. bestMax: 2. If more than 2, some message will drop in Swift async stream.
        let loading = (batchSize: 50, maxTaskCount: 2)
        
        var newMessageIDs = [GoogleMessageID]()
        let (idEstimateCount, idStream) = try await checkMessageIDs(mailFolderID: mailFolderID, pageSize: checkingPageSize)
        for try await ids in idStream {
            newMessageIDs.append(contentsOf: ids)
            await MainActor.run { [value = newMessageIDs.count] in
                mailFolderID.generalID.loadingMessageState = .checking(value: value, total: max(value, idEstimateCount))
            }
        }
        
        // remove
        let shouldInsertMessageIDs = try await modelStore.setMessagesDeletePart(newMessageIDs: newMessageIDs.map { $0.generalID }, mailFolderID: mailFolderID.generalID).map { try $0.element.google }
        
        guard !shouldInsertMessageIDs.isEmpty else { return }
        let stream = try await getMessagesStream(mailFolderID: mailFolderID, messageIDs: shouldInsertMessageIDs, batchSize: loading.batchSize, maxTaskCount: loading.maxTaskCount)
        let total = newMessageIDs.count
        var value = total - shouldInsertMessageIDs.count
        for try await messages in stream {
            value += try await modelStore.insertMessages(sources: messages, mailFolderID: mailFolderID.generalID).count // MSAL to SwiftData
            await MainActor.run { [value] in
                mailFolderID.generalID.loadingMessageState = .loading(value: value, total: total)
            }
        }
    }
    
    /*@MainActor // for id.loadingMessageState
    func loadMessagesMain(mailFolderID: GoogleMailFolderID, modelContext: ModelContext) async throws {
        
        let newMessageIDs: [MessageID] = try await getMessagesID(in: mailFolderID).map { $0.generalID }
        
        // remove
        let shouldInsertMessageIDs = try await modelContext.setMessagesDeletePart(newMessageIDs: newMessageIDs, mailFolderID: mailFolderID.generalID).compactMap(\.element.google)
        
        
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
        let accountID = account.id.innerID
        let messageID = messageID.innerID
        
        let request = GTLRGmail_ModifyMessageRequest()
        request.removeLabelIds =  [fromID.innerID]
        request.addLabelIds = [toID.innerID]
        
        let query = GTLRGmailQuery_UsersMessagesModify.query(withObject: request, userId: accountID, identifier: messageID)
        
        return try await service.execute(query, responseType: GTLRGmail_Message.self).messageInner.outer(accountID: account.id)
    }
    
    // MARK: - Message

    
    func messageBody(messageID: GoogleMessageID) async throws -> GoogleMessage {
        let full = try await getMessage(messageID: messageID, format: .full)
        let raw  = try await getMessage(messageID: messageID, format: .raw).raw
        let message = try full.outer(accountID: account.id, raw: raw)
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
        let query = GTLRGmailQuery_UsersLabelsList.query(withUserId: account.id.innerID)
        let response: GTLRGmail_ListLabelsResponse = try await service.execute(query)
        guard let labels = response.labels else { throw GmailApiError.failedToParseData(response) }
        return try labels.map { try $0.mailFolder.with(accountID: account.id) }
            //.sorted { "\($0.type?.rawValue)" > "\($1.type?.rawValue)" }
            //.filter { $0.type == .user || $0.path == "SPAM" || $0.path == "INBOX"}
            //.sorted(using: KeyPathComparator(\MailFolder.name))
    }
}

fileprivate extension GoogleSession {
    /*// https://developers.google.com/gmail/api/reference/rest/v1/users.messages/list
    func messageIDs(mailFolderID: GoogleMailFolderID) async throws -> [GoogleMessageID] {
        let query = GTLRGmailQuery_UsersMessagesList.query(withUserId: account.id.innerID)
        query.labelIds = [mailFolderID.innerID]
        query.maxResults = 500 // maxResults: 1-500, default: 100
        // service.shouldFetchNextPages == true
        
        let response: GTLRGmail_ListMessagesResponse = try await service.execute(query)
        let messages = response.messages ?? []
        return try messages.map { try $0.messageInner.id(accountID: account.id) }
    }*/
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - mailFolderID: <#mailFolderID description#>
    ///   - pageSize: max: 500, default: 100
    /// - Returns: <#description#>
    /// https://developers.google.com/gmail/api/reference/rest/v1/users.messages/list
    func checkMessageIDs(mailFolderID: GoogleMailFolderID, pageSize: Int?) async throws -> (estimateCount: Int, stream: AsyncThrowingStream<[GoogleMessageID], Error>) {
        let query = GTLRGmailQuery_UsersMessagesList.query(withUserId: account.id.innerID)
        query.labelIds = [mailFolderID.innerID]
        if let pageSize {
            query.maxResults = UInt(pageSize)
        }
                
        // get count
        let (estimateCount, messageIDs, nextPageToken) = try await {
            let response: GTLRGmail_ListMessagesResponse = try await serviceStream.execute(query)
            guard let estimateCount = response.resultSizeEstimate?.uint32Value else { throw AuthError.collectionResponseNoCount }
            let messageIDs = try (response.messages ?? []).map { try $0.messageInner.id(accountID: account.id) }
            let nextPageToken = response.nextPageToken
            return (Int(estimateCount), messageIDs, nextPageToken)
        }()
        
        
        let stream: AsyncThrowingStream<[GoogleMessageID], Error> = .init { continuation in Task { [messageIDs, nextPageToken] in
            do {
                // get paging results
                
                continuation.yield(messageIDs)
                await Task.yield()

                var nextPageToken: String? = nextPageToken
                
                while let pageToken = nextPageToken {
                    let query = GTLRGmailQuery_UsersMessagesList.query(withUserId: account.id.innerID)
                    query.labelIds = [mailFolderID.innerID]
                    if let pageSize {
                        query.maxResults = UInt(pageSize)
                    }
                    query.pageToken = pageToken
                    let response: GTLRGmail_ListMessagesResponse = try await serviceStream.execute(query)
                    let messageIDs = try (response.messages ?? []).map { try $0.messageInner.id(accountID: account.id) }
                    continuation.yield(messageIDs)
                    await Task.yield()
                    nextPageToken = response.nextPageToken
                }
                
                continuation.finish()
            } catch {
                continuation.finish(throwing: error)
            }
        } }
        return (estimateCount, stream)
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - mailFolderID: <#mailFolderID description#>
    ///   - messageIDs: <#messageIDs description#>
    ///   - batchSize: max: 100
    ///   - maxTaskCount: max: Int.max. bestMax: 2. If more than 2, some message will drop in Swift async stream.
    /// - Returns: <#description#>
    func getMessagesStream(mailFolderID: GoogleMailFolderID, messageIDs: [GoogleMessageID], batchSize: Int, maxTaskCount: Int) async throws -> AsyncThrowingStream<[GoogleMessage], Error> {
        .init(messageIDs: messageIDs, accountID: account.id, service: service, batchSize: batchSize, maxTaskCount: maxTaskCount)
    }
}

fileprivate extension AsyncThrowingStream where Element == [GoogleMessage], Failure == Error {
    init(messageIDs: [GoogleMessageID], accountID: GoogleAccountID, service: GTLRGmailService, batchSize: Int, maxTaskCount: Int) {
        // maxTaskCount =
        self.init { [service] (continuation: Continuation) in Task {
            var rest = messageIDs[...]
            do {
                try await withThrowingTaskGroup(of: [GoogleMessage].self) { group in
                    if maxTaskCount < Int.max {
                        for _ in 0..<maxTaskCount {
                            group.addTask(accountID: accountID, service: service, rest: &rest, batchSize: batchSize)
                        }
                    } else {
                        while rest.count > 0 {
                            group.addTask(accountID: accountID, service: service, rest: &rest, batchSize: batchSize)
                        }
                    }
                    
                    for try await result in group {
                        continuation.yield(result)
                        await Task.yield()
                        group.addTask(accountID: accountID, service: service, rest: &rest, batchSize: batchSize)
                    }
                    //}
                }
                continuation.finish()
            } catch {
                continuation.finish(throwing: error)
            }
        } }
    }
}

fileprivate extension ThrowingTaskGroup where ChildTaskResult == [GoogleMessage] {
    mutating func addTask(accountID: GoogleAccountID, service: GTLRGmailService, rest: inout Array<GoogleMessageID>.SubSequence, batchSize: Int) {
        guard !rest.isEmpty else { return }
        let chunk = rest.prefix(batchSize)
        rest = rest.dropFirst(batchSize)
        addTask {
            let query = GTLRBatchQuery(queries: chunk.map {
                let query = GTLRGmailQuery_UsersMessagesGet.query(withUserId: accountID.innerID, identifier: $0.innerID)
                // query.fields = fields
                query.format = GetMessageFormat.metadata.rawValue
                return query
            })
            
            let batchResult: GTLRBatchResult = try await service.execute(query)
            
            guard let messagesDict = batchResult.successes as? [String: GTLRGmail_Message] else { fatalError() } // TODO: fatalError replace with error
            return try messagesDict.values.map { try $0.messageInner.outer(accountID: accountID) }
        }
    }
}

fileprivate extension GoogleSession {
    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/get
    func getMessage(messageID: GoogleMessageID, fields: String? = nil, format: GetMessageFormat) async throws -> GoogleMessageInner {
        let query = GTLRGmailQuery_UsersMessagesGet.query(withUserId: account.id.innerID, identifier: messageID.innerID)
        query.fields = fields
        query.format = format.rawValue
        
        return try await service.execute(query, responseType: GTLRGmail_Message.self).messageInner
        
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
    
    var serviceStream: GTLRGmailService {
        let service = GTLRGmailService()
        service.authorizer = _gtmSession
        service.shouldFetchNextPages = false
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
    func execute<Q: GTLRQueryProtocol, T: NSObject & Sendable>(_ query: Q, responseType: T.Type = T.self) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            executeQuery(query) { (ticket: GTLRServiceTicket, object: Any?, error: Error?) in
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
    func outer(accountID: GoogleAccountID, raw: Data? = nil) throws -> GoogleMessage {
        try .init(id: .init(accountID: accountID, innerID: id), inner: self, raw: raw)
    }
    
    func id(accountID: GoogleAccountID) -> GoogleMessageID {
        .init(accountID: accountID, innerID: id)
    }
}

