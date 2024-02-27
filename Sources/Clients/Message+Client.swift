//
//  Google+Microsoft.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import Microsoft

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
            
            if let raw = microsoft.raw { self.raw = raw }

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


extension Microsoft.EmailAddress {
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

import Google

extension Message {
    var google: Google.Message.Full? {
        get {
            try? _google?.decodeJSON(Google.Message.Full.self)
        }
    }
    
    func setGoogle(_ google: Google.Message.Full) throws {
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
    }
}

fileprivate enum MIMEType: String {
case textPlain            = "text/plain"
case textHtml             = "text/html"
case multipartAlternative = "multipart/alternative"
case multipartMixed       = "multipart/mixed"
}

fileprivate extension Google.Message.Part {
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

    var nonFileParts: [Google.Message.Part] {
        parts?.filter { $0.filename?.nilIfEmpty == nil } ?? []
    }
}

fileprivate extension [Google.Message.Part] {
    func firstPart(mimeType: MIMEType) -> Google.Message.Part? {
        first(where: { $0.mimeType == mimeType.rawValue })
    }

    var firstMultipartPart: Google.Message.Part? {
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

extension Google.Message {
    func _print() {
        print("id:", id) // 18dd9dd6644cb062
        print("threadId:", threadId ?? "nil") // nil
        print("labelIds:", labelIds ?? "nil") // nil
        print("historyId:", historyId ?? "nil") // nil
        print("internalDate:", internalDate ?? "nil") // 1708757181000
        print("sizeEstimate:", sizeEstimate ?? "nil") // nil
        print("snippet:", snippet ?? "nil") // Google Voice &lt;#&gt;BofA: DO NOT share this code. We will NEVER call you or text you for it. Code 484154. Reply HELP if you didn&#39;t request it. 如要回复此消息，请在移动设备或计算机上启动 Google Voice (https://voice.
        print("raw:", raw ?? "nil") // nil
        
        if let payload = payload {
            print("====payload====")
            payload._print()
        }
    }
}

extension Google.Message.Part {
    func _print() {
        print("partID:", partID ?? "nil") // nil
        print("mimeType:", mimeType ?? "nil") // nil
        print("filename:", filename ?? "nil") // nil
        print("headers:", headers?.map { $0.name } ?? "nil") // ["Delivered-To", "Received", "X-Received", "ARC-Seal", "ARC-Message-Signature", "ARC-Authentication-Results", "Return-Path", "Received", "Received-SPF", "Authentication-Results", "DKIM-Signature", "X-Google-DKIM-Signature", "X-Gm-Message-State", "X-Google-Smtp-Source", "MIME-Version", "X-Received", "Message-ID", "Date", "Subject", "From", "To", "Content-Type"]
        print("body:", body ?? "nil") // nil
        
        if let parts = parts {
            for (id, part) in parts.enumerated() {
                print("====part[\(id)]====")
                part._print()
            }
        }
    }
}
