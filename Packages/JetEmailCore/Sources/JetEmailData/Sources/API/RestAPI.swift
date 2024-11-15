//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/24/24.
//

// MARK: Session - Rest API

public protocol RestAPIProtocol {
    associatedtype MailFolderType: MailFolderProtocol
    associatedtype    MessageType:    MessageProtocol

    // MARK: account - mailFolders
    func rootMailFolder() async throws -> MailFolderType
    func loadMailFoldersUnderRoot(root: MailFolderType, modelStore: ModelStore) async throws
    func renameMailFolder(_ displayName: String, for folder: MailFolderType.ID) async throws -> MailFolderType

    // MARK: mailFolder - messages
    func syncMessages(mailFolderID: MailFolderType.ID, modelStore: ModelStore) async throws

    // MARK: message
    func moveMessage(messageID: MessageType.ID, fromID: MailFolderType.ID, toID: MailFolderType.ID) async throws -> MessageType
    func messageBody(messageID: MessageType.ID) async throws -> MessageType
}
