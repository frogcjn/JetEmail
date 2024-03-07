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
    func move(from moveFrom: MailFolder, to moveTo: MailFolder) async { // message and mailFolder should in the same context
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            let message = item
            let account = message.mailFolder.account
            guard let session = account.modelID.session else { return }
            switch session {
            case .microsoft(let session):
                guard let microsoftMessage = message.microsoft, let moveToID = moveTo.microsoftID else { return }
                let microsoft = try await session.moveMessage(id: microsoftMessage.id, to: moveToID)
                item.microsoft = microsoft
            case .google(let session):
                guard let googleMessage = message.google, let moveFromID = moveFrom.googleID, let moveToID = moveTo.googleID else { return }
                try message.setGoogle(try await session.moveMessage(id: googleMessage.id, from: moveFromID, to: moveToID))
            }
            item.mailFolder = moveTo
        } catch {
            logger.error("\(error)")
        }
    }
}


extension Google.Session {
    /*@MainActor // for classifyResultText
    func moveTo(account: Account, message: Message, mailFolder: MailFolder) async throws {
        
    }*/
    

}
