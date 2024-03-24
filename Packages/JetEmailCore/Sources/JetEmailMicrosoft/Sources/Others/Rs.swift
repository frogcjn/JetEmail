//
//  MSGraph.Session.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/18/24.
//

import struct Foundation.Data
import struct Foundation.KeyPathComparator

import struct Foundation.URL
import struct Foundation.URLRequest
import struct Foundation.URLQueryItem
import class  Foundation.URLSession

import  protocol JetEmailFoundation.AsyncSequenceOf
import typealias JetEmailFoundation.CodableValueType
import typealias JetEmailFoundation.CodableErrorType
import      enum JetEmailFoundation.JSON

import JetEmailData




// MARK: - FilePrivate Functions







extension _MicrosoftAPI.MicrosoftMessageInner {
    func outer(accountID: MicrosoftAccountID, raw: Data?) -> MicrosoftMessage {
        .init(id: .init(accountID: accountID, innerID: id), _inner: self, raw: raw)
    }
    
    func id(accountID: MicrosoftAccountID) -> MicrosoftMessageID {
        .init(accountID: accountID, innerID: id)
    }
}

extension _MicrosoftAPI.MicrosoftMailFolderInner {
    func with(accountID: MicrosoftAccountID, _systemName: _MicrosoftAPI.MicrosoftMailFolderSystemName?) -> MicrosoftMailFolder {
        .init(id: .init(accountID: accountID, innerID: id), _inner: self, systemName: _systemName?.systemName, name: displayName)
    }
    
    func with(accountID: MicrosoftAccountID, _idToSystemName: [MicrosoftMailFolderID: _MicrosoftAPI.MicrosoftMailFolderSystemName]) -> MicrosoftMailFolder {
        with(accountID: accountID, _systemName: _idToSystemName[MicrosoftMailFolderID(accountID: accountID, innerID: id)])
    }
}


// MARK: - Others

// MARK: - MSGraph: Get, Post API

extension MicrosoftSession {
    
    // var endpointURL: URL { MicrosoftClient.endpointURL }
    
    func getResponseString(url: URL, maxPageSize: Int?) async throws -> String {
        try await URLRequest._get(url: url, authorization: refreshAuthorizationHeader, maxPageSize: maxPageSize).responseString
    }
    
    func getResponseDataForString(url: URL, maxPageSize: Int?) async throws -> Data {
        try await URLRequest._get(url: url, authorization: refreshAuthorizationHeader, maxPageSize: maxPageSize).responseDataForString
    }
    
    func getResponse<Value: Decodable & Sendable>(url: URL, maxPageSize: Int?, responseType: Value.Type = Value.self) async throws -> Value {
        try await URLRequest._get(url: url, authorization: refreshAuthorizationHeader, maxPageSize: maxPageSize).responseDataForJSON.decodeGraphJSON(Value.self)
    }
    
    func postResponse<RequestBody: Encodable, Value: Decodable & Sendable>(url: URL, maxPageSize: Int?, body: RequestBody, responseType: Value.Type = Value.self) async throws -> Value {
        try await URLRequest._post(url: url, authorization: refreshAuthorizationHeader, maxPageSize: maxPageSize, body: body).responseDataForJSON.decodeGraphJSON(Value.self)
    }
}

extension MicrosoftSession {

    func getMultipartData(url: URL, maxPageSize: Int? = nil) async throws -> Data {
        return try await getResponseDataForString(url: url, maxPageSize: maxPageSize)
    }
    
    func getValue<Value: Decodable & Sendable>(url: URL, maxPageSize: Int? = nil, responseType: Value.Type = Value.self) async throws -> Value {
        return try await getResponse(url: url, maxPageSize: maxPageSize)
    }
    
    func getValues<Value: Decodable & Sendable>(url: URL, maxPageSize: Int? = nil, responseType: Value.Type = Value.self) async throws -> [Value] {
        var nextLink: URL? = url
        var values = [Value]()
        
        
        while let url = nextLink {
            let response: GraphCollectionResponse<Value> = try await getResponse(url: url, maxPageSize: maxPageSize)
            values.append(contentsOf: response.values)
            nextLink = response.nextLink
        }

        return values
    }
    
