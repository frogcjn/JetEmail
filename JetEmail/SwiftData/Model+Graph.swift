//
//  Model+Graph.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import SwiftData

// MARK: - Model <-> MSGraph

extension Account {
    convenience init(graph: MSGraph.Account, orderIndex: Int) throws {
        self.init(
            modelID: graph.modelID,
            username: graph.username,
            orderIndex: orderIndex
        )
    }
    
    var graph: MSGraph.Account? {
        @available(macOS, unavailable, message: "Parse Use graph(_ client: MSGraph.Client) instead.")
        @available(iOS, unavailable, message: "Parse Use graph(_ client: MSGraph.Client) instead.")
        get {
            nil // should use graph(_:)
        }
        set {
            guard let graph = newValue else { return }
            self.modelID  = graph.modelID
            self.username = graph.username
        }
    }
    
}


extension MailFolder {
    convenience init(graph: MSGraph.MailFolder, in account: Account) {
        self.init(
            modelID: graph.modelID,
            name   : graph.displayName ?? "",
            in     : account
        )
        
        self._graph = try? graph.jsonString
    }
    
    var graph: MSGraph.MailFolder? {
        get {
            try? _graph?.jsonDecode(MSGraph.MailFolder.self)
        }
        set {
            guard let graph = newValue else { return }
            self.modelID  = graph.modelID
            self.name     = graph.displayName ?? ""
            
            self._graph   = try? graph.jsonString
        }
    }
    
    /*
     func update(graph: MSGraph.MailFolder, in account: Account) {
         self.modelID  = graph.modelID
         self.name     = graph.displayName ?? ""
         self.account  = account
         
         self._graph   = try? graph.jsonString
     }
     */
}

extension Message {

    var graph: MSGraph.Message? {
        get {
            try? _graph?.jsonDecode(MSGraph.Message.self)
        }
        set {
            guard let graph = newValue else { return }
            self.modelID      = graph.modelID
            self.subject      = graph.subject?.nilIfEmpty
            
            self.createdDate  = graph.createdDateTime?     .date
            self.modifiedDate = graph.lastModifiedDateTime?.date
            self.receivedDate = graph.receivedDateTime?    .date
            self.sentDate     = graph.sentDateTime?        .date
            
            self.sender       = graph.sender?.emailAddress
            self.from         = graph.from?.emailAddress
            self.to           = graph.toRecipients? .compactMap(\.emailAddress).nilIfEmpty
            self.replyTo      = graph.replyTo?      .compactMap(\.emailAddress).nilIfEmpty
            self.cc           = graph.ccRecipients? .compactMap(\.emailAddress).nilIfEmpty
            self.bcc          = graph.bccRecipients?.compactMap(\.emailAddress).nilIfEmpty
            
            self.bodyPreview  = graph.bodyPreview?.nilIfEmpty
            self.body         = graph.body
            self.uniqueBody   = graph.uniqueBody

            self._graph = try? graph.jsonString
        }
    }
    
    /*convenience init(graph: MSGraph.Message, in mailFolder: MailFolder) {
        self.init(modelID: graph.modelID, in: mailFolder)
        self.graph = graph
    }*/

    /*var graph: MSGraph.Message {
        get throws {
            guard let _graph else { throw SwiftDataError.noGraphInstance(model: self) }
            return try _graph.jsonDecode(MSGraph.Message.self)
        }
    }*/
}

// MARK: - MSGraph -> MSGraph: ID

extension Account {
    var graphID: MSGraph.Account.ID {
        .init(modelID.string)
    }
    
    func graph(_ client: MSGraph.Client) throws -> MSGraph.Account {
        return try client.account(graphID: graphID)
    }
}

extension MailFolder {
    var graphID: MSGraph.MailFolder.ID {
        .init(modelID.string)
    }
}

extension Message {
    var graphID: MSGraph.Message.ID {
        .init(modelID.string)
    }
}

// MARK: - Model <- MSGraph: ID

extension MSGraph.Account {
    var modelID: Account.ModelID {
        .init(id.string)
    }
    
    /*func model(_ context: ModelContext) throws -> Account? {
        return try context.fetchAccount(modelID: modelID)
    }*/
}

extension MSGraph.MailFolder {
    var modelID: MailFolder.ModelID {
        .init(id.string)
    }
    
    /*func model(_ context: ModelContext) throws -> MailFolder? {
        return try context.fetchMailFolder(modelID: modelID)
    }*/
}

extension MSGraph.Message {
    var modelID: Message.ModelID {
        .init(id.string)
    }
    
    /*func model(_ context: ModelContext) throws -> Message? {
        return try context.message(modelID: modelID)
    }*/
}
