//
//  MSGraph.Session.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/18/24.
//

import Foundation
import JetEmailData
import JetEmailFoundation

public extension MicrosoftSession {
    
    // MARK: - Account-MailFolders
    
    func rootMailFolder() async throws -> MicrosoftMailFolder {
        try await getMailFolder(systemName: .msgFolderRoot)
    }
    
    func loadMailFoldersUnderRoot(root: MicrosoftMailFolder, modelStore: ModelStore) async throws {
        var queue: [MicrosoftMailFolderID] = [root.id]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            let childrenMailFolders = try await getChildFolders(mailFolderID: current)
            let children = try await modelStore.setChildrenMailFolders(resources: childrenMailFolders, parentID: current.generalID, accountID: account.generalID).compactMap(\.platformCase?.microsoft)
            queue.append(contentsOf: children)
        }
    }
    
    // MARK: - MailFolder-Messages
    
    func loadMessages(mailFolderID: MicrosoftMailFolderID, modelStore: ModelStore) async throws {
        
        let newMessageIDs: [MessageID] = try await getMessagesID(in: mailFolderID).map { $0.generalID }

        // remove
        let shouldInsertMessageIDs = try await modelStore.setMessagesDeletePart(newMessageIDs: newMessageIDs, mailFolderID: mailFolderID.generalID).compactMap(\.element.platformCase?.microsoft)
        
        guard !shouldInsertMessageIDs.isEmpty else { return }
        
        // do {
        let stream = try await getMessagesStream(mailFolderID: mailFolderID, messageIDs: shouldInsertMessageIDs)
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
    
    /*func loadMessages(mailFolderID: MicrosoftMailFolderID, modelStore: ModelStore) async throws {
        
        let newMessageIDs: [MessageID] = try await getMessagesID(in: mailFolderID).map { $0.generalID }

        // remove
        let firstIndexToLoad = try await modelStore.setMessagesDeletePart(newMessageIDs: newMessageIDs, mailFolderID: mailFolderID.generalID).first?.offset
        
        
        //let (total, stream): (total: Int, stream: some AsyncSequenceOf<[MicrosoftMessage]>)
        
        if let firstIndexToLoad {
           // do {
            let (total, stream) = try await getMessagesStream(id: mailFolderID, skip: firstIndexToLoad)
            //}
            /* catch let error as URLError where error.code == .badURL {
                (total, stream) = try await session.getMessagesStream(id: innerID)
            }*/
            var value = firstIndexToLoad
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
    }*/
    
    /*@MainActor // for id.loadingMessageState
    func loadMessagesMain(mailFolderID: MicrosoftMailFolderID, modelContext: ModelContext) async throws {
        
        let newMessageIDs: [MessageID] = try await getMessagesID(in: mailFolderID).map { $0.generalID }

        // remove
        let firstIndexToLoad = try await modelContext.setMessagesDeletePart(newMessageIDs: newMessageIDs, mailFolderID: mailFolderID.generalID).first?.offset
        
        
        let (total, stream): (total: Int, stream: AsyncThrowingStream<[MicrosoftMessage], Error>)
        
        if let firstIndexToLoad {
           // do {
            (total, stream) = try await getMessagesStream(id: mailFolderID, skip: firstIndexToLoad)
            //}
            /* catch let error as URLError where error.code == .badURL {
                (total, stream) = try await session.getMessagesStream(id: innerID)
            }*/
            var value = firstIndexToLoad
            mailFolderID.generalID.loadingMessageState = .loading(value: value, total: total)
            for try await messages in stream {
                value += try modelContext.setMessagesInsertPart(resources: messages, mailFolderID: mailFolderID.generalID).count // MSAL to SwiftData
                mailFolderID.generalID.loadingMessageState = .loading(value: value, total: total)
            }
        }
    }*/
        
    // https://learn.microsoft.com/en-us/graph/api/message-move
    func moveMessage(messageID: MicrosoftMessageID, fromID: MicrosoftMailFolderID, toID: MicrosoftMailFolderID) async throws -> MicrosoftMessage {
        struct MessageMoveRequestBody : Encodable {
            let destinationId: String
        }
        return try await postItem("mailFolders", fromID.innerID, "messages", messageID.innerID, "move", body: MessageMoveRequestBody(destinationId: toID.innerID), responseType: MicrosoftMessageInner.self).with(accountID: account.id)
    }
    
    // MARK: - Message
    
    // https://learn.microsoft.com/en-us/graph/api/message-get
    func messageBody(messageID: MicrosoftMessageID) async throws -> MicrosoftMessage {
        var message: MicrosoftMessage = try await getValue(
            paths: "messages", messageID.innerID,
            queryItems: .select(
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
            ),
            responseType: MicrosoftMessageInner.self).with(accountID: account.id)
        message.raw = try await getMultipartData(paths: "messages", messageID.innerID, "$value")
        return message
    }
}


