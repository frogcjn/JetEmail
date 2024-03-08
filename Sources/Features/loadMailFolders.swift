//
//  LoadMailFolders.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

import JetEmail_Foundation
import JetEmail_Data

// MARK: Feature: Account - Load Mail Folder

extension AppModel {
    @MainActor
    func loadMailFolders(accounts: [Account]) async {
        do {
            try await accounts.map(\.id).forEachTask { @MainActor in try await self($0)?.loadMailFolders() }
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
            guard let session = try await account.id.refreshSession else { return }
            try await session.loadMailFolders(persistentID: account.id, modelID: account.id)
            account.root = account.root
        } catch {
            logger.error("\(error)")
        }
    }
}

