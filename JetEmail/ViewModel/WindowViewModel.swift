//
//  WindowViewModel.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/2/24.
//

import SwiftUI

@dynamicMemberLookup
@Observable
class WindowViewModel {
    
    typealias MailFolder = Microsoft.Graph.MailFolder
    
    // init
    var _userContext: UserContext
        
    init(_ userContext: UserContext) {
        _userContext = userContext
    }
    
    // properties
    var splitViewVisibility: NavigationSplitViewVisibility = .automatic
    var selectedMailFolder: MailFolder? = nil
    var selectedMessage: Microsoft.Graph.Message? = nil

    // conversation view model
    private var _conversationViewModel: [MailFolder: MailFolderViewModel] = [:]
    subscript(mailFolder mailFolder: MailFolder) -> MailFolderViewModel {
        get {
            if let navigation = _conversationViewModel[mailFolder] {
                return navigation
            } else {
                let navigation = MailFolderViewModel(self, mailFolder: mailFolder)
                _conversationViewModel[mailFolder] = navigation
                return navigation
            }
        }
    }
    
    // message view model
    private var _messageViewModels: [Microsoft.Graph.Message: MessageViewModel] = [:]
    subscript(message message: Microsoft.Graph.Message) -> MessageViewModel {
        get {
            if let navigation = _messageViewModels[message] {
                return navigation
            } else {
                let navigation = MessageViewModel(self, message: message)
                _messageViewModels[message] = navigation
                return navigation
            }
        }
    }
    
    var isLoadingFolderTree = false
    var tree: Tree<MailFolder>? = nil
    var rootChildren: [TreeNode<MailFolder>] { tree?.root.children ?? [] }
}

extension TreeNode : Identifiable where Element : Identifiable {
    
}

extension TreeNode: Equatable where Element: Equatable {
    static func == (lhs: TreeNode<Element>, rhs: TreeNode<Element>) -> Bool {
        lhs.element == rhs.element
    }
}

extension TreeNode : Hashable where Element : Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(element)
    }
}

extension WindowViewModel {
    func loadFolderTree() async throws {
        guard !self.isLoadingFolderTree else { return }
        self.isLoadingFolderTree = true
        defer { self.isLoadingFolderTree = false }
        
        let root = try await TreeNode(value: self.mailFoldersRequest.getMailFolder(wellKnownFolderName: .msgFolderRoot))
        let tree = Tree<MailFolder>(root: root)
        
        var queue: [TreeNode<MailFolder>] = [root]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            let children = try await self.mailFoldersRequest.getChildFolders(id: current.id).map { TreeNode(parent: current, value: $0) }
            current.children = children
            queue.append(contentsOf: children)
        }
        
        self.tree = tree
    }
    
    func syncFolderTree() async throws {
        guard !self.isLoadingFolderTree else { return }
        self.isLoadingFolderTree = true
        defer { self.isLoadingFolderTree = false }
        
        
        let root  = _userContext.targetFolderTree.root
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
    }
    
}

// @dynamicMemberLookup
extension WindowViewModel {
    subscript<Value>(dynamicMember keyPath: KeyPath<UserContext, Value>) -> Value {
        _userContext[keyPath: keyPath]
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<UserContext, Value>) -> Value {
        get {
            _userContext[keyPath: keyPath]
        }
        set {
            _userContext[keyPath: keyPath] = newValue
        }
    }
}
