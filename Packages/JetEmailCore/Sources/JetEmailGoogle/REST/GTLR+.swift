//
//  Google + REST.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

import GoogleAPIClientForREST_Gmail
import JetEmailFoundation

extension GTLRGmail_Label {
    var mailFolderData: GoogleMailFolderData { get throws  {
        guard let innerID = identifier else { throw GmailApiError.missingMessageInfo("identifier") }
        return GoogleMailFolderData(
            id                   : .init(innerID),
            name                 : name,
            messageListVisibility: messageListVisibility.flatMap(GoogleMailFolderData.MessageListVisibility.init(rawValue:)),
            labelListVisibility  : labelListVisibility.flatMap(GoogleMailFolderData.LabelListVisibility.init(rawValue:)),
            type                 : type.flatMap(GoogleMailFolderData.MailFolderType.init(rawValue:)),
            messagesTotal        : messagesTotal?.intValue,
            messagesUnread       : messagesUnread?.intValue,
            threadsTotal         : threadsTotal?.intValue,
            threadsUnread        : threadsUnread?.intValue,
            color                : color.map(\.colorData)
        )
    } }
}

extension GTLRGmail_LabelColor {
    var colorData: GoogleMailFolderData.Color {
        .init(
            textColor      : textColor,
            backgroundColor: backgroundColor
        )
    }
}

extension GTLRGmail_Message {
    var messageData : GoogleMessageData { get throws {
        guard let id = identifier else { throw GmailApiError.missingMessageInfo("id") }
        return .init(
            id          :     id,
            internalDate:     internalDate?.int64Value,
            snippet     :     snippet?.removingHTMLEntities,
            sizeEstimate:     sizeEstimate?.intValue,
            raw         :     raw?.gtlrBase64,
            payload     : try payload?.messagePartData,
            labelIds    :     labelIds,
            threadId    :     threadId,
            historyId   :     historyId?.uint64Value
        )
    } }
}

extension GTLRGmail_MessagePart {
    var messagePartData: GoogleMessageData.Part { get throws {
        .init(
            partID  :     partId?.nilIfEmpty,
            filename:     filename?.nilIfEmpty,
            mimeType:     mimeType?.nilIfEmpty,
            headers : try headers?.map { try $0.headerData },
            body    : try body?.bodyData,
            parts   : try parts?.map { try $0.messagePartData }
        )
    } }
}

extension GTLRGmail_MessagePartHeader {
    var headerData: GoogleMessageData.Part.Header { get throws {
        guard let name, let value else { throw GmailApiError.missingMessageInfo("name") }
        return .init(
            name : name,
            value: value
        )
    } }
}

extension GTLRGmail_MessagePartBody {
    var bodyData: GoogleMessageData.Part.Body? { get throws {
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

