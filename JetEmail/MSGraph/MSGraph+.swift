//
//  MSALApp.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/31/24.
//

import SwiftUI
import MSAL
import SwiftData

// MARK: - MSGraph.Context: App-Accounts API


extension MSGraph.Client {
    func accounts() throws -> [MSGraph.Account] {
        try client.allAccounts().map(MSGraph.Account.init)
    }
    
    func account(graphID: MSGraph.Account.ID) throws -> MSGraph.Account {
        guard let account = try accounts().first(where: { $0.id == graphID }) else {
            throw MSGraphError.noAccountFound
        }
        return account
        /*let parameters = MSALAccountEnumerationParameters(identifier: id.rawValue)
        // parameters.returnOnlySignedInAccounts = true
        guard let account = try await client.accountsFromDevice(for: parameters).first else {
            throw MSGraphError.noAccountFound
        }
        return try .init(account)*/
    }
    
    func addAccount() async throws -> MSGraph.Account {
        let parameters = MSALInteractiveTokenParameters(scopes: scopes, webviewParameters: webViewParameters)
        parameters.promptType = .selectAccount
        return try .init(try await client.acquireToken(with: parameters).account) // interactivelty
    }
    
    func removeAccount(graph: MSGraph.Account) async throws {
        let parameters = MSALSignoutParameters(webviewParameters: self.webViewParameters)
        try await self.client.signout(with: graph.msal, signoutParameters: parameters)
    }
    
    fileprivate func accessToken(account: MSGraph.Account) async throws -> String {
        let parameters = MSALSilentTokenParameters(scopes: scopes, account: account.msal)
        return try await self.client.acquireTokenSilent(with: parameters).accessToken
    }
}


// MARK: - MSGraph.Context: Account-MailFolders API

extension CombineContext<MSGraph.Client, MSGraph.Account> {
    func getRootMailFolder() async throws -> MSGraph.MailFolder {
        try await getMailFolder(wellKnownFolderName: .msgFolderRoot)
    }
      
    /*func getMailFolders() async throws -> [MSGraph.MailFolder] {
        try await getItems("mailFolders")
    }*/
    
    func getChildFolders(graphID: MSGraph.MailFolder.ID) async throws -> [MSGraph.MailFolder]  {
        try await getItems("mailFolders", "\(graphID)", "childFolders")
    }
    
    fileprivate func getMailFolder(graphID: MSGraph.MailFolder.ID)  async throws -> MSGraph.MailFolder {
        try await getItem("mailFolders", "\(graphID)")
    }
    
    fileprivate func getMailFolder(wellKnownFolderName: MSGraph.MailFolder.WellKnownFolderName) async throws -> MSGraph.MailFolder {
        try await getItem("mailFolders", "\(wellKnownFolderName)")
    }
    
    /*func createChildFolder(id: MSGraph.MailFolder.ID, displayName: String, isHidden: Bool? = nil) async throws -> MSGraph.MailFolder {
        try await postItem("mailFolders", "\(id)", "childFolders", body: MailFoldersCreateRequestBody(displayName: displayName, isHidden: isHidden))
    }*/
}


// MARK: - MSGraph: MailFolder-Messaages API

extension CombineContext<MSGraph.Client, MSGraph.Account> {
    
    // https://learn.microsoft.com/en-us/graph/api/mailfolder-list-messages
    func getMessages(graphID: MSGraph.MailFolder.ID) async throws -> [MSGraph.Message] {
        try await getItems("mailFolders", "\(graphID)", "messages", queryItems: [
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
    }
}

// MARK: - MSGraph: Messaage API

extension CombineContext<MSGraph.Client, MSGraph.Account> {
    
    // https://learn.microsoft.com/en-us/graph/api/message-get
    func getMessageBody(graphID: MSGraph.Message.ID) async throws -> MSGraph.Message {
        try await getItem("messages", "\(graphID)", queryItems: [
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
    }
}

// MARK: - MSGraph: Get, Post API

fileprivate extension CombineContext<MSGraph.Client, MSGraph.Account> {

    var accessToken: String {
        get async throws {
            let client = context
            let account = item
            return try await client.accessToken(account: account)
        }
    }

    func getResponse<Value: Decodable>(url: URL, _ type: Value.Type = Value.self) async throws -> Value {
        try await URLRequest._get(url: url)._settingAuthorization(accessToken: accessToken)._response()
    }
    
    func postResponse<RequestBody: Encodable, Value: Decodable>(url: URL, body: RequestBody, _ type: Value.Type = Value.self) async throws -> Value {
        try await URLRequest._post(url: url, body: body)._settingAuthorization(accessToken: accessToken)._response()
    }
        
    func getItem<Value: Decodable>(_ paths: String..., queryItems: [URLQueryItem] = [], _ type: Value.Type = Value.self) async throws -> Value {
        let url = paths.reduce(self.endpointURL) { $0.appending(path: $1) }.appending(queryItems: queryItems)
        return try await getResponse(url: url)
    }
    
    func getItems<Value: Decodable>(type: Value.Type = Value.self,  _ paths: String..., queryItems: [URLQueryItem] = []) async throws -> [Value] {
        let url = paths.reduce(self.endpointURL) { $0.appending(path: $1) }.appending(queryItems: queryItems).appending(queryItems: [.count()])
        let countResponse: GraphCollectionResponse<Value> = try await getResponse(url: url)
        
        guard let count = countResponse.count else { throw MSGraphError.collectionResponseNoCount }
        
        let items = countResponse.value
        if count == items.count {
            return items
        } else {
            let url = url.appending(queryItems: [.top(count)])
            return try await getResponse(url: url, GraphCollectionResponse<Value>.self).value
        }
    }
    
    func postItem<RequestBody: Encodable, Value: Decodable>(type: Value.Type = Value.self, _ paths: String..., body: RequestBody) async throws -> Value {
        let url = paths.reduce(self.endpointURL) { $0.appending(path: $1) }
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
    let value: [Value]

    let  context: URL?
    let    count: Int?
    let nextLink: URL?
    
    enum CodingKeys : String, CodingKey {
        case  context = "@odata.context"
        case    count = "@odata.count"
        case nextLink = "@odata.nextLink"
        case    value
    }
}

// https://learn.microsoft.com/en-us/graph/errors#error-resource-type
fileprivate struct GraphErrorResponse : Codable {
    let error: MSGraph.PublicError
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
    
    private static func _post(url: URL, bodyData: Data) -> Self {
        var request = URLRequest(url: url)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    static func _post<T: Encodable>(url: URL, body: T) throws -> URLRequest {
        _post(url: url, bodyData: try body.jsonData)
    }
    
    func _settingAuthorization(accessToken: String) -> Self {
        var request = self
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func _response<Value: Decodable>(_ type: Value.Type = Value.self) async throws -> Value {
        let (data, _) = try await URLSession.shared.data(for: self)
        return try handleGraphResponse(Value.self, from: data)
    }
    
    func handleGraphResponse<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let result = Result{ try data.jsonDecode(type) }
        switch result {
        case .failure(let failure):
            if let error = try? data.jsonDecode(GraphErrorResponse.self).error {
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
