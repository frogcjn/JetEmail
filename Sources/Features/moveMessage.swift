//
//  moveTo.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/4/24.
//

import JetEmailData // for MessageID

extension AppModel {

    func moveMessage(_ message: Message, toSystemName: MailFolderSystemName, in mailFolder: MailFolder, _ account: Account) {
        guard let toID = account.mailFolders.first(where: { $0.systemName == toSystemName })?.resourceID else { return }
        moveMessage(messageID: message.resourceID, fromID: mailFolder.resourceID, toID: toID, accountID: account.resourceID)
    }
    
    func moveAllMessagesToMovePlan(_ messages: [Message], in mailFolder: MailFolder, _ account: Account) {
        messages.forEach { message in
            moveMessageToMovePlan(message, in: mailFolder, account)
        }
    }
    
    func moveMessageToMovePlan(_ message: Message, in mailFolder: MailFolder, _ account: Account) {
        guard let movePlanID = message.movePlanID else { return }
        moveMessage(messageID: message.resourceID, fromID: mailFolder.resourceID, toID: movePlanID, accountID: account.resourceID)
    }
    
    // @MainActor // for isMoving
    fileprivate func moveMessage(messageID: MessageID, fromID: MailFolderID, toID: MailFolderID, accountID: AccountID) { // message and mailFolder should in the same context
        Task {
            guard !messageID.isMoving else { return }
            messageID.isMoving = true
            defer { messageID.isMoving = false }
            
            do {
                _ = try await modelStore.moveMessage(messageID: messageID, fromID: fromID, toID: toID)
                do {
                    guard let session = try await messageID.accountID.refreshSession else { throw AppModelError.noSession }
                    _ = try await session.moveMessage(messageID: messageID, fromID: fromID, toID: toID)
                    
                    // method 1: directly update modelStore
                    
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
                    
                    messageID.movePlanID = nil
                } catch {
                    // recover moveMessage
                    _ = try await modelStore.moveMessage(messageID: messageID, fromID: toID, toID: fromID)
                    throw error
                }
            } catch {
                logger.error("\(error)")
            }
        }
    }
}
