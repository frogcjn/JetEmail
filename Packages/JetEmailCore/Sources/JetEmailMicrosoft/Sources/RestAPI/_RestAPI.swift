//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/24/24.
//

import   struct Foundation.KeyPathComparator
import   struct Foundation.URLQueryItem

import protocol JetEmailFoundation.AsyncSequenceOf
import          JetEmailData

extension MicrosoftSession {
    
    
    @MainActor
    var _idToSystemName:  [MicrosoftMailFolderID: _MicrosoftAPI.MicrosoftMailFolderSystemName] { get async {
        if let idToWellKnownFolderName = account.id._idToSystemName { return idToWellKnownFolderName }
        let idToWellKnownFolderName: [MicrosoftMailFolderID: _MicrosoftAPI.MicrosoftMailFolderSystemName] =  await {
            do {
                // catch wellknownFolderName
                var idToWellKnownFolderName = [MicrosoftMailFolderID: _MicrosoftAPI.MicrosoftMailFolderSystemName]()
                for systemName in _MicrosoftAPI.MicrosoftMailFolderSystemName.allCases {
                    do {
                        let folder = try await _getMailFolder(systemName: systemName)
                        idToWellKnownFolderName[folder.id] = systemName
                    } catch let error as JetEmailMicrosoft.MicrosoftAPIError.Public where error.code == "ErrorFolderNotFound" {
                        continue
                    }
                }
                return idToWellKnownFolderName
            } catch {
                return [:]
            }
        }()
        account.id._idToSystemName = idToWellKnownFolderName
        return idToWellKnownFolderName
    } }
    
    func _getChildFolders(mailFolderID: MicrosoftMailFolderID) async throws -> [MicrosoftMailFolder]  {
        let idToSystemName = await _idToSystemName
        return try await _getValues(
            url: client.endpointURL.appending(pathComponents: "me", "mailFolders", mailFolderID.innerID, "childFolders"),
            responseType: _MicrosoftAPI.MicrosoftMailFolderInner.self
        ).map { $0.with(accountID: account.id, _idToSystemName: idToSystemName) }
    }
    
    func _getMailFolder(systemName: _MicrosoftAPI.MicrosoftMailFolderSystemName) async throws -> MicrosoftMailFolder {
        try await _getValue(
            url: client.endpointURL.appending(pathComponents: "me", "mailFolders", systemName.rawValue),
            responseType: _MicrosoftAPI.MicrosoftMailFolderInner.self
        ).with(accountID: account.id, _systemName: systemName)
    }
    
    /*func getMailFolder(mailFolderID: MicrosoftMailFolderID)  async throws -> MicrosoftMailFolder {
     try await getValue(pathComponents: "mailFolders", "\(mailFolderID.innerID)")
     }*/
    
    /*func createChildFolder(id: MSGraph.MailFolder.ID, displayName: String, isHidden: Bool? = nil) async throws -> MSGraph.MailFolder {
     try await postItem("mailFolders", "\(id)", "childFolders", body: MailFoldersCreateRequestBody(displayName: displayName, isHidden: isHidden))
     }*/
    
    /// <#Description#>
    /// - Parameters:
    ///   - mailFolderID: <#mailFolderID description#>
    ///   - pageSize: max:1000, default: 100
    /// - Returns: <#description#>
    func _checkMessageIDs(mailFolderID: MicrosoftMailFolderID, pageSize: Int?) async throws -> (count: Int, stream: some AsyncSequenceOf<[MicrosoftMessageID]>) {
        let (count, stream) = try await _getValuesStream(
            url: client.endpointURL.appending(
                pathComponents: "me", "mailFolders", mailFolderID.innerID, "messages",
                queryItems: pageSize.map(URLQueryItem.top) // pageSize => $top: 1-1000, default: 100
                // .select("id"),
            ),
            responseType: _MicrosoftAPI.MicrosoftMessageInner.self
        )
        
        let accountID = account.id
        return (count, stream.map {
            return $0.map { $0.id(accountID: accountID) }
        })
    }
    
