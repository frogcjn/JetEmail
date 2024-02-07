//
//  MailFolder.RequestBuilder.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/7/24.
//

import SwiftUI

// MARK: MailFolder.RequestBuilder

extension Microsoft.Graph.MailFolder {
    @Observable
    class RequestBuilder {
        
        typealias MailFolder = Microsoft.Graph.MailFolder
        unowned var _userContext: UserContext!
        
        func getItem<T: Decodable>(type: T.Type = T.self, _ paths: String..., queryItems: [URLQueryItem] = []) async throws -> T {
            try await _userContext.getItem(type, paths, queryItems: queryItems)
        }
        
        func getItems<T: Decodable>(type: T.Type = T.self, _ paths: String..., queryItems: [URLQueryItem] = [], unlimitedPaging: Bool = false) async throws -> [T] {
            try await _userContext.getItems(type, paths, queryItems: queryItems)
        }
        
        func postItem<T: Encodable>(_ paths: String..., body: T) throws -> URLRequest {
            try _userContext.post(paths, body: body)
        }
    }
}

extension Microsoft.Graph.MailFolder.RequestBuilder {

    
    func getMailFolder(id: MailFolder.ID)  async throws -> MailFolder {
        try await getItem("mailFolders", "\(id)")
    }
    
    func getMailFolder(name: MailFolder.WellKnownFolderName)  async throws -> MailFolder {
        try await getItem("mailFolders", "\(name)")
    }
    
    func getMailFolders() async throws -> [MailFolder] {
        try await getItems("mailFolders", unlimitedPaging: true)
    }
    
    func getChildFolders(id: MailFolder.ID) async throws -> [MailFolder]  {
        try await getItems("mailFolders", "\(id)", "childFolders")
    }
    
    
    // https://learn.microsoft.com/en-us/graph/api/mailfolder-list-messages
    func getMessages(id: MailFolder.ID) async throws -> [Microsoft.Graph.Message] {
        try await getItems("mailFolders", "\(id)", "messages", queryItems: [.orderBy(name: "receivedDateTime", .descending)])
    }
    
    func createChildFolder(id: MailFolder.ID, displayName: String, isHidden: Bool? = nil) async throws -> MailFolder {
        try await postItem("mailFolders", "\(id)", "childFolders", body: MailFoldersCreateRequestBody(displayName: displayName, isHidden: isHidden))
            .response(MailFolder.self)
    }
}
