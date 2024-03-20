//
//  moveTo.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/4/24.
//

import JetEmailData // for MessageID

extension AppModel {
    
    @MainActor // for isClassifying
    func move(messageID: MessageID, fromID: MailFolderID, toID: MailFolderID) async { // message and mailFolder should in the same context
        guard !messageID.isBusy else { return }
        messageID.isBusy = true
        defer { messageID.isBusy = false }
        
        do {
            guard let session = try await messageID.accountID.refreshSession else { return }

            try await    session.moveMessage(messageID: messageID, fromID: fromID, toID: toID)
            try await modelStore.moveMessage(messageID: messageID, fromID: fromID, toID: toID)
            
            // update main thread context
            let from = try mainContext[fromID]
            let   to = try mainContext[toID]
            from._messages = from._messages
              to._messages =   to._messages
            
        } catch {
            logger.error("\(error)")
        }
    }
}
