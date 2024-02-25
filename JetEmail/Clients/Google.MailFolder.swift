//
//  Google.MailFolder.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

import GoogleAPIClientForREST_Gmail

// MARK: - MailFolder

// https://learn.microsoft.com/en-us/graph/api/resources/mailfolder

extension Google {
    struct MailFolder : Codable {
        let   id: ID
        let name: String?
        let messageListVisibility: MessageListVisibility?
        let labelListVisibility: LabelListVisibility?
        let type: `Type`?
        let messagesTotal: Int?
        let messagesUnread: Int?
        let threadsTotal: Int?
        let threadsUnread: Int?
        let color: Color?
        
        //let image: Data?
        //let backgroundColor: String? //?
        //let isHidden: Bool? //?
       // var itemType: `Type`? //= FolderViewModel.ItemType.folder.rawValue //?
        struct Color : Codable {
            let textColor: String?
            let backgroundColor: String?
        }
        enum MessageListVisibility : String, Codable {
            case show
            case hide
        }
        enum LabelListVisibility : String, Codable {
            case labelShow
            case labelShowIfUnread
            case labelHide
        }
        enum `Type` : String, Codable {
            case system
            case user
        }
        init(id: ID, name: String? = nil, messageListVisibility: MessageListVisibility? = nil, labelListVisibility: LabelListVisibility? = nil, type: Type? = nil, messagesTotal: Int? = nil, messagesUnread: Int? = nil, threadsTotal: Int? = nil, threadsUnread: Int? = nil, color: Color? = nil) {
            self.id = id
            self.name = name
            self.messageListVisibility = messageListVisibility
            self.labelListVisibility = labelListVisibility
            self.type = type
            self.messagesTotal = messagesTotal
            self.messagesUnread = messagesUnread
            self.threadsTotal = threadsTotal
            self.threadsUnread = threadsUnread
            self.color = color
        }
    }
}

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
        
        guard let id = gtlrGmailLabel.identifier else { return nil }
        
        self.id                    = .init(string: id)
        self.name                  = gtlrGmailLabel.name
        self.messageListVisibility = gtlrGmailLabel.messageListVisibility.flatMap(MessageListVisibility.init(rawValue:))
        self.labelListVisibility   = gtlrGmailLabel.labelListVisibility.flatMap(LabelListVisibility.init(rawValue:))
        self.type                  = gtlrGmailLabel.type.flatMap(`Type`.init(rawValue:))
        self.messagesTotal         = gtlrGmailLabel.messagesTotal?.intValue
        self.messagesUnread        = gtlrGmailLabel.messagesUnread?.intValue
        self.threadsTotal          = gtlrGmailLabel.threadsTotal?.intValue
        self.threadsUnread         = gtlrGmailLabel.threadsUnread?.intValue
        self.color                 = gtlrGmailLabel.color.map { .init(textColor: $0.textColor, backgroundColor: $0.backgroundColor) }
        
       //  let image: Data?
        // let backgroundColor: String? //?
        //let isHidden: Bool? //?
        //var itemType: String? = FolderViewModel.ItemType.folder.rawValue //?
        
    }
}


/*
 init(path: String, name: String, image: Data? = nil, backgroundColor: String? = nil, isHidden: Bool? = nil, itemType: String? = nil) {
     self.path = path
     self.name = name
     self.image = image
     self.backgroundColor = backgroundColor
     self.isHidden = isHidden
     self.itemType = itemType
 }
 */