// MARK: - FilePrivate Functions


fileprivate extension MicrosoftSession {
    
    
    @MainActor
    var idToSystemName:  [MicrosoftMailFolderID: MicrosoftMailFolderSystemName] { get async {
        if let idToWellKnownFolderName = account.id.idToWellKnownFolderName { return idToWellKnownFolderName }
        let idToWellKnownFolderName: [MicrosoftMailFolderID: MicrosoftMailFolderSystemName] =  await {
            do {
                // catch wellknownFolderName
                var idToWellKnownFolderName = [MicrosoftMailFolderID: MicrosoftMailFolderSystemName]()
                for systemName in MicrosoftMailFolderSystemName.allCases {
                    do {
                        let folder = try await getMailFolder(systemName: systemName)
                        idToWellKnownFolderName[folder.id] = systemName
                    } catch let error as JetEmailMicrosoft.PublicError where error.code == "ErrorFolderNotFound" {
                        continue
                    }
                }
                return idToWellKnownFolderName
            } catch {
                return [:]
            }
        }()
        account.id.idToWellKnownFolderName = idToWellKnownFolderName
        return idToWellKnownFolderName
    } }
    
    func getChildFolders(mailFolderID: MicrosoftMailFolderID) async throws -> [MicrosoftMailFolder]  {
        let idToSystemName = await idToSystemName
        return try await getValues(
            paths: "mailFolders", mailFolderID.innerID, "childFolders",
            responseType: MicrosoftMailFolderInner.self
        ).map { $0.with(accountID: account.id, idToSystemName: idToSystemName) }
    }
    
    func getMailFolder(systemName: MicrosoftMailFolderSystemName) async throws -> MicrosoftMailFolder {
        try await getValue(
            paths: "mailFolders", systemName.rawValue,
            responseType: MicrosoftMailFolderInner.self
        ).with(accountID: account.id, systemName: systemName)
    }
    
    /*func getMailFolder(mailFolderID: MicrosoftMailFolderID)  async throws -> MicrosoftMailFolder {
        try await getValue(paths: "mailFolders", "\(mailFolderID.innerID)")
    }*/
    
    /*func createChildFolder(id: MSGraph.MailFolder.ID, displayName: String, isHidden: Bool? = nil) async throws -> MSGraph.MailFolder {
        try await postItem("mailFolders", "\(id)", "childFolders", body: MailFoldersCreateRequestBody(displayName: displayName, isHidden: isHidden))
    }*/
    
    // pageSize => $top: 1-1000, default: 1000
    func getMessagesID(in mailFolderID: MicrosoftMailFolderID, pageSize: Int? = 1000) async throws -> [MicrosoftMessageID] {
        try await getValues(
            paths: "mailFolders", mailFolderID.innerID, "messages",
            queryItems:
                pageSize.map(URLQueryItem.top),
                .select("id"),
            responseType: MicrosoftMessageInner.self
        ).map { $0.with(accountID: account.id) }
    }
    
    // pageSize => $top: 1-1000, default: nil (10)
    /*func getMessagesStream(id: MicrosoftMailFolderID, pageSize: Int? = nil, skip: Int? = nil) async throws -> (
        count: Int,
        stream: some AsyncSequenceOf<[MicrosoftMessage]>
    )  {
        let (count, stream) = try await getValuesStream(MicrosoftMessageInner.self, paths: "mailFolders", "\(id.innerID)", "messages", queryItems:
                // .orderBy(name: "receivedDateTime", .descending),
                pageSize.map(URLQueryItem.top),
                skip.flatMap(URLQueryItem.skip),
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
        
        let accountID = account.id
        return (count, stream.map { $0.map { $0.with(accountID: accountID) } })
    }*/
    // pageSize => $top: 1-1000, default: nil (10)
    func getMessagesStream(mailFolderID: MicrosoftMailFolderID, messageIDs: [MicrosoftMessageID]) async throws -> AsyncThrowingStream<[MicrosoftMessage], Error> {
        .init { continuation in Task {
            do {
                let chunkSize = 10
                var rest = messageIDs[...]
                
                while rest.count > 0 {
                    let chunk = rest.prefix(chunkSize)
                    rest = rest.dropFirst(chunkSize)
                    
                    let messages: [MicrosoftMessage] = try await chunk.asyncMap {
                        try await getValue(
                            paths: "mailFolders", mailFolderID.innerID, "messages", $0.innerID,
                            queryItems:
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
                                ),
                            responseType: MicrosoftMessageInner.self
                        ).with(accountID: account.id)
                    }
                    continuation.yield(messages)
                    await Task.yield()
                }
                
                continuation.finish()
            } catch {
                continuation.finish(throwing: error)
            }
        } }
    }
    
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


