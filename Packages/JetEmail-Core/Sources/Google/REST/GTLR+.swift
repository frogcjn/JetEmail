//
//  Google + REST.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

import GoogleAPIClientForREST_Gmail
import JetEmail_Foundation

extension GTLRGmail_Label {
    var swift: MailFolder { get throws {
        guard let id = identifier else { throw GmailApiError.missingMessageInfo("id") }
        return MailFolder.init(
            id                   : .init(rawValue: id),
            path                 : name,
            messageListVisibility: messageListVisibility.flatMap(MailFolder.MessageListVisibility.init(rawValue:)),
            labelListVisibility  : labelListVisibility.flatMap(MailFolder.LabelListVisibility.init(rawValue:)),
            type                 : type.flatMap(MailFolder.MailFolderType.init(rawValue:)),
            messagesTotal        : messagesTotal?.intValue,
            messagesUnread       : messagesUnread?.intValue,
            threadsTotal         : threadsTotal?.intValue,
            threadsUnread        : threadsUnread?.intValue,
            color                : color.map(\.swift)
        )
    } }
}

extension GTLRGmail_LabelColor {
    var swift: MailFolder.Color {
        .init(
            textColor      : textColor,
            backgroundColor: backgroundColor
        )
    }
}

extension GTLRGmail_Message {
    var swift: Message { get throws {
        guard let stringID = identifier else { throw GmailApiError.missingMessageInfo("id") }
        return Message(
            id          :     .init(rawValue: stringID),
            internalDate:     internalDate?.int64Value,
            snippet     :     snippet?.removingHTMLEntities,
            sizeEstimate:     sizeEstimate?.intValue,
            raw         :     raw?.gtlrBase64,
            payload     : try payload?.swift,
            labelIds    :     labelIds,
            threadId    :     threadId,
            historyId   :     historyId?.uint64Value
        )
    } }
}

extension GTLRGmail_MessagePart {
    var swift: Message.Part { get throws {
        .init(
            partID  :     partId?.nilIfEmpty,
            filename:     filename?.nilIfEmpty,
            mimeType:     mimeType?.nilIfEmpty,
            headers : try headers?.map { try $0.swift },
            body    : try body?.swift,
            parts   : try parts?.map { try $0.swift }
        )
    } }
}

extension GTLRGmail_MessagePartHeader {
    var swift: Message.Part.Header { get throws {
        guard let name, let value else { throw GmailApiError.missingMessageInfo("name") }
        return .init(
            name : name,
            value: value
        )
    } }
}

extension GTLRGmail_MessagePartBody {
    var swift: Message.Part.Body? { get throws {
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

