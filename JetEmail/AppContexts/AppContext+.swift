//
//  ViewModel_.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import Foundation
import SwiftData


// MARK: - AppContext: Client-Accounts API

extension AppContext {
    
    // Feature: Accounts - Load Accounts
    /// Load all accounts from `MSGraph.Context` to `ModelContext`.
    @MainActor // for isAppContextBusy
    func loadAccounts() {
        // may remove an account
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        
        do {
            let (graphContext, modelContext) = (graphClient, modelContainer.mainContext)
            let graphs = try graphContext.accounts()
            _ = try modelContext.setAccounts(graphs: graphs)
        } catch {
            logger.error("\(error)")
        }
    }

    // Feature: Accounts - Add Account
    /// Add an account to `MSGraph.Context` and `ModelContext`.
    @MainActor // for isAppContextBusy
    func addAccount() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            let (graphContext, modelContext) = (graphClient, modelContainer.mainContext)
            let gragh = try await graphContext.addAccount()
            _ = try modelContext.addAccount(graph: gragh)
        } catch {
            logger.error("\(error)")
        }
    }
    
    // Feature: Accounts - Remove Account
    /// Remove an account from `MSGraph.Context` and `ModelContext`.
    /// - Parameter account: the account to remove.
    @MainActor // for isAppContextBusy, item.isBusy
    func removeAccount(_ model: Account) async {
        let context = AppContext.Item(context: self, item: model)
        await context.removeAccount()
    }
    
    // Feature: Accounts - Move Accounts
    /// Move accounts to change their orders in `ModelContext`.
    /// - Parameters:
    ///   - accounts: original accounts array.
    ///   - source: An index set representing the offsets of all elements that should be moved.
    ///   - destination: The offset of the element before which to insert the moved elements. destination must be in the closed range 0...count.
    @MainActor
    func moveAccounts(_ accounts: [Account], fromOffsets source: IndexSet, toOffset destination: Int) {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            let modelContext = self.mainContext
            _ = try modelContext.moveAccounts(accounts, fromOffsets: source, toOffset: destination)
        } catch {
            logger.error("\(error)")
        }
    }
}

// MARK: - AppContext: Account-MailFolders API

extension AppContext.Item<Account> {
    
    
    // Feature: Accounts - Remove Account
    @MainActor // for isAppContextBusy, item.isBusy
    fileprivate func removeAccount() async {
        guard !item.isBusy else { return }
        item.isBusy = true
        defer { item.isBusy = false }
        
        
        do {
            let model = item
            self.willRemoveAccount.send(model)
            
            let (graphContext, modelContext) = (context.graphClient, context.modelContainer.mainContext)
            let graph = try model.graph(graphContext)
            try await graphContext.removeAccount(graph: graph)
            _ = try modelContext.removeAccount(model)
        } catch {
            self.logger.error("\(error)")
        }
    }
    
    // Feature: Account - Load MailFloders
    /// Load account's mail folders from `MSGraph.Context` to `ModelContext`.
    @MainActor // for .isBusy
    func loadMailFolders() async {
        guard !item.isBusy else { return }
        item.isBusy = true
        defer { item.isBusy = false }
        

        do {
            try await Task.detached { [item, context] in
                
                let account = item
                let (graphContext, modelContext) = (try context.graphContext(account: account), context.modelContainer.backgroundContext)
                
                let graphRoot = try await graphContext.getRootMailFolder()
                let root = try await modelContext.setRootMailFolder(graph: graphRoot, in: account)
                var queue: [MailFolder] = [root]
                while !queue.isEmpty {
                    let current = queue.removeFirst()
                    let graphs = try await graphContext.getChildFolders(graphID: current.graphID)
                    let children = try await modelContext.setChildrenMailFolders(graphs: graphs, parent: current, in: account)
                    queue.append(contentsOf: children)
                }
            }.value
        } catch {
            self.logger.error("\(error)")
        }
    }
    
}

// MARK: - AppContext: MailFolder-Messages API

extension AppContext.Item<MailFolder> {
    
    // Feature: MailFolder - Load Messages
    /// Load mailfloder's messages  from `MSGraph.Context` to `ModelContext`.
    @MainActor // for .isBusy
    func loadMessages() async {
        guard !item.isBusy else { return }
        item.isBusy = true
        defer { item.isBusy = false }
        
        do {
            try await Task.detached { [item, context] in
                let mailFolder = item
                let account = mailFolder.account
                let (graphContext, modelContext) = (try context.graphContext(account: account), context.modelContainer.backgroundContext)
                
                let graphs = try await graphContext.getMessages(graphID: mailFolder.graphID) // load from MSAL
                _ = try await modelContext.setMessages(graphs: graphs, in: mailFolder) // MSAL to SwiftData
            }.value
        } catch {
            self.logger.error("\(error)")
        }
    }
}

// MARK: - AppContext: Message API
extension AppContext.Item<Message> {
    // Feature: Message - Load Body
    /// Load mailfloder's messages  from `MSGraph.Context` to `ModelContext`.
    @MainActor // for .isBusy
    func loadBody() async {
        guard !item.isBusy else { return }
        item.isBusy = true
        defer { item.isBusy = false }
        
        do {
            let message = item
            let account = message.mailFolder.account
            let (graphContext, modelContext) = (try context.graphContext(account: account), context.modelContainer.mainContext)
            
            let graph = try await graphContext.getMessageBody(graphID: message.graphID) // load from MSAL
            _ = try modelContext.setMessage(graph: graph, to: message) // MSAL to SwiftData
        } catch {
            self.logger.error("\(error)")
        }
    }
}



fileprivate extension AppContext {
    func graphContext(account: Account) throws -> CombineContext<MSGraph.Client, MSGraph.Account> {
        return .init(context: graphClient, item: try account.graph(graphClient))
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

