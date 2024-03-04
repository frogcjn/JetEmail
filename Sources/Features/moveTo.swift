//
//  moveTo.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/4/24.
//

import Google
import JetEmail_Foundation

extension AppItemModel<Message> {
    
    @MainActor // for isClassifying
    func moveTo(mailFolder: MailFolder) async { // message and mailFolder should in the same context
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            try await _moveTo(mailFolder: mailFolder)
        } catch {
            logger.error("\(error)")
        }
    }
    
    @BackgroundActor
    func _moveTo(mailFolder: MailFolder) async throws {
        let message = item
        let account = message.mailFolder.account
        guard let session = account.session else { return }
        switch session {
        case .microsoft(_): () // try await session.moveTo(account: account, message: message)
        case .google(let session):
            guard let googleMessage = message.google, let googleID = mailFolder.googleID else { return }
            try message.setGoogle(try await session.moveMessage(googleMessage, to: googleID))
            message.mailFolder = mailFolder
        }
    }
}


extension Google.Session {
    /*@MainActor // for classifyResultText
    func moveTo(account: Account, message: Message, mailFolder: MailFolder) async throws {
        
    }*/
    

}