    func getValuesStream<Value: Sendable & Decodable>(url: URL, maxPageSize: Int? = nil, responseType: Value.Type = Value.self) async throws -> (count: Int, stream: AsyncThrowingStream<[Value], Error>) {
        let url: URL =  url.appending(queryItems: [.count()])
        var firlstNextLink: URL?
        
        // get count
        let (count, firstValues) = try await {
            let response: GraphCollectionResponse<Value> = try await getResponse(url: url, maxPageSize: maxPageSize)
            guard let count = response.count else { throw MicrosoftAuthError.collectionResponseNoCount }
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
                    let response: GraphCollectionResponse<Value> = try await getResponse(url: url, maxPageSize: maxPageSize)
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
    
    func getValuesDeltaStream<Value: Sendable & Decodable>(url: URL, maxPageSize: Int? = nil, responseType: Value.Type = Value.self) async throws -> AsyncThrowingStream<Delta<Value>, Error> {
                
        // get count
        let response: GraphCollectionResponse<Value> = try await getResponse(url: url, maxPageSize: maxPageSize)
        let stream: AsyncThrowingStream<Delta<Value>, Error> = .init { continuation in Task { [delta = response.delta] in
            do {
                // get paging results
                
                continuation.yield(delta)
                await Task.yield()

                var nextLink: URL? = delta.nextLink
                
                while let url = nextLink {
                    let response: GraphCollectionResponse<Value> = try await getResponse(url: url, maxPageSize: maxPageSize)
                    continuation.yield(response.delta)
                    await Task.yield()
                    nextLink = response.nextLink
                }
                
                continuation.finish()
            } catch {
                continuation.finish(throwing: error)
            }
        } }
        return stream
    }
    
    func postItem<RequestBody: Encodable, Value: Decodable & Sendable>(url: URL, maxPageSize: Int? = nil, body: RequestBody, responseType: Value.Type = Value.self) async throws -> Value {
        return try await postResponse(url: url, maxPageSize: maxPageSize, body: body)
    }
}

// MARK: - MSGraph: Get, Post API Structs

/*
struct MailFoldersCreateRequestBody : Codable {
    let displayName: String
    let isHidden: Bool?
}*/


fileprivate struct GraphCollectionResponse<Value : Decodable & Sendable> : Decodable, Sendable {
    let values: [Value]

    let   context: URL?
    let     count: Int?
    let  nextLink: URL?
    let deltaLink: URL?
    
    enum CodingKeys : String, CodingKey {
        case   context = "@odata.context"
        case     count = "@odata.count"
        case  nextLink = "@odata.nextLink"
        case deltaLink = "@odata.deltaLink"
        case    values = "value"
    }
}

struct Delta<Value: Sendable & Decodable> {
    let    values: [Value]
    let  nextLink: URL?
    let deltaLink: URL?
    
    func map<Transformed : Sendable>(_ transform: (Value) throws -> Transformed) rethrows -> Delta<Transformed> {
        .init(values: try values.map(transform), nextLink: nextLink, deltaLink: deltaLink)
    }
}

fileprivate extension GraphCollectionResponse {
    var delta: Delta<Value> {
        .init(values: values, nextLink: nextLink, deltaLink: deltaLink)
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
    
    static func _get(url: URL, authorization: String, maxPageSize: Int?) -> Self {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        if let maxPageSize {
            request.setValue("odata.maxpagesize=\(maxPageSize)", forHTTPHeaderField: "Prefer")
        }
        return request
    }
    
    static func _post<T: Encodable>(url: URL, authorization: String, maxPageSize: Int?, body: T) throws -> URLRequest {
        __post(url: url, authorization: authorization, maxPageSize: maxPageSize, bodyData: try body.jsonData)
    }
    
    private static func __post(url: URL, authorization: String, maxPageSize: Int?, bodyData: Data) -> Self {
        var request = URLRequest(url: url)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        if let maxPageSize {
            request.setValue("odata.maxpagesize=\(maxPageSize)", forHTTPHeaderField: "Prefer")
        }
        return request
    }
    
    func _settingAuthorization(header: String) -> Self {
        var request = self
        request.setValue(header, forHTTPHeaderField: "Authorization")
        return request
    }
    
    var responseDataForJSON: Data { get async throws {
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

    /*func responseGraphJSON<T: Decodable>(_ type: T.Type) async throws -> T {
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
    }*/
    

}

extension Data {
    func decodeGraphJSON<T: Decodable>(_ type: T.Type) throws -> T {
        let result = Result { try decodeJSON(type) }
        switch result {
        case .failure(let failure):
            if let error = try? decodeJSON(GraphErrorResponse.self).error {
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
    
    static let selectTotalItemCount: URLQueryItem = .select(
        "totalItemCount"
    )
    
    static let selectForMessagePreview: URLQueryItem = .select(
            "id",
            /*"subject",
            "createdDateTime",
            "lastModifiedDateTime",
            "receivedDateTime",
            "sentDateTime",
            "sender",
            "from",
            "toRecipients",
            "replyTo",
            "ccRecipients",
            "bccRecipients",*/
            "internetMessageHeaders",
            "bodyPreview"
        )
    
    static let selectForMessageBody: URLQueryItem = .select(
            "id",
            /*"subject",
            "createdDateTime",
            "lastModifiedDateTime",
            "receivedDateTime",
            "sentDateTime",
            "sender",
            "from",
            "toRecipients",
            "replyTo",
            "ccRecipients",
            "bccRecipients",*/
            "internetMessageHeaders",
            "bodyPreview",
            "body"
        )
    
    
    static func count(_ value: Bool = true) -> URLQueryItem {
        .init(name: "$count", value: "\(value)")
    }
    
    static func filter(ids: [String]) -> URLQueryItem {
        let ids = ids.map { "'\($0)'" }.joined(separator: ",")
        return  .init(name: "$filter", value: "id in (\(ids))")
    }
}

enum URLQueryItemOrder: String {
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
struct BatchRequest: CodableValueType, Sendable {
    let requests: [Request] // no more than 20
    
    struct Request : CodableValueType, Sendable {
        let id: String
        let method: HTTPMethod
        let url: String
        let headers: [String: String]?
        let body: JSON?
    }
    
    enum HTTPMethod: String, CodableValueType, Sendable {
        case `get` = "GET"
        case post  = "POST"
    }
}

struct BatchResponse: CodableValueType, Sendable {
    let responses: [Response]
    
    struct Response: CodableValueType, Sendable {
        let id: String
        let status: Int
        let headers: [String: String]?
        let body: JSON?
    }
}

enum URLError : CodableErrorType, Sendable {
    case prePathNotTheSame
    case pathComponentNotTheSame
}

extension MicrosoftClient {
    
    /*static var endpointURL: URL {
        MicrosoftClient.endpointURL
    }*/
    
    nonisolated func endpoint(pathComponents: String..., queryItems: URLQueryItem?...) -> URL {
        var url = pathComponents.reduce(endpointURL) {
            $0.appending(path: $1)
        }
        if let queryItems = queryItems.compactMap({ $0 }).nilIfEmpty {
            url.append(queryItems: queryItems) // should not append empty queryItems
        }
        return url
    }
    
    nonisolated func relative(pathComponents: String..., queryItems: URLQueryItem?...) -> String {
        let baseURL = endpointURL
        var url = pathComponents.reduce(baseURL) {
            $0.appending(path: $1)
        }
        if let queryItems = queryItems.compactMap({ $0 }).nilIfEmpty {
            url.append(queryItems: queryItems) // should not append empty queryItems
        }
        return try! url.relative(from: baseURL)
    }
}


fileprivate extension URL {
    func relative(from base: URL) throws -> String {
        // [scheme]://[user[:password]@][host][:port][path:/123]
        var baseURLString = base.absoluteString
        if baseURLString.hasSuffix("/") {
            baseURLString.removeLast()
        }
        
        let absluteString = absoluteString
        
        guard absluteString.hasPrefix(baseURLString) else {  throw URLError.pathComponentNotTheSame }
        return String(absluteString.dropFirst(baseURLString.count))
    }
}

import JetEmailData
import struct Foundation.Data

// The Swift Programming Language
// https://docs.swift.org/swift-book

extension MicrosoftMessage {

    init(id: MicrosoftMessageID, _inner: _MicrosoftAPI.MicrosoftMessageInner, raw: Data?) {
        self.id    = id
        self._inner = _inner
        
        /*
         header fields:
            subject
            date
            from/sender/replyTo
            to/cc/bcc
         */
        if let headers = _inner.internetMessageHeaders {
            self.headers = headers
            self.subject = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.subject.rawValue) == .orderedSame }?.value
            self.from    = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.from   .rawValue) == .orderedSame }?.value
            self.sender  = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.sender .rawValue) == .orderedSame }?.value
            self.replyTo = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.replyTo.rawValue) == .orderedSame }?.value
            self.to      = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.to     .rawValue) == .orderedSame }?.value
            self.cc      = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.cc     .rawValue) == .orderedSame }?.value
            self.bcc     = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.bcc    .rawValue) == .orderedSame }?.value
            self.date    = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.date   .rawValue) == .orderedSame }?.value.rfc2822
        } else {
            self.headers = nil
            self.subject = nil
            self.from    = nil
            self.sender  = nil
            self.replyTo = nil
            self.to      = nil
            self.cc      = nil
            self.bcc     = nil
            self.date    = nil
        }
        
        // Informational fields
        // subject      = inner.subject?.nilIfEmpty
        
        // Mailbox System
        /*receivedDate = inner.receivedDateTime?    .date // 2024-01-30 19:44:34 +0000
         createdDate = inner.createdDateTime?     .date // 2024-03-02 08:20:30 +0000
        modifiedDate = inner.lastModifiedDateTime?.date // 2024-03-02 21:46:30 +0000*/
        
        self.bodyPreview  = _inner.bodyPreview?.nilIfEmpty
        
        if let body = _inner.body, let contentType = body.contentType, let content = body.content {
            self.body = switch contentType {
            case .html: .init(text: content, html:content)
            case .text: .init(text: content, html: nil)
            }
        } else {
            self.body = nil
        }
        
        self.raw = raw
    }

}
