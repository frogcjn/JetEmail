//
//  Google+Microsoft.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//


extension Message {

    var microsoft: Microsoft.Message? {
        get {
            try? _graph?.decodeJSON(Microsoft.Message.self)
        }
        set {
            guard let microsoft = newValue else { return }
            self.modelID      = microsoft.modelID
            self.subject      = microsoft.subject?.nilIfEmpty
            
            self.createdDate  = microsoft.createdDateTime?     .date
            self.modifiedDate = microsoft.lastModifiedDateTime?.date
            self.receivedDate = microsoft.receivedDateTime?    .date
            self.sentDate     = microsoft.sentDateTime?        .date
            self.date         = receivedDate

            self.sender       = microsoft.sender?.emailAddress.map(\.rawValue)
            self.from         = microsoft.from?.emailAddress.map(\.rawValue)
            self.to           = microsoft.toRecipients? .compactMap(\.emailAddress?.rawValue).joined(separator: ", ").nilIfEmpty
            self.replyTo      = microsoft.replyTo?      .compactMap(\.emailAddress?.rawValue).joined(separator: ", ").nilIfEmpty
            self.cc           = microsoft.ccRecipients? .compactMap(\.emailAddress?.rawValue).joined(separator: ", ").nilIfEmpty
            self.bcc          = microsoft.bccRecipients?.compactMap(\.emailAddress?.rawValue).joined(separator: ", ").nilIfEmpty
            
            self.bodyPreview  = microsoft.bodyPreview?.nilIfEmpty
            
            if let body = microsoft.body, let contentType = body.contentType, let content = body.content {
                switch contentType {
                case .html: self.body = .init(text: content, html:content)
                case .text: self.body = .init(text: content, html: nil)
                }
            }

            self._graph = try? microsoft.jsonString
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