    // pageSize => $top: 1-1000, default: nil (10)
    
    /// <#Description#>
    /// - Parameters:
    ///   - mailFolderID: <#mailFolderID description#>
    ///   - messageIDs: <#messageIDs description#>
    ///   - batchSize: max: 20
    /// - Returns: <#description#>
    func _loadMessagesStream(mailFolderID: MicrosoftMailFolderID, messageIDs: [MicrosoftMessageID], batchSize: Int) async throws -> AsyncThrowingStream<[MicrosoftMessage], Error> {
        .init { continuation in Task {
            do {
                var rest = messageIDs[...]
                
                while rest.count > 0 {
                    let chunk = rest.prefix(batchSize)
                    rest = rest.dropFirst(batchSize)
                    
                    let messages: [MicrosoftMessage] = try await _getMessagesBatch(mailFolderID: mailFolderID, messageIDs: Array(chunk))
                    continuation.yield(messages)
                    await Task.yield()
                }
                
                continuation.finish()
            } catch {
                continuation.finish(throwing: error)
            }
        } }
    }
    
    private func _getMessagesBatch(mailFolderID: MicrosoftMailFolderID, messageIDs: [MicrosoftMessageID]) async throws -> [MicrosoftMessage] {
        let paths = messageIDs.map { client.endpointURL.relative(
            pathComponents: "me", "mailFolders",
            mailFolderID.innerID, "messages", $0.innerID,
            queryItems: .selectForMessagePreview
        ) }
        return try await _getBatch(paths: paths, responseType: _MicrosoftAPI.MicrosoftMessageInner.self).map { $0.outer(accountID: account.id, raw: nil) }
    }
    
    /*
    // Delta version
    // https://learn.microsoft.com/en-us/graph/delta-query-messages#example-1-synchronize-messages-in-a-folder
    func _messagesDeltaStream(mailFolderID: MicrosoftMailFolderID, maxPageSize: Int?) async throws -> some AsyncSequenceOf<Delta<MicrosoftMessage>> {
        try await getValuesDeltaStream(
            url: client.endpoint(
                pathComponents: "me", "mailFolders", mailFolderID.innerID, "messages", "delta",
                queryItems: .selectForMessagePreview
            ),
            maxPageSize: maxPageSize,
            responseType: _MicrosoftAPI.MicrosoftMessageInner.self
        ).map { [accountID = account.id] in $0.map { $0.outer(accountID: accountID, raw: nil) } }
    }
    
    // https://learn.microsoft.com/en-us/graph/delta-query-messages#example-1-synchronize-messages-in-a-folder
    func _messagesDeltaStream(deltaLink: URL, maxPageSize: Int?) async throws -> some AsyncSequenceOf<Delta<MicrosoftMessage>> {
        try await getValuesDeltaStream(
            url: deltaLink,
            maxPageSize: maxPageSize,
            responseType: _MicrosoftAPI.MicrosoftMessageInner.self
        ).map { [accountID = account.id] in $0.map { $0.outer(accountID: accountID, raw: nil) } }
    }*/
    
    // https://learn.microsoft.com/en-us/graph/api/mailfolder-list-messages
    /*fileprivate func getMessages(id: MicrosoftMailFolderID) async throws -> [MicrosoftMessage] {
        try await getValues(MicrosoftMessageInner.self, paths: "mailFolders", "\(id.innerID)", "messages", queryItems:
            // .orderBy(name: "receivedDateTime", .descending),
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
        ).map { $0.with(accountID: account.id) }
    }*/

    /*func getMessagesStream(ids: [Message.ID]) async throws -> (count: Int, stream: AsyncThrowingStream<[Message], Error>)  {
        try await getValuesStream(paths: "mailFolders", "\(id)", "messages", queryItems:
            // .orderBy(name: "receivedDateTime", .descending),
            pageSize.map(URLQueryItem.top),
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
        )
    }*/
}
