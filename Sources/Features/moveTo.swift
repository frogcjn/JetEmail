//
//  moveTo.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/4/24.
//

import JetEmailGoogle
import JetEmailFoundation
import JetEmailData

extension AppItemModel<Message> {
    
    @MainActor // for isClassifying
    func move(from moveFrom: MailFolder, to moveTo: MailFolder) async { // message and mailFolder should in the same context
        guard !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        
        do {
            let message = item
            let account = message.mailFolder.account
            guard let session = account.resourceID.storedSession else { return }
            switch session {
            case .microsoft(let session):
                guard let microsoftMessageID = message.resourceID.microsoft else { return }
                _ = try await session.moveMessage(id: microsoftMessageID, to: moveTo.resourceID.microsoft!)
                //item.microsoft = microsoft
            case .google(let session):
                guard let googleMessageID = message.resourceID.google else { return }
                _ = try await session.moveMessage(id: googleMessageID, from: moveFrom.resourceID.google!, to: moveTo.resourceID.google!)
                // try message.setGoogle(
            }
            item.mailFolder = moveTo
        } catch {
            logger.error("\(error)")
        }
    }
}


extension GoogleSession {
    /*@MainActor // for classifyResultText
    func moveTo(account: Account, message: Message, mailFolder: MailFolder) async throws {
        
    }*/
    

}
