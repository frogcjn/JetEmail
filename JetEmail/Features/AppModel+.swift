//
//  AppModel+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/19/24.
//

import Foundation
import SwiftData
import os





extension AppItemModel where Context == AppModel, Item : ModelItem {
    var appModel: AppModel { context }
    var logger: Logger { appModel.logger }
    var microsoftClient: Microsoft.Client { get async throws { try await appModel.microsoftClient } }
    var    googleClient: Google.Client { get { appModel.googleClient } }

    var isBusy: Bool {
        get { item.isBusy }
        set { item.isBusy = newValue }
    }
}

// MARK: - AppModel: Account Status

extension AppItemModel<Account> {
    
    /*var _hasAccount: Bool {
        get async {
            switch item.modelID.enumValue {
            case .microsoft(let id):
                (try? await microsoftClient.account(id: id)) != nil
            case .google(let id):
                (try? await    googleClient.account(id: id)) != nil
            }
        }
    }
    
    var _hasSession: Bool {
        get async throws {
            switch item.modelID.enumValue {
            case .microsoft(let id):
                try await microsoftClient.hasSession(id: id)
            case .google(let id):
                try await googleClient.hasSession(id: id)
            }
        }
    }*/
    
    /*func updateState() async {
        do {
            print("AppItemModel.updateState")
            item.hasAccount = await _hasAccount
            item.hasSession = try await _hasSession
            print(item.state)
        } catch {
            logger.debug("\(error)")
        }
    }*/
}









/*fileprivate extension AppModel {
    func graphContext(graphID: MicrosoftAPI.Account.ID) async throws -> CombineContext<MicrosoftAPI, MicrosoftAPI.Account> {
        let graphClient = try await MicrosoftAPI.shared
        return .init(context: graphClient, item: try graphClient.account(graphID: graphID))
    }
}*/



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

