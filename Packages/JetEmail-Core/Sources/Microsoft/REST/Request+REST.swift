//
//  MSGraph.Session.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/18/24.
//

import Foundation



/*

extension Microsoft {
    struct Session {
        let endpointURL         : URL
        let accessToken         : String
        let authorizationHeader : String
        let authenticationScheme: String
        let expiresOn           : Date?
    }
    
}



extension Session {
    init(endpointURL: URL, result: MSALResult) {
        self.init(
            endpointURL         : endpointURL,
            accessToken         : result.accessToken,
            authorizationHeader : result.authorizationHeader,
            authenticationScheme: result.authenticationScheme,
            expiresOn           : result.expiresOn
        )
        
        
        /*
         print(result.authority.url) // https://login.microsoftonline.com/9188040d-6c67-4c5b-b112-36a304b66dad
         print(result.tenantProfile.environment) // login.windows.net
         print(result.tenantProfile.identifier) // 00000000-0000-0000-6a55-0f478222bc8f
         print(result.tenantProfile.tenantId) // 9188040d-6c67-4c5b-b112-36a304b66dad
         print(result.tenantProfile.isHomeTenantProfile)
         */
    }
}

*/


// MARK: - Context: Account-MailFolders API

public extension Session {
    func getRootMailFolder() async throws -> MailFolder {
        try await getMailFolder(wellKnownFolderName: .msgFolderRoot)
    }
      
    /*func getMailFolders() async throws -> [MSGraph.MailFolder] {
        try await getItems("mailFolders")
    }*/
    
    func getChildFolders(id: MailFolder.ID) async throws -> [MailFolder]  {
        try await getValues("mailFolders", "\(id)", "childFolders")
    }
    
    fileprivate func getMailFolder(id: MailFolder.ID)  async throws -> MailFolder {
        try await getValue("mailFolders", "\(id)")
    }
    
    func getMailFolder(wellKnownFolderName: MailFolder.WellKnownFolderName) async throws -> MailFolder {
        try await getValue("mailFolders", "\(wellKnownFolderName)")
    }
    
    /*func createChildFolder(id: MSGraph.MailFolder.ID, displayName: String, isHidden: Bool? = nil) async throws -> MSGraph.MailFolder {
        try await postItem("mailFolders", "\(id)", "childFolders", body: MailFoldersCreateRequestBody(displayName: displayName, isHidden: isHidden))
    }*/
}


// MARK: - MSGraph: MailFolder-Messaages API

public extension Session {
    
    // https://learn.microsoft.com/en-us/graph/api/mailfolder-list-messages
    func getMessages(id: MailFolder.ID) async throws -> [Message] {
        try await getValues("mailFolders", "\(id)", "messages", queryItems: [
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
        ])
    }
    
    // pageSize => $top: 1-1000, default: 10
    func getMessagesStream(id: MailFolder.ID, pageSize: Int? = nil) async throws -> (count: Int, stream: AsyncThrowingStream<[Message], Error>)  {
        try await getValuesStream("mailFolders", "\(id)", "messages", queryItems: [
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
        ])
    }
}

// MARK: - MSGraph: Messaage API

public extension Session {
    
    // https://learn.microsoft.com/en-us/graph/api/message-get
    func getMessage(microsoftID: Message.ID) async throws -> Message {
        var message: Message = try await getValue("messages", "\(microsoftID)", queryItems: [
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
        ])
        message.raw = try await getMultipartData("messages", "\(microsoftID)", "$value")
        return message
    }
    
    // https://learn.microsoft.com/en-us/graph/api/message-move?view=graph-rest-1.0
    func moveMessage(id messageID: Message.ID, to toID: MailFolder.ID) async throws -> Message {
        struct MessageMoveRequestBody : Encodable {
            let destinationId: MailFolder.ID
        }
        return try await postItem("messages", "\(messageID)", "move", body: MessageMoveRequestBody(destinationId: toID))
    }
}

// MARK: - MSGraph: Get, Post API

