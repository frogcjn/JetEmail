//
//  LoadMailFolders.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

import JetEmail_Foundation

// MARK: Feature: Account - Load Mail Folder

extension AppModel {
    @MainActor
    func loadMailFolders(accounts: [Account]) async {
        await accounts.map(\.persistentID).forEachTask { @MainActor in await self($0)?.loadMailFolders() }
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
            guard let session = try await account.modelID.refreshedIfExpiredSession else { return }
            try await session.loadMailFolders(persistentID: account.persistentID, modelID: account.modelID)
        } catch {
            logger.error("\(error)")
        }
    }
}

