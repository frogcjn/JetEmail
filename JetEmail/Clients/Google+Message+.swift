//
//  Google+Message+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

import Foundation

/*set {
    guard let google = newValue else { return }
    
    
    
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
    // self.bcc          = graph.bccRecipients?.compactMap(\.emailAddress).nilIfEmpty
    
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
}*/

/*let firstPart = google.payload?.parts?.first { $0.partID == "1" }
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
}*/

/*
 MessageBody
   - text : ""
   - html : nil
   - attachment : nil
 */


/*
    attachments
 */
/*let attachmentsIds = payload.parts?.compactMap { $0.body?.attachmentId } ?? []
var attachments = google.parseAttachments()
if body.hasNoContent, let bodyPartAttachment = google.parseBodyPartAttachment() {
    attachments.append(bodyPartAttachment)
}*/

//self.body = body
// self.size = google.sizeEstimate.flatMap(Int.init)
// self.label = labels
// self.attachmentIds = attachmentIds
// self.attachments = attachments
//self.threadID = google.threadId
//self.rfcu22MegId = rfc822MsgId
//self.raw = google.raw

/*self.init(
    identifier: Identifier(stringId: identifier),
    // convert miliseconds to seconds
    date: Date(timeIntervalSince1970: internalDate / 1000),
    sender: sender,
    subject: subject,
    size: gmailMessage.sizeEstimate.flatMap(Int.init),
    labels: labels,
    attachmentIds: attachmentsIds,
    body: body,
    attachments: attachments,
    threadId: gmailMessage.threadId,
    rfc822MsgId: rfc822MsgId,
    raw: gmailMessage.raw,
    to: to,
    cc: cc,
    bcc: bcc,
    replyTo: replyTo,
    inReplyTo: inReplyTo
)*/

fileprivate enum MIMEType: String {
case textPlain            = "text/plain"
case textHtml             = "text/html"
case multipartAlternative = "multipart/alternative"
case multipartMixed       = "multipart/mixed"
}

extension Google.Message.Part {
    var messageBody: Message.Body? { get throws {
        let html = try firstBodyContent(mimeType: .textHtml)
        let text = try firstBodyContent(mimeType: .textPlain)
        return .init(text: text, html: html)
    } }

    fileprivate func firstBodyContent(mimeType: MIMEType) throws -> String? {
        if let bodyContent = try nonFileParts.firstPart(mimeType: mimeType)?.body?.data?.string { bodyContent }
        else if let bodyContent = try nonFileParts.firstMultipartPart?.parts?.compactMap({ try $0.firstBodyContent(mimeType: mimeType) }).first { bodyContent }
        else if let body = body { try body.data?.string }
        else { nil }
    }

    fileprivate var nonFileParts: [Google.Message.Part] {
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



// Gmail string extension identifier


enum HeaderFieldName {}

extension HeaderFieldName {
// static let me = "me"

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

/*
fileprivate extension Google.Message.Full {
var attachmentParts: [Google.Message.Part] {
payload?.parts?.filter { !$0.filename.isEmptyOrNil } ?? []
}

func parseBodyAttachment() -> MessageAttachment? {
guard let part = payload?.body,
      let attachmentId = part.attachmentId
else { return nil }

return MessageAttachment(
    id: attachmentId,
    name: "body",
    estimatedSize: part.size,
    mimeType: "text/plain"
)
}

func parseAttachments() -> [MessageAttachment] {
attachmentParts.compactMap { (part: Google.Message.Part) -> MessageAttachment? in
    guard let body = part.body, let id = body.attachmentId, let name = part.filename
    else { return nil }

    return MessageAttachment(
        id: id,
        name: name,
        estimatedSize: body.size,
        mimeType: part.mimeType,
        data: body.data
    )
}
}

func parseBodyPartAttachment() -> MessageAttachment? {
guard let body = payload?.parts?.first(where: { $0.mimeType == "text/plain" })?.body,
      let attachmentId = body.attachmentId
else { return nil }

return MessageAttachment(
    id: attachmentId,
    name: "encrypted.asc",
    estimatedSize: body.size,
    mimeType: "text/plain"
)
}
}

fileprivate extension MessageBody {
var hasNoContent: Bool {
text.isEmpty && attachment == nil
}
}

fileprivate extension Optional where Wrapped: Collection {
var isEmptyOrNil: Bool {
 self?.isEmpty ?? true
}
}


struct MessageAttachment: Equatable, Hashable, FileType {
let id           : String
let name         : String
let estimatedSize: Int?
let mimeType     : String?

var treatAs      : String?
var data         : Data?
}


protocol FileType {
var name         : String  { get }
var estimatedSize: Int?    { get }
var mimeType     : String? { get }

var treatAs      : String? { get set }
var data         : Data?   { get set }
}

*/
/*
 enum HeaderFieldValue {
     
     // mailbox-list
     struct From: RawRepresentable {
         let rawValue: String
     }
     
     // mailbox
     struct Sender: RawRepresentable {
         let rawValue: String
     }
     
     // address-list
     struct ReplyTo: RawRepresentable {
         let rawValue: String
     }
     
     // address-list
     struct To: RawRepresentable {
         let rawValue: String
     }
     
     // address-list
     struct CC: RawRepresentable {
         let rawValue: String
     }
     
     // address-list / CFWS
     struct BCC: RawRepresentable {
         let rawValue: String
     }
     
     // mailSpec
     struct DeliveredTo: RawRepresentable {
         let rawValue: String
     }
 }

 extension String {
     var headerValueFrom       : HeaderFieldValue.From        { .init(rawValue: self) }
     var headerValueSender     : HeaderFieldValue.Sender      { .init(rawValue: self) }
     var headerValueReplyTo    : HeaderFieldValue.ReplyTo     { .init(rawValue: self) }
     var headerValueTo         : HeaderFieldValue.To          { .init(rawValue: self) }
     var headerValueCC         : HeaderFieldValue.CC          { .init(rawValue: self) }
     var headerValueBCC        : HeaderFieldValue.BCC         { .init(rawValue: self) }
     var headerValueDeliveredTo: HeaderFieldValue.DeliveredTo { .init(rawValue: self) }
 }

 */
