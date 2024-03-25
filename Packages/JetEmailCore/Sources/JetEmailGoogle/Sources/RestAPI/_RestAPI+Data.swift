//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/24/24.
//

import JetEmailData
import struct Foundation.Data

enum _GoogleAPI {
}

// MARK: - Mail Folder

extension _GoogleAPI {
    
    // https://learn.microsoft.com/en-us/graph/api/resources/mailfolder
    struct GoogleMailFolderInner : CodableValueType, Sendable {
        let id                   : String
        let name                 : String?
        let messageListVisibility: MessageListVisibility?
        let labelListVisibility  : LabelListVisibility?
        let type                 : MailFolderType?
        let messagesTotal        : Int?
        let messagesUnread       : Int?
        let threadsTotal         : Int?
        let threadsUnread        : Int?
        let color                : Color?
        
        init(
            id                   : String,
            name                 : String? = nil,
            messageListVisibility: MessageListVisibility? = nil,
            labelListVisibility  : LabelListVisibility? = nil,
            type                 : MailFolderType? = nil,
            messagesTotal        : Int? = nil,
            messagesUnread       : Int? = nil,
            threadsTotal         : Int? = nil,
            threadsUnread        : Int? = nil,
            color                : Color? = nil
        ) {
            self.id                    = id
            self.name                  = name
            self.messageListVisibility = messageListVisibility
            self.labelListVisibility   = labelListVisibility
            self.type                  = type
            self.messagesTotal         = messagesTotal
            self.messagesUnread        = messagesUnread
            self.threadsTotal          = threadsTotal
            self.threadsUnread         = threadsUnread
            self.color                 = color
        }
        
        enum MessageListVisibility : String, CodableValueType, Sendable {
            case show
            case hide
        }
        
        enum LabelListVisibility : String, CodableValueType, Sendable {
            case labelShow
            case labelShowIfUnread
            case labelHide
        }
        
        enum MailFolderType : String, CodableValueType, Sendable {
            case system
            case user
        }
        
        struct Color : CodableValueType, Sendable {
            let textColor: String?
            let backgroundColor: String?
            
            init(textColor: String?, backgroundColor: String?) {
                self.textColor = textColor
                self.backgroundColor = backgroundColor
            }
        }
    }
}

extension GoogleMailFolder {
    func replace(name: String?) -> GoogleMailFolder {
        .init(id: id, _inner: _inner, name: name)
    }



    static func all(accountID: GoogleAccountID) -> GoogleMailFolder {
        let inner = _GoogleAPI.GoogleMailFolderInner(id: .init("ALL"), name: "ALL")
        return inner.outer(accountID: accountID)
    }
}

// MARK: - Message

extension _GoogleAPI {
    
    // https://learn.microsoft.com/en-us/graph/api/resources/message
    struct GoogleMessageInner : IdentifiableValueType, Sendable {
        let                         id: String
        let               internalDate: Int64?
        let                    snippet: String?
        let               sizeEstimate: Int?
        let                        raw: Data?
        
        let                    payload: Part?
        
        let                   labelIds: [String]?
        let                   threadId: String?
        let                  historyId: UInt64?
        
        init(id: String, internalDate: Int64?, snippet: String?, sizeEstimate: Int?, raw: Data?, payload: Part?, labelIds: [String]?, threadId: String?, historyId: UInt64?) {
            self.id = id
            self.internalDate = internalDate
            self.snippet = snippet
            self.sizeEstimate = sizeEstimate
            self.raw = raw
            self.payload = payload
            self.labelIds = labelIds
            self.threadId = threadId
            self.historyId = historyId
        }
        
        struct Part : CodableValueType, Sendable {
            let   partID: String?
            let filename: String?
            let mimeType: String?
            let  headers: [MessageHeader]?
            let     body: Body?
            let    parts: [Part]?
            
            init(partID: String?, filename: String?, mimeType: String?, headers: [MessageHeader]?, body: Body?, parts: [Part]?) {
                self.partID = partID
                self.filename = filename
                self.mimeType = mimeType
                self.headers = headers
                self.body = body
                self.parts = parts
            }
            
            struct Body : CodableValueType, Sendable {
                let size: Int
                let data: Data?
                let attachmentId: String?
                init(size: Int, data: Data?, attachmentId: String?) {
                    self.size = size
                    self.data = data
                    self.attachmentId = attachmentId
                }
            }
        }
    }
    
    fileprivate enum MIMEType: String {
        case textPlain            = "text/plain"
        case textHtml             = "text/html"
        case multipartAlternative = "multipart/alternative"
        case multipartMixed       = "multipart/mixed"
    }
}

extension _GoogleAPI.GoogleMessageInner.Part {
    var messageBody: MessageBody? { get throws {
        let html = try firstBodyContent(mimeType: .textHtml)
        let text = try firstBodyContent(mimeType: .textPlain)
        return .init(text: text, html: html)
    } }

    fileprivate func firstBodyContent(mimeType: _GoogleAPI.MIMEType) throws -> String? {
        if let bodyContent = try nonFileParts.firstPart(mimeType: mimeType)?.body?.data?.string { bodyContent }
        else if let bodyContent = try nonFileParts.firstMultipartPart?.parts?.compactMap({ try $0.firstBodyContent(mimeType: mimeType) }).first { bodyContent }
        else if let body = body { try body.data?.string }
        else { nil }
    }

    fileprivate var nonFileParts: [_GoogleAPI.GoogleMessageInner.Part] {
        parts?.filter { $0.filename?.nilIfEmpty == nil } ?? []
    }
}

fileprivate extension [_GoogleAPI.GoogleMessageInner.Part] {
    func firstPart(mimeType: _GoogleAPI.MIMEType) -> _GoogleAPI.GoogleMessageInner.Part? {
        first(where: { $0.mimeType == mimeType.rawValue })
    }

    var firstMultipartPart: _GoogleAPI.GoogleMessageInner.Part? {
        first { ([.multipartMixed, .multipartAlternative] as [_GoogleAPI.MIMEType]).map(\.rawValue).map(Optional.init).contains($0.mimeType) }
    }
}

// MARK: - Inner -> Outter

extension _GoogleAPI.GoogleMailFolderInner {
    
    func id(accountID: GoogleAccountID) -> GoogleMailFolderID {
        .init(accountID: accountID, innerID: id)
    }
    
    func outer(accountID: GoogleAccountID, name: String? = nil) -> GoogleMailFolder {
        .init(id: id(accountID: accountID), _inner: self, name: name)
    }
}

extension _GoogleAPI.GoogleMessageInner {
    
    func id(accountID: GoogleAccountID) -> GoogleMessageID {
        .init(accountID: accountID, innerID: id)
    }
    
    func outer(accountID: GoogleAccountID, raw: Data?) throws -> GoogleMessage {
        try .init(id: .init(accountID: accountID, innerID: id), _inner: self, raw: raw)
    }
}
