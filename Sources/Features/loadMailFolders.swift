//
//  LoadMailFolders.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

import JetEmail_Foundation
import JetEmail_Data
import Microsoft

// MARK: Feature: Account - Load Mail Folder

extension AppModel {
    @MainActor
    func loadMailFolders(accounts: [Account]) async {
        do {
            try await accounts.map(\.resourceID).forEachTask { @MainActor in try await self($0)?.loadMailFolders() }
        } catch {
            logger.error("\(error)")
        }
    }
}

//@BackgroundActor // for .isBusy
extension AppItemModel<Account> {
    
    @MainActor
    var isBusy: Bool {
        get { item.isBusy }
        set { item.isBusy = newValue }
    }
    
    @MainActor
    func loadMailFolders() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            let account = item
            let accountID = account.resourceID
            guard let session = try await accountID.refreshSession else { return }
            
            // SessionActor
            let platform = try await session.getRootMailFolder(id: accountID)
            
            // ModelActor
            let mailFolderID = try await ModelStore.shared.insertMailFolder(platform: platform, in: accountID)
            
            // MainActor
            _ = try accountID.setRootMailFolder(id: mailFolderID)
            
            
            try await session.loadMailFolders(id: accountID, rootID: mailFolderID)
            account.loadedMailFolder = true
        } catch {
            logger.error("\(error)")
        }
    }
    
}
