//
//  AppModel+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/19/24.
//

import Foundation
import SwiftData
import os

extension AppModel {
    
    // Feature: Accounts - Load Accounts
    @MainActor // for isAppModelBusy
    func loadAccounts() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            // msalAccounts
            let msalAccounts = try await microsoftClient._msalClient.allAccounts()
            
            // msalSessions
            var msalSessions: [Microsoft.MSALSession] = []
            for msalAccount in msalAccounts {
                msalSessions.append(try await microsoftClient._msalRefresh(msalAccount: msalAccount))
            }
            
            // microsoftSessions
            let microsoftSessions = try msalSessions.map { Session.microsoft(id: try $0.id, msalSession: $0) }
            
            // gtmSessions
            let googleSessions = try await Google.SessionKeychainStore.shared.items().map { Session.google(id: $0.id, gtmSession: $0.gtm, keychain: $0.keychain) }
            
            //let googleAccounts = try await googleClient.accounts
            _ = try await modelContainer.mainContext.addSessions(microsoftSessions)
            _ = try await modelContainer.mainContext.addSessions(googleSessions)

            //_ = try await modelContainer.mainContext.setAccounts(googles: googleAccounts)
            
            //let account = try modelContainer.mainContext.fetch(FetchDescriptor<Account>())
            //account.forEach { $0.hasAccount = $0.hasAccount }
        } catch {
            logger.error("\(error)")
        }
        
    }

    // Feature: Accounts - Add Account
    @MainActor // for isAppModelBusy
    func addAccount(platform: Platform) async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
                
        do {
            switch platform {
            case .microsoft:
                let msalSession = try await microsoftClient._msalSignin()
                let session = Session.microsoft(id: try msalSession.id, msalSession: msalSession)
                _ = try modelContainer.mainContext.addSession(session)
            case .google:
                let gtmSession = try await googleClient._gtmSignIn()
                let id = try gtmSession.id
                guard let username = gtmSession.userEmail else { throw Google.AuthError.accountNoIDOrUsername }
                let item = try await Google.SessionKeychainStore.shared.insertItem(id: id, username: username, gtm: gtmSession)
                let session = Session.google(id: item.id, gtmSession: item.gtm, keychain: item.keychain)
                _ = try modelContainer.mainContext.addSession(session)
            }
        } catch {
            logger.error("\(error)")
        }
    }
    
    // Feature: Accounts - Move Accounts
    @MainActor
    func moveAccounts(_ accounts: [Account], fromOffsets source: IndexSet, toOffset destination: Int) async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            _ = try await BackgroundModelActor.shared.moveAccounts(ids: accounts.map(\.persistentID), fromOffsets: source, toOffset: destination)
        } catch {
            logger.error("\(error)")
        }
    }
    
    /*// Feature: Accounts - Remove Account
    /// Remove an account from `MSGraph.Context` and `ModelContext`.
    /// - Parameter account: the account to remove.
    @MainActor // for isAppModelBusy, item.isBusy
    func removeAccountForGoogle(_ model: Account) async {
        await model.removeAccount()
    }*/
    
    /*// Feature: Accounts - Remove Account
    /// Remove an account from `MSGraph.Context` and `ModelContext`.
    /// - Parameter account: the account to remove.
    @MainActor // for isAppModelBusy, item.isBusy
    func removeAccount(_ model: Account) async {
        await AppItemModel(context: self, item: model).delete()
    }*/
}

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

extension AppItemModel<Account> {

    // Feature: Accounts - Remove Account
    @MainActor // for isAppModelBusy, item.isBusy
    func delete() async {
        /*guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
                
        context.willRemoveAccount.send(item)
        
        do {

            switch item.modelID.enumValue {
            case .microsoft(let id):
                _ = try await context.microsoftClient.deleteAccount(id: id)
            case .google(let id):
                _ = try await context.googleClient.deleteAccount(id: id)
            }
            _ = try await BackgroundModelActor.shared.deleteAccount(id: item.persistentID)
        } catch {
            logger.error("\(error)")
        }*/
    }
    
    // Feature: Account - Load MailFloders
    /// Load account's mail folders from `MSGraph.Context` to `ModelContext`.
    @MainActor // for .isBusy
    func loadMailFolders() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        await Task.detached { [appModel, accountPersistentID = item.persistentID] in
            do {
                let microsoftClient = try await appModel.microsoftClient
                try await BackgroundModelActor.shared.loadAccountMailFolders(client: microsoftClient, account: accountPersistentID)
            } catch {
                appModel.logger.error("\(error)")
            }
        }.value
    }
    
}

// MARK: - AppModel: MailFolder-Messages API

extension AppItemModel<MailFolder> {
    // Feature: MailFolder - Load Messages
    @MainActor // for .isBusy
    func loadMessages() async {
        /*guard case .microsoft(let accountMicrosoftID) = item.account.modelID.enumValue else { return }
        guard case .microsoft(let microsoftMailFolderID) = item.modelID.enumValue else { return }
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        await Task.detached { [logger] in
            do {
                let item = self.item
                let microsoftAccount = try await self.microsoftClient.account(id: accountMicrosoftID)
                
                let microsoftMessages = try await microsoftAccount.getMessages(microsoftID: microsoftMailFolderID) // load from MSAL
                _ = try await BackgroundModelActor.shared.setMessages(microsoft: microsoftMessages, in: item.persistentID) // MSAL to SwiftData
            } catch {
                logger.error("\(error)")
            }
        }.value*/
    }
}

// MARK: - AppModel: Message API
extension AppItemModel<Message> {
    // Feature: Message - Load Body
    @MainActor // for .isBusy
    func loadBody() async {
        /*guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        guard case .microsoft(let microsoftAccountID) = item.mailFolder.account.modelID.enumValue else { return }
        guard case .microsoft(let microsoftMessageID) = item.modelID.enumValue else { return }

        do {
            let microsoftAccount = try await microsoftClient.account(id: microsoftAccountID)
            let microsoftMessage = try await microsoftAccount.getMessageBody(microsoftID: microsoftMessageID) // load from MSAL
            _ = try await BackgroundModelActor.shared.setMessage(microsoft: microsoftMessage, to: item.modelID) // MSAL to SwiftData
        } catch {
            logger.error("\(error)")
        }*/
    }
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

