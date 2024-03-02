//
//  Google + REST.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/25/24.
//

import GoogleAPIClientForREST_Gmail

extension GTLRGmail_Label {
    var swift: Google.MailFolder { get throws {
        guard let id = identifier else { throw GmailApiError.missingMessageInfo("id") }
        return Google.MailFolder.init(
            id                   : .init(string: id),
            path                 : name,
            messageListVisibility: messageListVisibility.flatMap(Google.MailFolder.MessageListVisibility.init(rawValue:)),
            labelListVisibility  : labelListVisibility.flatMap(Google.MailFolder.LabelListVisibility.init(rawValue:)),
            type                 : type.flatMap(Google.MailFolder.MailFolderType.init(rawValue:)),
            messagesTotal        : messagesTotal?.intValue,
            messagesUnread       : messagesUnread?.intValue,
            threadsTotal         : threadsTotal?.intValue,
            threadsUnread        : threadsUnread?.intValue,
            color                : color.map(\.swift)
        )
    } }
}

extension GTLRGmail_LabelColor {
    var swift: Google.MailFolder.Color {
        .init(
            textColor      : textColor,
            backgroundColor: backgroundColor
        )
    }
}

extension GTLRGmail_Message {
    var swift: Google.Message.Full { get throws {
        guard let stringID = identifier else { throw GmailApiError.missingMessageInfo("id") }
        return Google.Message.Full(
            id          :     .init(string: stringID),
            internalDate:     internalDate?.int64Value,
            snippet     :     snippet,
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
    var swift: Google.Message.Part { get throws {
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
    var swift: Google.Message.Part.Header { get throws {
        guard let name, let value else { throw GmailApiError.missingMessageInfo("name") }
        return .init(
            name : name,
            value: value
        )
    } }
}

extension GTLRGmail_MessagePartBody {
    var swift: Google.Message.Part.Body? { get throws {
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

/*
// MARK: - Convenience
extension Google.MailFolder {
    init?(gtlrGmailLabel: GTLRGmail_Label) {
        /*guard let name = gmailFolder.name else { return nil }
        guard let id = gmailFolder.identifier else {
            assertionFailure("Gmail folder \(gmailFolder) doesn't have identifier")
            return nil
        }
        // folder.identifier is missing for hidden GTLRGmail_Labels
        if path.isEmpty {
            return nil
        }

        if GeneralConstants.Gmail.standardGmailPaths.contains(path) {
            name = "folder_\(name.replacingOccurrences(of: " ", with: "_"))"
        }*/
        
       
       //  let image: Data?
        // let backgroundColor: String? //?
        //let isHidden: Bool? //?
        //var itemType: String? = FolderViewModel.ItemType.folder.rawValue //?
        
    }
}

 init(path: String, name: String, image: Data? = nil, backgroundColor: String? = nil, isHidden: Bool? = nil, itemType: String? = nil) {
     self.path = path
     self.name = name
     self.image = image
     self.backgroundColor = backgroundColor
     self.isHidden = isHidden
     self.itemType = itemType
 }
 
*/
