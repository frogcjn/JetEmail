//
//  Google + REST.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

import GoogleAPIClientForREST_Gmail
import JetEmailFoundation
import JetEmailData

extension GTLRGmail_Label {
    var mailFolder: GoogleMailFolderInner { get throws  {
        guard let innerID = identifier else { throw GmailApiError.missingMessageInfo("identifier") }
        return GoogleMailFolderInner(
            id                   : .init(innerID),
            name                 : name,
            messageListVisibility: messageListVisibility.flatMap(GoogleMailFolderInner.MessageListVisibility.init(rawValue:)),
            labelListVisibility  : labelListVisibility.flatMap(GoogleMailFolderInner.LabelListVisibility.init(rawValue:)),
            type                 : type.flatMap(GoogleMailFolderInner.MailFolderType.init(rawValue:)),
            messagesTotal        : messagesTotal?.intValue,
            messagesUnread       : messagesUnread?.intValue,
            threadsTotal         : threadsTotal?.intValue,
            threadsUnread        : threadsUnread?.intValue,
            color                : color.map(\.color)
        )
    } }
}

extension GTLRGmail_LabelColor {
    var color: GoogleMailFolderInner.Color {
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
    var messageInnerPartHeader: GoogleMessageInner.Part.Header { get throws {
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

extension String {
    var gtlrBase64: Data? {
        GTLRDecodeWebSafeBase64(self)
    }
}

public extension GoogleMailFolder {
    func with(processedName: String?) -> GoogleMailFolder {
        .init(id: id, inner: inner, processedName: processedName)
    }
}

extension GoogleMailFolderInner {
    func with(accountID: GoogleAccountID, processedName: String? = nil) -> GoogleMailFolder {
        .init(id: .init(accountID: accountID, innerID: id), inner: self, processedName: processedName)
    }
}