fileprivate extension MicrosoftMessageInner {
    func with(accountID: MicrosoftAccountID) -> MicrosoftMessage {
        .init(id: .init(accountID: accountID, innerID: id), inner: self)
    }
    
    func with(accountID: MicrosoftAccountID) -> MicrosoftMessageID {
        .init(accountID: accountID, innerID: id)
    }
}

fileprivate extension MicrosoftMailFolderInner {
    func with(accountID: MicrosoftAccountID, systemName: MicrosoftMailFolderSystemName?) -> MicrosoftMailFolder {
        .init(id: .init(accountID: accountID, innerID: id), inner: self, systemName: systemName?.generalSystemName)
    }
    
    func with(accountID: MicrosoftAccountID, idToSystemName: [MicrosoftMailFolderID: MicrosoftMailFolderSystemName]) -> MicrosoftMailFolder {
        with(accountID: accountID, systemName: idToSystemName[MicrosoftMailFolderID(accountID: accountID, innerID: id)])
    }
}


// MARK: - Others

// MARK: - MSGraph: Get, Post API

fileprivate extension MicrosoftSession {
    
    var endpointURL: URL { MicrosoftClient.endpointURL }
    
    func getResponseString(url: URL) async throws -> String {
        try await URLRequest._get(url: url)._settingAuthorization(header: authorizationHeader).responseString
    }
    
    func getResponseDataForString(url: URL) async throws -> Data {
        try await URLRequest._get(url: url)._settingAuthorization(header: authorizationHeader).responseDataForString
    }
    
    func getResponse<Value: Decodable & Sendable>(url: URL, responseType: Value.Type = Value.self) async throws -> Value {
        try await URLRequest._get(url: url)._settingAuthorization(header: authorizationHeader).responseJSON(Value.self)
    }
    
    func postResponse<RequestBody: Encodable, Value: Decodable & Sendable>(url: URL, body: RequestBody, responseType: Value.Type = Value.self) async throws -> Value {
        try await URLRequest._post(url: url, body: body)._settingAuthorization(header: authorizationHeader).responseJSON(Value.self)
    }
}

