//
//  Google + REST.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

import GoogleAPIClientForREST_Gmail
import JetEmailData

extension GTLRGmail_Label {
    var mailFolder: _GoogleAPI.GoogleMailFolderInner { get throws  {
        guard let innerID = identifier else { throw GmailApiError.missingMessageInfo("identifier") }
        return _GoogleAPI.GoogleMailFolderInner(
            id                   : .init(innerID),
            name                 : name,
            messageListVisibility: messageListVisibility.flatMap(_GoogleAPI.GoogleMailFolderInner.MessageListVisibility.init(rawValue:)),
            labelListVisibility  : labelListVisibility.flatMap(_GoogleAPI.GoogleMailFolderInner.LabelListVisibility.init(rawValue:)),
            type                 : type.flatMap(_GoogleAPI.GoogleMailFolderInner.MailFolderType.init(rawValue:)),
            messagesTotal        : messagesTotal?.intValue,
            messagesUnread       : messagesUnread?.intValue,
            threadsTotal         : threadsTotal?.intValue,
            threadsUnread        : threadsUnread?.intValue,
            color                : color.map(\.color)
        )
    } }
}

extension GTLRGmail_LabelColor {
    var color: _GoogleAPI.GoogleMailFolderInner.Color {
        .init(
            textColor      : textColor,
            backgroundColor: backgroundColor
        )
    }
}

extension GTLRGmail_Message {
    var messageInner : GoogleMessageInner { get throws {
        guard let id = identifier else { throw GmailApiError.missingMessageInfo("id") }
        return .init(
            id          :     id,
            internalDate:     internalDate?.int64Value,
            snippet     :     snippet?.removingHTMLEntities,
            sizeEstimate:     sizeEstimate?.intValue,
            raw         :     raw?.gtlrBase64,
            payload     : try payload?.messageInnerPart,
            labelIds    :     labelIds,
            threadId    :     threadId,
            historyId   :     historyId?.uint64Value
        )
    } }
}

extension GTLRGmail_MessagePart {
    var messageInnerPart: GoogleMessageInner.Part { get throws {
        .init(
            partID  :     partId?.nilIfEmpty,
            filename:     filename?.nilIfEmpty,
            mimeType:     mimeType?.nilIfEmpty,
            headers : try headers?.map { try $0.messageInnerPartHeader },
            body    : try body?.messageInnerPartBody,
            parts   : try parts?.map { try $0.messageInnerPart }
        )
    } }
}

extension GTLRGmail_MessagePartHeader {
    var messageInnerPartHeader: MessageHeader { get throws {
        guard let name, let value else { throw GmailApiError.missingMessageInfo("name") }
        return .init(
            name : name,
            value: value
        )
    } }
}

extension GTLRGmail_MessagePartBody {
    var messageInnerPartBody: GoogleMessageInner.Part.Body? { get throws {
        guard let size else { throw GmailApiError.missingMessageInfo("size") }
        if size.intValue == 0 && data  == nil { return nil }
        return .init(
            size        : size.intValue,
            data        : data?.gtlrBase64,
            attachmentId: attachmentId
        )
            
    } }
}

fileprivate extension String {
    var gtlrBase64: Data? {
        GTLRDecodeWebSafeBase64(self)
    }
}

extension GTLRGmailService {
    func execute<Q: GTLRQueryProtocol, T: NSObject & Sendable>(_ query: Q, responseType: T.Type = T.self) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            executeQuery(query) { (ticket: GTLRServiceTicket, object: Any?, error: Error?) in
                if let error { return continuation.resume(throwing: GmailApiError.convert(from: error as NSError)) }
                guard let result = object as? T else { return continuation.resume(throwing: AppErr.cast(T.description())) }
                Task {
                    continuation.resume(returning: result)
                }
            }
        }
    }
}


// MARK: - Others

extension GoogleSession {
    var service: GTLRGmailService {
        let service = GTLRGmailService()
        service.authorizer = _item.gtmSession
        service.shouldFetchNextPages = true
        return service
    }
    
    var serviceStream: GTLRGmailService {
        let service = GTLRGmailService()
        service.authorizer = _item.gtmSession
        service.shouldFetchNextPages = false
        return service
    }
}

enum _GoogleAPI {
}

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

extension _GoogleAPI.GoogleMailFolderInner {
    func with(accountID: GoogleAccountID, name: String? = nil) -> GoogleMailFolder {
        .init(id: .init(accountID: accountID, innerID: id), _inner: self, name: name)
    }
}


extension GoogleMessage {
        
    init(id: GoogleMessageID, _inner: GoogleMessageInner, raw: Data?) throws {
        self.id     = id
        self._inner = _inner
        
        /*
         header fields:
            subject
            from/sender/replyTo/to/cc/bcc
            messageID/inReplyTo/references
         */
        
        if let headers = _inner.payload?.headers {
            self.headers = headers
            self.subject = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.subject.rawValue) == .orderedSame }?.value
            self.from    = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.from   .rawValue) == .orderedSame }?.value
            self.sender  = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.sender .rawValue) == .orderedSame }?.value
            self.replyTo = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.replyTo.rawValue) == .orderedSame }?.value
            self.to      = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.to     .rawValue) == .orderedSame }?.value
            self.cc      = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.cc     .rawValue) == .orderedSame }?.value
            self.bcc     = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.bcc    .rawValue) == .orderedSame }?.value
            self.date    = headers.first { $0.name.caseInsensitiveCompare(MessageHeaderName.date   .rawValue) == .orderedSame }?.value.rfc2822
        } else {
            self.headers = nil
            self.subject = nil
            self.from    = nil
            self.sender  = nil
            self.replyTo = nil
            self.to      = nil
            self.cc      = nil
            self.bcc     = nil
            self.date    = nil
        }
        
        self.body        = try _inner.payload?.messageBody
        self.bodyPreview = _inner.snippet
        self.raw         = _inner.raw ?? raw
    }
}
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

enum GetMessageFormat: String, Sendable {
    case raw
    case full
    case metadata
    case minimal
}

extension GoogleMessageInner {
    func outer(accountID: GoogleAccountID, raw: Data?) throws -> GoogleMessage {
        try .init(id: .init(accountID: accountID, innerID: id), _inner: self, raw: raw)
    }
    
    func id(accountID: GoogleAccountID) -> GoogleMessageID {
        .init(accountID: accountID, innerID: id)
    }
}

extension GoogleMailFolder {
    func with(name: String?) -> GoogleMailFolder {
        .init(id: id, _inner: _inner, name: name)
    }
}

extension GoogleMailFolder {

    init(id: GoogleMailFolderID, _inner: _GoogleAPI.GoogleMailFolderInner, name: String? = nil) {
        self.id         = id
        self._inner     = _inner
        self.systemName = _inner.systemName
        self.path       = _inner.name
        self.name       = name ?? _inner.name?.components(separatedBy: "/").last
    }
}
