//
//  Google+Microsoft.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import JetEmailMicrosoft

public extension Message {

    var microsoft: MicrosoftMessage? {
        get {
            try? _graph?.decodeJSON(MicrosoftMessage.self)
        }
        set {
            guard let newValue else { return }
            let microsoft = newValue.inner
            // self.id           = newValue.id.general
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
            
            if let raw = microsoft.raw { self.raw = raw }

            self._graph = try? microsoft.jsonString
        }
    }

}


extension EmailAddress {
    var rawValue: String {
        if let name { "\(name) <\(address)>" }
        else { address }
    }
}

//
//  Message+Google.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import JetEmailGoogle

public extension Message {
    var google: GoogleMessage? {
        get {
            try? _google?.decodeJSON(GoogleMessage.self)
        }
    }
    
    func setGoogle(_ google: GoogleMessage) throws {
        // TODO: id
        let google = google.data
        if let internalDate = google.internalDate       { self.date        = internalDate.milliSecondsTimeIntervalSince1970 }
        if let snippet      = google.snippet            { self.bodyPreview = snippet                                        }
        if let raw          = google.raw                { self.raw         = raw                                            }
        
        if let headers = google.payload?.headers {
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
        
        if let body = try google.payload?.messageBody {
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

fileprivate extension GoogleMessageData.Part {
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

    var nonFileParts: [GoogleMessageData.Part] {
        parts?.filter { $0.filename?.nilIfEmpty == nil } ?? []
    }
}

fileprivate extension [GoogleMessageData.Part] {
    func firstPart(mimeType: MIMEType) -> GoogleMessageData.Part? {
        first(where: { $0.mimeType == mimeType.rawValue })
    }

    var firstMultipartPart: GoogleMessageData.Part? {
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
