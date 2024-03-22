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

            _ = try await session.moveMessage(messageID: messageID, fromID: fromID, toID: toID)
            
            // method 1: directly update modelStore
            try await modelStore.moveMessage(messageID: messageID, fromID: fromID, toID: toID)
            
            /* or method 2: sync mailFolder's messages from server
            await loadMessages(mailFolderID: fromID)
            await loadMessages(mailFolderID: toID)
             */

            // try await session.syncMessages(mailFolderID:   toID, modelStore: modelStore)

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