fileprivate extension MicrosoftSession {

    func getMultipartData(paths: String..., queryItems: [URLQueryItem] = []) async throws -> Data {
        var url = paths.reduce(endpointURL) { $0.appending(path: $1) }
        if queryItems.count > 0 { url.append(queryItems: queryItems) }
        return try await getResponseDataForString(url: url)
    }
    
    func getValue<Value: Decodable & Sendable>(paths: String..., queryItems: URLQueryItem?..., responseType: Value.Type = Value.self) async throws -> Value {
        var url = paths.reduce(endpointURL) { $0.appending(path: $1) }
        if let queryItems = queryItems.compactMap({ $0 }).nilIfEmpty { url.append(queryItems: queryItems) }
        return try await getResponse(url: url)
    }
    
    func getValues<Value: Decodable & Sendable>(paths: String..., queryItems: URLQueryItem?..., responseType: Value.Type = Value.self) async throws -> [Value] {
        var url = paths.reduce(endpointURL) { $0.appending(path: $1) }
        // get count
        /*let count = try await {
            let url = urlPaths.appending(path: "$count")
            let string = try await getResponseString(url: url)
            guard let count = Int(string) else { throw AuthError.collectionResponseNoCount }
            return count
        }()*/
        
        // get paging results
        
        if let queryItems = queryItems.compactMap({ $0 }).nilIfEmpty { url.append(queryItems: queryItems) }

        var nextLink: URL? = url
        var values = [Value]()
        
        
        while let url = nextLink {
            let response: GraphCollectionResponse<Value> = try await getResponse(url: url)
            values.append(contentsOf: response.values)
            nextLink = response.nextLink
        }

        return values
    }
    
    func getValuesStream<Value: Sendable & Decodable>(paths: String..., queryItems: URLQueryItem?..., responseType: Value.Type = Value.self) async throws -> (count: Int, stream: AsyncThrowingStream<[Value], Error>) {
        let queryItems = queryItems.compactMap({ $0 }) + [URLQueryItem.count()]
        let url = paths.reduce(endpointURL) { $0.appending(path: $1) }.appending(queryItems: queryItems)
        var firlstNextLink: URL?
        
        // get count
        let (count, firstValues) = try await {
            let response: GraphCollectionResponse<Value> = try await getResponse(url: url)
            guard let count = response.count else { throw AuthError.collectionResponseNoCount }
            let values = response.values
            firlstNextLink = response.nextLink
            return (count, values)
        }()
        
        
        let stream: AsyncThrowingStream<[Value], Error> = .init { continuation in Task { [firstValues, firlstNextLink] in
            do {
                // get paging results
                
                continuation.yield(firstValues)
                await Task.yield()

                var nextLink: URL? = firlstNextLink
                
                while let url = nextLink {
                    let response: GraphCollectionResponse<Value> = try await getResponse(url: url)
                    continuation.yield(response.values)
                    await Task.yield()
                    nextLink = response.nextLink
                }
                
                continuation.finish()
            } catch {
                continuation.finish(throwing: error)
            }
        } }
        return (count, stream)
    }
    
    
    func postItem<RequestBody: Encodable, Value: Decodable & Sendable>(_ paths: String..., body: RequestBody, responseType: Value.Type = Value.self) async throws -> Value {
        let url = paths.reduce(endpointURL) { $0.appending(path: $1) }
        return try await postResponse(url: url, body: body)
    }
}

// MARK: - MSGraph: Get, Post API Structs

/*
struct MailFoldersCreateRequestBody : Codable {
    let displayName: String
    let isHidden: Bool?
}*/


fileprivate struct GraphCollectionResponse<Value : Decodable & Sendable> : Decodable & Sendable {
    let values: [Value]

    let  context: URL?
    let    count: Int?
    let nextLink: URL?
    
    enum CodingKeys : String, CodingKey {
        case  context = "@odata.context"
        case    count = "@odata.count"
        case nextLink = "@odata.nextLink"
        case   values = "value"
    }
}

// https://learn.microsoft.com/en-us/graph/errors#error-resource-type
fileprivate struct GraphErrorResponse : Codable {
    let error: PublicError
}

// typealias JSON<T: Any> = [String: T] where T: Codable

/*func handleError(from data: Data) throws -> MSGraph.PublicError {
    try data.jsonDecode(MSGraph.PublicError.self)
}*/

