//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/13/24.
//

import SwiftData  // for @Model
import Foundation // for Date

@Model
class Message : ModelItem {
    
    /// ID for storing in the database, for unique indexing. So this property is only used in #Query.
    @Attribute(.unique)
    private(set) var id: String
    private(set) var platform: String
    private(set) var platformID: String
    
    var modelID: ModelID {
        @storageRestrictions(accesses: _$backingData, initializes: _platform, _platformID, _id)
        init(initialValue) {
            let (platform, platformID, string) = (initialValue.platform, initialValue.platformID, initialValue.string)
            _$backingData.setValue(forKey: \.platform,   to: platform.rawValue)
            _$backingData.setValue(forKey: \.platformID, to: platformID)
            _$backingData.setValue(forKey: \.id,         to: string)

            _platform   = _SwiftDataNoType()
            _platformID = _SwiftDataNoType()
            _id         = _SwiftDataNoType()
        }
        get { .init(platform: .init(rawValue: platform)!, platformID: platformID) }
        set {
            platform   = newValue.platform.rawValue
            platformID = newValue.platformID
            id = newValue.string
        }
    }
    
    
    var      subject: String?
    
    var         date: Date?
    var  createdDate: Date?
    var modifiedDate: Date?
    var receivedDate: Date? // * Important *
    var     sentDate: Date?
    
    var       sender: String?
    var         from: String?
    var           to: [String]? // * Important * to
    var      replyTo: [String]? // 回复给
    var           cc: [String]? // * Important * 抄送, carbon copy
    var          bcc: [String]? // 密件抄送，密送，blind carbon copy*/
    
    var  bodyPreview: String?
    var         body: Body?
    var   uniqueBody: Body?

    
    /// Message.mailFolder <<-> MailFolder.messages
    @Relationship(deleteRule: .nullify)
    var mailFolder: MailFolder
    
    init(modelID: ModelID, in mailFolder: MailFolder) {
        self.modelID          = modelID
        self.mailFolder       = mailFolder
    }
    
    var _graph : String?
    var _google: String?
    
    @MainActor  // for isBusy
    @Attribute(.ephemeral)
    var isBusy = false
    
    var deleteMark = false
    
    var account: Account { mailFolder.account }
}

typealias Recipient = Microsoft.Recipient
typealias Body      = Microsoft.ItemBody


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
            self.date         = self.receivedDate

            self.sender       = microsoft.sender?.emailAddress?.rawValue
            self.from         = microsoft.from?.emailAddress?.rawValue
            self.to           = microsoft.toRecipients? .compactMap(\.emailAddress?.rawValue).nilIfEmpty
            self.replyTo      = microsoft.replyTo?      .compactMap(\.emailAddress?.rawValue).nilIfEmpty
            self.cc           = microsoft.ccRecipients? .compactMap(\.emailAddress?.rawValue).nilIfEmpty
            self.bcc          = microsoft.bccRecipients?.compactMap(\.emailAddress?.rawValue).nilIfEmpty
            
            self.bodyPreview  = microsoft.bodyPreview?.nilIfEmpty
            self.body         = microsoft.body
            self.uniqueBody   = microsoft.uniqueBody

            self._graph = try? microsoft.jsonString
        }
    }
    
    var google: Google.Message? {
        get {
            try? _google?.decodeJSON(Google.Message.self)
        }
        set {
            guard let google = newValue else { return }
            
            func headerValue(name: String) -> String? {
                google.payload?.headers?.first { $0.name == name }?.value
            }
            
            self.modelID      = google.modelID
            self.subject      = headerValue(name: "Subject")
            
            /*self.createdDate  = graph.createdDateTime?     .date
            self.modifiedDate = graph.lastModifiedDateTime?.date*/
            //self.receivedDate = headerValue(name: "Date")?.rfc2822
            self.receivedDate = google.internalDate?.milliSecondsTimeIntervalSince1970
            self.date         = self.receivedDate
            //self.sentDate     = headerValue(name: "Date")?.rfc2822
            
            //self.sender       = graph.sender?.emailAddress
            self.from         = headerValue(name: "From")
            //self.to           = graph.toRecipients? .compactMap(\.emailAddress).nilIfEmpty
            //self.replyTo      = graph.replyTo?      .compactMap(\.emailAddress).nilIfEmpty
            ////self.cc           = graph.ccRecipients? .compactMap(\.emailAddress).nilIfEmpty
            // self.bcc          = graph.bccRecipients?.compactMap(\.emailAddress).nilIfEmpty*/
            
            self.bodyPreview  = google.snippet
            
            
            let firstPart = google.payload?.parts?.first { $0.partID == "1" }
            let firstPartMIME = firstPart?.mimeType
            let firstPartString = try? firstPart?.body?.data?.string
            print(firstPartMIME ?? "nil", firstPartString ?? "nil")
            
            if firstPartMIME == "text/html" {
                self.body  =  .init(content: firstPartString, contentType: .html)
            } else if firstPartMIME == "text/plain" {
                self.body  =  .init(content: firstPartString, contentType: .text)
            } else if firstPartMIME == nil {
                () // self.body  =
            } else {
                fatalError()
            }
            // print(#function, google.payload?.body?.data ?? "nil")
            /*self.uniqueBody   = graph.uniqueBody*/

            self._google = try? google.jsonString
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
