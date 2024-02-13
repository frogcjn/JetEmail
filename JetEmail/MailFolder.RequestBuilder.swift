//
//  MailFolder.RequestBuilder.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/7/24.
//

import SwiftUI

import MSAL

// MARK: - MailFolder.RequestBuilder

extension Microsoft.Graph.MailFolder {
    @Observable
    class RequestBuilder {
        typealias MailFolder = Microsoft.Graph.MailFolder
        unowned var _accountContext: AccountViewModel!
        
        func getMailFolder(id: MailFolder.ID)  async throws -> MailFolder {
            try await _accountContext.getItem("mailFolders", "\(id)")
        }
        
        func getMailFolder(wellKnownFolderName: MailFolder.WellKnownFolderName) async throws -> MailFolder {
            try await _accountContext.getItem("mailFolders", "\(wellKnownFolderName)")
        }
        
        func getMailFolders() async throws -> [MailFolder] {
            try await _accountContext.getItems("mailFolders")
        }
        
        func getChildFolders(id: MailFolder.ID) async throws -> [MailFolder]  {
            try await _accountContext.getItems("mailFolders", "\(id)", "childFolders")
        }
        
        // https://learn.microsoft.com/en-us/graph/api/mailfolder-list-messages
        func getMessages(id: MailFolder.ID) async throws -> [Microsoft.Graph.Message] {
            try await _accountContext.getItems("mailFolders", "\(id)", "messages", queryItems: [
                .orderBy(name: "receivedDateTime", .descending),
                .init(name: "$select", value: "id,subject,createdDateTime,lastModifiedDateTime,receivedDateTime,sentDateTime,sender,from,toRecipients,replyTo,ccRecipients,bccRecipients,bodyPreview")
            ])
            /*
             The date and time the message was created.
             The date and time information uses ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z.
             */
        }
        
        func createChildFolder(id: MailFolder.ID, displayName: String, isHidden: Bool? = nil) async throws -> MailFolder {
            try await _accountContext.postItem("mailFolders", "\(id)", "childFolders", body: MailFoldersCreateRequestBody(displayName: displayName, isHidden: isHidden))
        }
    }
}

// MARK: - AccountContext

fileprivate extension AccountViewModel {

    
    func getItem<Value: Decodable>(_ paths: String..., queryItems: [URLQueryItem] = [], _ type: Value.Type = Value.self) async throws -> Value {
        let url = paths.reduce(self.endpointURL) { $0.appending(path: $1) }.appending(queryItems: queryItems)
        return try await getResponse(url: url)
    }
    
    func getItems<Value: Decodable>(type: Value.Type = Value.self,  _ paths: String..., queryItems: [URLQueryItem] = []) async throws -> [Value] {
        let url = paths.reduce(self.endpointURL) { $0.appending(path: $1) }.appending(queryItems: queryItems).appending(queryItems: [.count()])
        let countResponse: GraphCollectionResponse<Value> = try await getResponse(url: url)
       
        guard let count = countResponse.count else {
            throw MSALContext.EndPointError.noCount
        }
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

