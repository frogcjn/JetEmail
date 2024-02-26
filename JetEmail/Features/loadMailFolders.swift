//
//  LoadMailFolders.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

// MARK: Feature: Account - Load Mail Folder

//@BackgroundActor // for .isBusy
extension AppItemModel<Account> {
    func loadMailFolders() async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        
        await Task.detached { [item, logger] in
            do {
                let account = item
                guard let session = try await account.refreshedIfExpiredSession else { return }
                try await session.loadMailFolders(account: account)
            } catch {
                logger.error("\(error)")
            }
        }.value
    }
}

