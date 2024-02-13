//
//  ModelContext+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import Foundation
import SwiftData


@ModelActor
actor BackgroundModelActor {}

extension BackgroundModelActor {
    func messages(elements: [Microsoft.Graph.Message], in mailFolder: MailFolder) async throws -> [Message] {
        try await modelContext.messages(elements: elements, in: mailFolder)
    }
}

//let batchSize = 1
extension ModelContext {
    
    func messages(elements: [Microsoft.Graph.Message], in mailFolder: MailFolder) async throws -> [Message] {
        do {
            var messages: [Message] = []
            for element in elements {
                messages.append(try message(element: element, in: mailFolder))
                try save()
                /*if messages.count % batchSize == 0 {
                    try save()
                    await Task.yield()
                }*/
            }
            return messages
        } catch {
            rollback()
            throw error
        }
    }
    
    func message(element: Microsoft.Graph.Message, in mailFolder: MailFolder) throws -> Message {
        if let message = try fetch(FetchDescriptor<Message>(predicate: #Predicate { $0.id == element.id })).first {
            return message
        }
        let message = Message(element: element, in: mailFolder)
        insert(message)
        return message
    }
    
    func mailFolder(element: Microsoft.Graph.MailFolder, in account: Account) throws -> MailFolder {
        if let folder = try fetch(FetchDescriptor<MailFolder>(predicate: #Predicate { $0.id == element.id })).first {
            return folder
        }
        let folder = MailFolder(element: element, in: account)
        insert(folder)
        return folder
    }

    func addMailFolder(element: Microsoft.Graph.MailFolder, parent: MailFolder, in account: Account) throws -> MailFolder {
        
        // insert before check relationship
        let node = try mailFolder(element: element, in: account)
        
        do {
            // check self.root
            guard account.root != nil else { throw TreeError.doNotHaveRoot }

            // check targetParent.account
            guard parent.account == account else { throw TreeError.targetParentNotInThisTree }

            // check node.account
            if node.account != account {
                throw TreeError.notInThisTree
            }
            
            // check node.parent
            if node.parent == nil {
                node.parent = parent
            } else if node.parent != parent {
                throw TreeError.alreadyHaveParent
            }
            
            // check node.children
            // guard node.children.isEmpty else { throw TreeError.alreadyHaveChild }
            
            // sucess
            //_leaf = node
            
            // save
            try save()
        } catch {
            rollback()
            throw error
        }
        return node
    }
}


enum TreeError : Swift.Error {
    case multipleRoot
    case notInThisTree
    case targetParentNotInThisTree
    case noTargetParent
    case alreadyHaveChild
    case nodeAlreadyHaveChild
    case doNotHaveRoot
    case alreadyHaveParent
    case doNotHaveChild
    case doNotHaveRightParent
    case notFound
    case noModelContext
    case noLast
}
