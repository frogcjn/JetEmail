//
//  MSALAPI.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/31/24.
//

import Foundation
import MSAL
import Observation
import SwiftData

@dynamicMemberLookup
@Observable
class AccountViewModel {
    
    // Window View Model
    private var _windowViewModel: WindowViewModel
    
    // Account
    private var _account: Account
    
    private var _msalAccessToken: String {
        get async throws {
            try await self.msalContext.msalAccessToken(for: _account)
        }
    }
    
    var mailFoldersRequest: Microsoft.Graph.MailFolder.RequestBuilder
    
    init(_ windowViewModel: WindowViewModel, account: Account) {
        _windowViewModel = windowViewModel
        _account = account
        
        mailFoldersRequest = .init()
        mailFoldersRequest._accountContext = self
    }
    
    var isLoadingFolderTree = false
    var rootChildren: [MailFolder] { _account.root?.children ?? [] }
}


extension AccountViewModel {
    func getResponse<Value: Decodable>(url: URL, _ type: Value.Type = Value.self) async throws -> Value {
        try await URLRequest._get(url: url)._settingAuthorization(accessToken: _msalAccessToken)._response()
    }
    
    func postResponse<RequestBody: Encodable, Value: Decodable>(url: URL, body: RequestBody, _ type: Value.Type = Value.self) async throws -> Value {
        try await URLRequest._post(url: url, body: body)._settingAuthorization(accessToken: _msalAccessToken)._response()
    }
    
    @MainActor
    func loadFolderTree() async throws {
        guard !self.isLoadingFolderTree else { return }
        self.isLoadingFolderTree = true
        defer { self.isLoadingFolderTree = false }
        
        let root = try await {
            if let root = _account.root { return root }
            let root = try self.modelContext.mailFolder(element: try await mailFoldersRequest.getMailFolder(wellKnownFolderName: .msgFolderRoot), in: _account)
            _account.root = root
            try self.modelContext.save()
            return root
        }()
        
        var queue: [MailFolder] = [root]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            let children = try await self.mailFoldersRequest.getChildFolders(id: current.id)
            let children2 = try children.map { element in
                return try self.modelContext.addMailFolder(element: element, parent: current, in: _account)
            }
            queue.append(contentsOf: children2)
        }
    }
    
    /*func syncFolderTree() async throws {
        guard !self.isLoadingFolderTree else { return }
        self.isLoadingFolderTree = true
        defer { self.isLoadingFolderTree = false }
        
        
        let root  = TargetFolderPaths.sharedTree.root
        let rootFolder = try await self.mailFoldersRequest.getMailFolder(wellKnownFolderName: .msgFolderRoot)
        
        var queue: [(TreeNode<FolderName>, MailFolder)] = [(root, rootFolder)]
        while !queue.isEmpty {
            let (parent, parentFolder) = queue.removeFirst()
            print("<checking: \(parentFolder.displayName)>")
            for child in parent.children {
                let childName = child.element
                var childFolder: MailFolder
                
                switch childName {
                case .special(let specialName):
                    childFolder = try await self.mailFoldersRequest.getMailFolder(wellKnownFolderName: specialName.graph)
                    // verified existed
                    assert(childFolder.parentFolderId == parentFolder.id)
                    print("    <exists: \(childFolder.displayName)/>")
                case .display(let displayName):
                    let childFolders = try await self.mailFoldersRequest.getChildFolders(id: parentFolder.id)
                    if let mailFolder = childFolders.first(where: { $0.displayName == displayName }) {
                        childFolder = mailFolder
                    } else {
                        childFolder = try await self.mailFoldersRequest.createChildFolder(id: parentFolder.id, displayName: displayName)
                    }
                    print("    <created: \(childFolder.displayName)/>")
                }
                queue.append((child, childFolder))
            }
            print("</checking: \(parentFolder.displayName)>")
        }
        
        // var queue: [TreeNode<String>] = [root]
                
        /*while !queue.isEmpty {
            
        }*/
    }*/
}

// @dynamicMemberLookup
extension AccountViewModel {
    
    subscript<Value>(dynamicMember keyPath: KeyPath<WindowViewModel, Value>) -> Value {
        _windowViewModel[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<WindowViewModel, Value>) -> Value {
        get { _windowViewModel[keyPath: keyPath] }
        set { _windowViewModel[keyPath: keyPath] = newValue }
    }

    
    subscript<Value>(dynamicMember keyPath: KeyPath<Account, Value>) -> Value {
        _account[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Account, Value>) -> Value {
        get {
            _account[keyPath: keyPath]
        }
        set {
            _account[keyPath: keyPath] = newValue
        }
    }
    
    subscript<Value>(dynamicMember keyPath: KeyPath<Microsoft.Graph.MailFolder.RequestBuilder, Value>) -> Value {
        mailFoldersRequest[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Microsoft.Graph.MailFolder.RequestBuilder, Value>) -> Value {
        get {
            mailFoldersRequest[keyPath: keyPath]
        }
        set {
            mailFoldersRequest[keyPath: keyPath] = newValue
        }
    }
}

// MARK: - URLRequest

fileprivate extension URLRequest {
    
    func _settingAuthorization(accessToken: String) -> Self {
        var request = self
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    static func _get(url: URL) -> Self {
        URLRequest(url: url)
    }
    
    static func _post<T: Encodable>(url: URL, body: T) throws -> URLRequest {
        _post(url: url, bodyData: try JSONEncoder().encode(body))
    }
    
    private static func _post(url: URL, bodyData: Data) -> Self {
        var request = URLRequest(url: url)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    func _response<Value: Decodable>(_ type: Value.Type = Value.self) async throws -> Value {
        let (data, _) = try await URLSession.shared.data(for: self)
        return try handleGraphResponse(Value.self, from: data)
    }
}
