//
//  MSALAPI.swift
//  testEmail
//
//  Created by Cao, Jiannan on 1/31/24.
//

import Foundation
import MSAL

@dynamicMemberLookup
@Observable
class UserContext {
    var app: MSALApp
    private var _loginResult: MSALApp.Result
    var account: MSALAccount { _loginResult.account }
    var accessToken: String { _loginResult.accessToken }

    init(app: MSALApp, loginResult: MSALApp.Result) {
        self.app = app
        self._loginResult = loginResult
    }
    

}

// @dynamicMemberLookup
extension UserContext {
    
    subscript<Value>(dynamicMember keyPath: KeyPath<MSALApp, Value>) -> Value {
        app[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<MSALApp, Value>) -> Value {
        get {
            app[keyPath: keyPath]
        }
        set {
            app[keyPath: keyPath] = newValue
        }
    }
}

extension UserContext {
    func mailFolders() async throws -> MSALAPIResponse<MailFolder> {
        
        // Specify the Graph API endpoint
        let url = self.grapEndPointMeURL.appending(path: "mailFolders").appending(queryItems: [.init(name: "$top", value: "999")])
        
        var request = URLRequest(url: url)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let result = try? JSONDecoder().decode(MSALAPIResponse<MailFolder>.self, from: data) {
                return result
            } else {
                throw MSALAPIError.description("Couldn't deserialize result JSON")
            }
        } catch {
            throw MSALAPIError.description("Couldn't get graph result: \(error)")
        }
    }
    
    func mailFolder(id: MSALAPIMailFolderID)  async throws -> MailFolder {
        
        // Specify the Graph API endpoint
        let url = self.grapEndPointMeURL.appending(path: "mailFolders/\(id)")
        
        var request = URLRequest(url: url)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let result = try? JSONDecoder().decode(MailFolder.self, from: data) {
                return result
            } else {
                throw MSALAPIError.description("Couldn't deserialize result JSON")
            }
        } catch {
            throw MSALAPIError.description("Couldn't get graph result: \(error)")
        }
    }
    
    func mailFolder(name: MailFolderWellknownName)  async throws -> MailFolder {
        
        // Specify the Graph API endpoint
        let url = self.grapEndPointMeURL.appending(path: "mailFolders/\(name)")
        
        var request = URLRequest(url: url)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let result = try? JSONDecoder().decode(MailFolder.self, from: data) {
                return result
            } else {
                throw MSALAPIError.description("Couldn't deserialize result JSON")
            }
        } catch {
            throw MSALAPIError.description("Couldn't get graph result: \(error)")
        }
    }
        
        
    
    func childFolders(id: MSALAPIMailFolderID) async throws -> MSALAPIResponse<MailFolder>  {

        // Specify the Graph API endpoint
        let url = self.grapEndPointMeURL.appending(path: "mailFolders/\(id)/childFolders").appending(queryItems: [.init(name: "$top", value: "999")])
        
        var request = URLRequest(url: url)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let result = try? JSONDecoder().decode(MSALAPIResponse<MailFolder>.self, from: data) {
                return result
            } else {
                throw MSALAPIError.description("Couldn't deserialize result JSON")
            }
        } catch {
            throw MSALAPIError.description("Couldn't get graph result: \(error)")
        }
    }
    
    
    func folderTree() async throws -> Tree<MailFolder> {
        let root = try await TreeNode(value: mailFolder(name: .msgfolderroot))
        let tree = Tree<MailFolder>(root: root)
        
        var queue: [TreeNode<MailFolder>] = [root]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            let children = try await childFolders(id: current.value.id).value.map { TreeNode(parent: current, value: $0) }
            current.children = children
            queue.append(contentsOf: children)
        }
        
        return tree
    }
}

enum MailFolderWellknownName : String {
    case msgfolderroot
}


class Tree<Value> {
    var root: TreeNode<Value>
    
    init(rootValue: Value) {
        self.root = TreeNode(value: rootValue)
    }
    
    init(root: TreeNode<Value>) {
        self.root = root
    }
}

extension TreeNode {
    func descendants() -> [TreeNode<Value>] {
        var queue: [TreeNode<Value>] = [self]
        var result: [TreeNode<Value>] = []
        while !queue.isEmpty {
            print(queue)
            let current = queue.removeFirst()
            result.append(current)
            queue.append(contentsOf: current.children)
        }
        return result
    }
}
    

class TreeNode<Value> {
    weak var parent: TreeNode<Value>? = nil
    var children: [TreeNode<Value>] = []
    var value: Value
    
    init(parent: TreeNode<Value>? = nil, children: [TreeNode<Value>] = [], value: Value) {
        self.parent = parent
        self.children = children
        self.value = value
    }
}


struct MailFolder : Codable {
    let id: MSALAPIMailFolderID
    let displayName: String
    let parentFolderId: String
    let childFolderCount: Int
    let unreadItemCount: Int
    let totalItemCount: Int
    let isHidden: Bool
}

struct MSALAPIMailFolderID : RawRepresentable, Codable, Hashable {
    let rawValue: String
}

extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: MSALAPIMailFolderID) {
        appendInterpolation(value.rawValue)
    }
}

struct MSALAPIResponse<Value : Codable> : Codable {
    let value: [Value]
}

enum MSALAPIError : Error {
    case description(String)
}
