//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import JetEmailID
import JetEmailFoundation
import struct Foundation.Data
import struct Foundation.Date

public struct GoogleMessage : GoogleProtocol, PlatformSpecificMessageProtocol, GetMessageProtocol {
    public typealias GeneralID = MessageID
    
    public let    id       : GoogleMessageID
    public let inner       : GoogleMessageInner
    
    public var subject     : String?
    
    public var from        : String?
    public var sender      : String?
    public var replyTo     : String?
    
    public var to          : String?
    public var cc          : String?
    public var bcc         : String?
    public var deliveredTo : String?
    
    public var date        : Date?
    public var createdDate : Date?
    public var modifiedDate: Date?
    public var receivedDate: Date?
    public var sentDate    : Date?
    
    public var bodyPreview: String?
    public var body       : MessageBody?
    public var raw        : Data?
        
    public init(id: GoogleMessageID, inner: GoogleMessageInner, raw: Data?) throws {
        self.id    = id
        self.inner = inner
        
        // TODO: id
        if let internalDate = inner.internalDate       { date        = internalDate.milliSecondsTimeIntervalSince1970 }
        if let snippet      = inner.snippet            { bodyPreview = snippet                                        }
        if let raw          = inner.raw                { self.raw    = raw                                            }
        
        if let headers = inner.payload?.headers {
            /*
             header fields:
                subject
                from/sender/replyTo/to/cc/bcc
                messageID/inReplyTo/references
             */
            for header in headers {
                let name  = header.name
                let value = header.value
                
                switch name {
                    
                case HeaderFieldName.subject    : subject     = value
                    
                    // Originator Fields
                case HeaderFieldName.from       : from        = value
                case HeaderFieldName.sender     : sender      = value
                case HeaderFieldName.replyTo    : replyTo     = value
                    
                    // Destination Address Fields
                case HeaderFieldName.to         : to          = value
                case HeaderFieldName.cc         : cc          = value
                case HeaderFieldName.bcc        : bcc         = value
                case HeaderFieldName.deliveredTo: deliveredTo = value
                    
                default: break
                }
            }
        }
        
        if let body = try inner.payload?.messageBody {
            self.body = body
        }
    }
}
// https://learn.microsoft.com/en-us/graph/api/resources/message
public struct GoogleMessageInner : IdentifiableValueType, Sendable {
    public let                         id: String
    public let               internalDate: Int64?
    public let                    snippet: String?
    public let               sizeEstimate: Int?
    public let                        raw: Data?
    
    public let                    payload: Part?
    
    public let                   labelIds: [String]?
    public let                   threadId: String?
    public let                  historyId: UInt64?
    
    public init(id: String, internalDate: Int64?, snippet: String?, sizeEstimate: Int?, raw: Data?, payload: Part?, labelIds: [String]?, threadId: String?, historyId: UInt64?) {
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
    
    public struct Part : CodableValueType, Sendable {
        public let   partID: String?
        public let filename: String?
        public let mimeType: String?
        public let  headers: [Header]?
        public let     body: Body?
        public let    parts: [Part]?
        
        public init(partID: String?, filename: String?, mimeType: String?, headers: [Header]?, body: Body?, parts: [Part]?) {
            self.partID = partID
            self.filename = filename
            self.mimeType = mimeType
            self.headers = headers
            self.body = body
            self.parts = parts
        }
        
        public struct Header : CodableValueType, Sendable {
            public let name: String
            public let value: String?
            public init(name: String, value: String?) {
                self.name = name
                self.value = value
            }
        }
        
        public struct Body : CodableValueType, Sendable {
            public let size: Int
            public let data: Data?
            public let attachmentId: String?
            public init(size: Int, data: Data?, attachmentId: String?) {
                self.size = size
                self.data = data
                self.attachmentId = attachmentId
            }
        }
    }
}

fileprivate enum HeaderFieldName {}

extension HeaderFieldName {
    static let subject     = "Subject"

    static let from        = "From"
    static let sender      = "Sender"
    static let replyTo     = "Reply-To"

    static let to          = "To"
    static let cc          = "Cc"
    static let bcc         = "Bcc"
    static let deliveredTo = "Delivered-To"

    static let date        = "Date"

    static let messageID   = "Message-ID"
    static let inReplyTo   = "In-Reply-To"
    static let references  = "References"
}

fileprivate enum MIMEType: String {
    case textPlain            = "text/plain"
    case textHtml             = "text/html"
    case multipartAlternative = "multipart/alternative"
    case multipartMixed       = "multipart/mixed"
}

fileprivate extension GoogleMessageInner.Part {
    var messageBody: MessageBody? { get throws {
        let html = try firstBodyContent(mimeType: .textHtml)
        let text = try firstBodyContent(mimeType: .textPlain)
        return .init(text: text, html: html)
    } }

    func firstBodyContent(mimeType: MIMEType) throws -> String? {
        if let bodyContent = try nonFileParts.firstPart(mimeType: mimeType)?.body?.data?.string { bodyContent }
        else if let bodyContent = try nonFileParts.firstMultipartPart?.parts?.compactMap({ try $0.firstBodyContent(mimeType: mimeType) }).first { bodyContent }
        else if let body = body { try body.data?.string }
        else { nil }
    }

    var nonFileParts: [GoogleMessageInner.Part] {
        parts?.filter { $0.filename?.nilIfEmpty == nil } ?? []
    }
}

fileprivate extension [GoogleMessageInner.Part] {
    func firstPart(mimeType: MIMEType) -> GoogleMessageInner.Part? {
        first(where: { $0.mimeType == mimeType.rawValue })
    }

    var firstMultipartPart: GoogleMessageInner.Part? {
        first { ([.multipartMixed, .multipartAlternative] as [MIMEType]).map(\.rawValue).map(Optional.init).contains($0.mimeType) }
    }
}
