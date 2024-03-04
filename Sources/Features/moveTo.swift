//
//  moveTo.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/4/24.
//

import Google

extension AppItemModel<Message> {
    
    @MainActor // for isClassifying
    func moveTo(mailFolder: MailFolder) async {
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        
        let message = item
        let account = message.mailFolder.account
        do {
            guard let session = account.session else { return }
            switch session {
            case .microsoft(_): () // try await session.moveTo(account: account, message: message)
            case .google(let session):
                guard let googleMessage = message.google, let mailFolderID = mailFolder.googleID else { return }
                try message.setGoogle(try await session.moveMessage(googleMessage, to: mailFolderID), in: mailFolder)
            }
        } catch {
            context.logger.error("\(error)")
        }
    }
}


extension Google.Session {
    /*@MainActor // for classifyResultText
    func moveTo(account: Account, message: Message, mailFolder: MailFolder) async throws {
        
    }*/
    

}