// MARK: - Foundation: URLRequest, URLQueryItem

fileprivate extension URLRequest {
    
    static func _get(url: URL) -> Self {
        URLRequest(url: url)
    }
    
    static func _post<T: Encodable>(url: URL, body: T) throws -> URLRequest {
        __post(url: url, bodyData: try body.jsonData)
    }
    
    private static func __post(url: URL, bodyData: Data) -> Self {
        var request = URLRequest(url: url)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    func _settingAuthorization(header: String) -> Self {
        var request = self
        request.setValue(header, forHTTPHeaderField: "Authorization")
        return request
    }
    
    private var _responseDataForJSON: Data { get async throws {
        let (data, response) = try await URLSession.shared.data(for: self)
        if !data.isEmpty {
            assert(response.mimeType == "application/json")
        }
        return data
    } }
    
    var responseDataForString: Data { get async throws {
        let (data, response) = try await URLSession.shared.data(for: self)
        assert(response.mimeType == "text/plain")
        return data
    } }

    var responseString: String { get async throws {
        try await responseDataForString.string
    } }

    func responseJSON<T: Decodable>(_ type: T.Type) async throws -> T {
        let data = try await _responseDataForJSON
        let result = Result { try data.decodeJSON(type) }
        switch result {
        case .failure(let failure):
            if let error = try? data.decodeJSON(GraphErrorResponse.self).error {
                throw error
            } else {
                throw failure
            }
        case .success(let success):
            return success
        }
    }
    

}

fileprivate extension URLQueryItem {
    static func top(_ value: Int) -> URLQueryItem {
        assert(value > 0)
        return .init(name: "$top", value: "\(value)")
    }
    
    static func skip(_ value: Int) -> URLQueryItem? {
        if value <= 0 { return nil }
        return .init(name: "$skip", value: "\(value)")
    }
    
    static func orderBy(name: String, _ order: URLQueryItemOrder? = nil) -> URLQueryItem {
        if let order {
            .init(name: "$orderby", value: "\(name) \(order)")
        } else {
            .init(name: "$orderby", value: "\(name)")
        }
    }
    
    static func select(_ names: String...) -> URLQueryItem {
        .init(name: "$select", value: names.joined(separator: ","))
    }
    
    static func count(_ value: Bool = true) -> URLQueryItem {
        .init(name: "$count", value: "\(value)")
    }
    
    static func filter(ids: [String]) -> URLQueryItem {
        let ids = ids.map { "'\($0)'" }.joined(separator: ",")
        return  .init(name: "$filter", value: "id in (\(ids))")
    }
}

fileprivate enum URLQueryItemOrder: String {
    case descending = "desc"
    case ascending = "asc"
}

fileprivate extension String.StringInterpolation {
    mutating func appendInterpolation(_ order: URLQueryItemOrder) {
        appendInterpolation(order.rawValue)
    }
}

/*
extension MSGraph.Context {
 
     
     
     /*func signIn(allowInteractive: Bool) async {
      guard account == nil else { return }
      
      (_loginResult, loginHint) = await {
      do {
      return try await _getAccount(allowInteractive: allowInteractive)
      } catch {
      return (nil, "Couldn't sign in account with error: \(error)")
      }
      }()
      }
      
      func signOut() async {
      guard let account else { return }
      
      (_loginResult, loginHint) = await _signOut(account: account.account)
      }*/
     
     
    func _signOut(account: MSGraph.Account) async -> (MSALResult?, String) {
        do {
            // Removes all tokens from the cache for this application for the provided account; - account: The account to remove from the cache
            let parameters = MSALSignoutParameters(webviewParameters: self.webViewParameters)
            parameters.signoutFromBrowser = false // set this to true if you also want to signout from browser or webview
            let success = try await self.msalClient.signout(with: account, signoutParameters: parameters)
            return (nil, success ? "Sign out completed successfully" : "Sign out completed unsuccessfully")
        } catch {
            return (nil, "Couldn't sign out account with error: \(error)")
        }
    }
    
    func _getAccount(allowInteractive: Bool) async throws -> (MSALResult?, String) {
        
        let account: MSGraph.Account?
        do {
            let msalParameters = MSALParameters()
            msalParameters.completionBlockQueue = DispatchQueue.main
            (account, _) = try await msalClient.currentAccount(with: msalParameters)
        } catch {
            throw MSALAppError.getAccount(error)
        }
            
        return try await _getToken(allowInteractive: allowInteractive, account: account)
    }
    
    func _getToken(allowInteractive: Bool, account: MSGraph.Account?) async throws -> (MSALResult?, String) {
        
        guard let account else {
            // We check to see if we have a current logged in account.
            // If we don't, then we need to sign someone in.
            return try await _getTokenInteractively(allowInteractive: allowInteractive)
        }

        do {
            return try await _getTokenSilently(account: account)
        } catch MSALAppError.getTokenInteractively(let nsError as NSError) where
            allowInteractive &&
            nsError.domain == MSALErrorDomain &&
            nsError.code == MSALError.interactionRequired.rawValue
        {
            // interactionRequired means we need to ask the user to sign-in. This usually happens
            // when the user's Refresh Token is expired or if the user has changed their password
            // among other possible reasons.
            return try await _getTokenInteractively(allowInteractive: allowInteractive)
        }
    }
    
    func _getTokenSilently(account: MSGraph.Account) async throws -> (MSALResult?, String) {
        do {
            /**
             
             Acquire a token for an existing account silently
             
             - forScopes:           Permissions you want included in the access token received
             in the result in the completionBlock. Not all scopes are
             guaranteed to be included in the access token returned.
             - account:             An account object that we retrieved from the application object before that the
             authentication flow will be locked down to.
             - completionBlock:     The completion block that will be called when the authentication
             flow completes, or encounters an error.
             */
            let parameters = MSALSilentTokenParameters(scopes: scopes, account: account)
            let result = try await msalClient.acquireTokenSilent(with: parameters)
            return (result, "accessToken=\(result.accessToken)")
        } catch {
            throw MSALAppError.getTokenInteractively(error)
        }
    }
    
    func _getTokenInteractively(allowInteractive: Bool) async throws -> (MSALResult?, String) {
        guard allowInteractive else {
            // We check to see if we have a current logged in account.
            // If we don't, then we need to sign someone in.
            throw MSALAppError.getTokenInteractivelyDoNotAllow
        }
        
        do {
            let parameters = MSALInteractiveTokenParameters(scopes: scopes, webviewParameters: webViewParameters)
            parameters.promptType = .selectAccount
            let result = try await msalClient.acquireToken(with: parameters)
            return (result, "accessToken=\(result.accessToken)")
        } catch {
            throw MSALAppError.getTokenInteractively(error)
        }
    }
}
 */

/*let items = {
    var value: CFTypeRef?
    
    let kGeneralTypePrefix = 3000
    let query = [
        ✅kSecMatchLimit               : kSecMatchLimitAll as String, // kSecMatchLimitAll
        
        kSecUseDataProtectionKeychain: true,

        ✅kSecAttrAccessGroup2          : "ED72FQVT6C.com.microsoft.identity.universalstorage",
        ✅kSecClass                    : kSecClassGenericPassword as String,
        kSecReturnAttributes         : true,
        kSecReturnData               : true,
        kSecAttrType                 : kGeneralTypePrefix + MSIDGeneralCacheItemType.appMetadataType.rawValue
    ]  as [String: Any]
    
    assert(SecItemCopyMatching(query as CFDictionary, &value) == errSecSuccess)
    
    let items = value as! [NSDictionary]
    return items.map { item in
        let data = item[kSecValueData as String] as! Data
        let cacheItem = MSIDCacheItemJsonSerializer().deserializeCacheItem(data, of: MSIDAppMetadataCacheItem.self) as! MSIDAppMetadataCacheItem
        return cacheItem
    }
}()*/

// SecItemAdd