fileprivate extension Session {
    
    var endpointURL: URL { Client.endpointURL }
    
    func getResponseString(url: URL) async throws -> String {
        try await URLRequest._get(url: url)._settingAuthorization(header: authorizationHeader).responseString
    }
    
    func getResponseDataForString(url: URL) async throws -> Data {
        try await URLRequest._get(url: url)._settingAuthorization(header: authorizationHeader).responseDataForString
    }
    
    func getResponse<Value: Decodable>(_ type: Value.Type = Value.self, url: URL) async throws -> Value {
        try await URLRequest._get(url: url)._settingAuthorization(header: authorizationHeader).responseJSON(Value.self)
    }
    
    func postResponse<RequestBody: Encodable, Value: Decodable>(url: URL, body: RequestBody, _ type: Value.Type = Value.self) async throws -> Value {
        try await URLRequest._post(url: url, body: body)._settingAuthorization(header: authorizationHeader).responseJSON(Value.self)
    }
}

fileprivate extension Session {

    func getMultipartData(_ paths: String..., queryItems: [URLQueryItem] = []) async throws -> Data {
        var url = paths.reduce(endpointURL) { $0.appending(path: $1) }
        if queryItems.count > 0 { url.append(queryItems: queryItems) }
        return try await getResponseDataForString(url: url)
    }
    
    func getValue<Value: Decodable>(type: Value.Type = Value.self, _ paths: String..., queryItems: [URLQueryItem] = []) async throws -> Value {
        var url = paths.reduce(endpointURL) { $0.appending(path: $1) }
        if queryItems.count > 0 { url.append(queryItems: queryItems) }
        return try await getResponse(url: url)
    }
    
    func getValues<Value: Decodable>(type: Value.Type = Value.self,  _ paths: String..., queryItems: [URLQueryItem] = []) async throws -> [Value] {
        var url = paths.reduce(endpointURL) { $0.appending(path: $1) }
       
        // get count
        /*let count = try await {
            let url = urlPaths.appending(path: "$count")
            let string = try await getResponseString(url: url)
            guard let count = Int(string) else { throw AuthError.collectionResponseNoCount }
            return count
        }()*/
        
        // get paging results
        
        if queryItems.count > 0 { url.append(queryItems: queryItems) }
        
        var nextLink: URL? = url
        var values = [Value]()
        
        
        while let url = nextLink {
            let response = try await getResponse(GraphCollectionResponse<Value>.self, url: url)
            values.append(contentsOf: response.values)
            nextLink = response.nextLink
        }

        return values
    }
    
    func getValuesStream<Value: Decodable>(type: Value.Type = Value.self,  _ paths: String..., queryItems: [URLQueryItem?] = []) async throws -> (count: Int, stream: AsyncThrowingStream<[Value], Error>) {
        let queryItems = queryItems.compactMap { $0 }.nilIfEmpty
        let url = paths.reduce(endpointURL) { $0.appending(path: $1) }
        
        // get count
        let count = try await {
            let url = url.appending(path: "$count")
            let string = try await getResponseString(url: url)
            guard let count = Int(string) else { throw AuthError.collectionResponseNoCount }
            return count
        }()
        
        let stream: AsyncThrowingStream<[Value], Error> = .init { continuation in Task {
            do {
                // get paging results
                var url = url
                if let queryItems { url.append(queryItems: queryItems) }
                
                var nextLink: URL? = url
                
                while let url = nextLink {
                    let response = try await getResponse(GraphCollectionResponse<Value>.self, url: url)
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
    
    
    func postItem<RequestBody: Encodable, Value: Decodable>(type: Value.Type = Value.self, _ paths: String..., body: RequestBody) async throws -> Value {
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


fileprivate struct GraphCollectionResponse<Value : Decodable> : Decodable {
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
        assert(response.mimeType == "application/json")
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

extension URLQueryItem {
    static func top(_ value: Int) -> URLQueryItem {
        assert(value > 0)
        return .init(name: "$top", value: "\(value)")
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
}

enum URLQueryItemOrder: String {
    case descending = "desc"
    case ascending = "asc"
}

extension String.StringInterpolation {
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


