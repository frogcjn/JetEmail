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
    var messageInner : _GoogleAPI.GoogleMessageInner { get throws {
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
    var messageInnerPart: _GoogleAPI.GoogleMessageInner.Part { get throws {
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
    var messageInnerPartBody: _GoogleAPI.GoogleMessageInner.Part.Body? { get throws {
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
