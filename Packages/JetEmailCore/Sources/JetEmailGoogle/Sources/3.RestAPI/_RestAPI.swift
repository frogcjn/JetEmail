//
//  Google+Request.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

@preconcurrency import GoogleAPIClientForREST_Gmail // @preconcurrency for GTLRGmail_Message, GTLRGmail_ListMessagesResponse

import class JetEmailFoundation.Tree // for Tree
import class JetEmailFoundation.TreeNode
import       JetEmailData

// MARK: - FilePrivate Functions

extension GoogleSession {
    // google mailfolder path-name algrithm
    func _mailFolderTree(rootElement: GoogleMailFolder) async throws -> Tree<GoogleMailFolder> {
        let tree = Tree(rootElement: rootElement)
        
        // copy name to path
        let elements = try await _getMailFolders()
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
            (node.parent, node.element) = (parent, node.element.with(name: processedName))
            parent.children.append(node)
        }
        
        return tree
    }
    
    private func _getMailFolders() async throws -> [GoogleMailFolder] {
        let query = GTLRGmailQuery_UsersLabelsList.query(withUserId: account.id.innerID)
        let response: GTLRGmail_ListLabelsResponse = try await service.execute(query)
        guard let labels = response.labels else { throw GmailApiError.failedToParseData(response) }
        return try labels.map { try $0.mailFolder.with(accountID: account.id) }
            //.sorted { "\($0.type?.rawValue)" > "\($1.type?.rawValue)" }
            //.filter { $0.type == .user || $0.path == "SPAM" || $0.path == "INBOX"}
            //.sorted(using: KeyPathComparator(\MailFolder.name))
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - mailFolderID: <#mailFolderID description#>
    ///   - pageSize: max: 500, default: 100
    /// - Returns: <#description#>
    /// https://developers.google.com/gmail/api/reference/rest/v1/users.messages/list
    func _checkMessageIDs(mailFolderID: GoogleMailFolderID, pageSize: Int?) async throws -> (estimateCount: Int, stream: AsyncThrowingStream<[GoogleMessageID], Error>) {
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
    func _getMessagesStream(mailFolderID: GoogleMailFolderID, messageIDs: [GoogleMessageID], batchSize: Int, maxTaskCount: Int) async throws -> AsyncThrowingStream<[GoogleMessage], Error> {
        .init(messageIDs: messageIDs, accountID: account.id, service: service, batchSize: batchSize, maxTaskCount: maxTaskCount)
    }

    // https://developers.google.com/gmail/api/reference/rest/v1/users.messages/get
    func _getMessage(messageID: GoogleMessageID, fields: String? = nil, format: _GoogleAPI.GetMessageFormat) async throws -> _GoogleAPI.GoogleMessageInner {
        let query = GTLRGmailQuery_UsersMessagesGet.query(withUserId: account.id.innerID, identifier: messageID.innerID)
        query.fields = fields
        query.format = format.rawValue
        
        return try await service.execute(query, responseType: GTLRGmail_Message.self).messageInner
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
                query.format = _GoogleAPI.GetMessageFormat.metadata.rawValue
                return query
            })
            
            let batchResult: GTLRBatchResult = try await service.execute(query)
            
            guard let messagesDict = batchResult.successes as? [String: GTLRGmail_Message] else { fatalError() } // TODO: fatalError replace with error
            return try messagesDict.values.map { try $0.messageInner.outer(accountID: accountID, raw: nil) }
        }
    }
}
