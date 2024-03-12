//
//  Google+Microsoft.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import JetEmailMicrosoft

/*public extension Message {

    var microsoft: MicrosoftMessage? {
        get {
            try? _graph?.decodeJSON(MicrosoftMessage.self)
        }
        set {
            guard let newValue else { return }
            let inner = newValue.inner
            // self.id           = newValue.id.general
            self.subject      = inner.subject?.nilIfEmpty
            
            self.createdDate  = inner.createdDateTime?     .date
            self.modifiedDate = inner.lastModifiedDateTime?.date
            self.receivedDate = inner.receivedDateTime?    .date
            self.sentDate     = inner.sentDateTime?        .date
            self.date         = receivedDate

            self.sender       = inner.sender?.emailAddress.map(\.rawValue)
            self.from         = inner.from?.emailAddress.map(\.rawValue)
            self.to           = inner.toRecipients? .compactMap(\.emailAddress?.rawValue).joined(separator: ", ").nilIfEmpty
            self.replyTo      = inner.replyTo?      .compactMap(\.emailAddress?.rawValue).joined(separator: ", ").nilIfEmpty
            self.cc           = inner.ccRecipients? .compactMap(\.emailAddress?.rawValue).joined(separator: ", ").nilIfEmpty
            self.bcc          = inner.bccRecipients?.compactMap(\.emailAddress?.rawValue).joined(separator: ", ").nilIfEmpty
            
            self.bodyPreview  = inner.bodyPreview?.nilIfEmpty
            
            if let body = inner.body, let contentType = body.contentType, let content = body.content {
                switch contentType {
                case .html: self.body = .init(text: content, html:content)
                case .text: self.body = .init(text: content, html: nil)
                }
            }
            
            if let raw = newValue.raw { 
                self.raw = raw
            }

            self._graph = try? newValue.jsonString
        }
    }

}*/




//
//  Message+Google.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import JetEmailGoogle
/*
public extension Message {
    var google: GoogleMessage? {
        get {
            try? _google?.decodeJSON(GoogleMessage.self)
        }
    }
    
    func setGoogle(_ google: GoogleMessage) throws {
        // TODO: id
        let inner = google.inner
        if let internalDate = inner.internalDate       { self.date        = internalDate.milliSecondsTimeIntervalSince1970 }
        if let snippet      = inner.snippet            { self.bodyPreview = snippet                                        }
        if let raw          = inner.raw                { self.raw         = raw                                            }
        
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
        
        self._google = try? google.jsonString
    }
}

fileprivate enum MIMEType: String {
    case textPlain            = "text/plain"
    case textHtml             = "text/html"
    case multipartAlternative = "multipart/alternative"
    case multipartMixed       = "multipart/mixed"
}

fileprivate extension GoogleMessageInner.Part {
    var messageBody: Message.Body? { get throws {
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
*/
