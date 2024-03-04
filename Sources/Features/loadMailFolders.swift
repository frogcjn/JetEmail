//
//  LoadMailFolders.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

import JetEmail_Foundation

// MARK: Feature: Account - Load Mail Folder

//@BackgroundActor // for .isBusy
extension AppItemModel<Account> {
    
    var isBusy: Bool {
        get { item.isBusy }
        set { item.isBusy = newValue }
    }
    
    func loadMailFolders() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
           try await _loadMailFolders()
        } catch {
            logger.error("\(error)")
        }
    }
    
    @BackgroundActor
    private func _loadMailFolders() async throws {
        let account = item
        guard let session = try await account.refreshedIfExpiredSession else { return }
        try await session.loadMailFolders(account: account)
    }
}

