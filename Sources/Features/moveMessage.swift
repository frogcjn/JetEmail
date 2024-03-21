//
//  moveTo.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/4/24.
//

import JetEmailData // for MessageID

extension AppModel {
    
    @MainActor // for isClassifying
    func moveMessage(messageID: MessageID, fromID: MailFolderID, toID: MailFolderID) async { // message and mailFolder should in the same context
        guard !messageID.isMoving else { return }
        messageID.isMoving = true
        defer { messageID.isMoving = false }
        
        do {
            guard let session = try await messageID.accountID.refreshSession else { return }

            try await    session.moveMessage(messageID: messageID, fromID: fromID, toID: toID)
            try await modelStore.moveMessage(messageID: messageID, fromID: fromID, toID: toID)
            
            /*// update main thread context
            let from = try mainContext[fromID]
            let   to = try mainContext[toID]
            from._messages = from._messages
              to._messages =   to._messages*/
            
        } catch {
            logger.error("\(error)")
        }
    }
}
