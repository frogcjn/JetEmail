//
//  Google.MailFolder.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//


// MARK: - MailFolder

// https://learn.microsoft.com/en-us/graph/api/resources/mailfolder

extension Google {
    struct MailFolder : Codable {
        let id                   : ID
        let name                 : String?
        let messageListVisibility: MessageListVisibility?
        let labelListVisibility  : LabelListVisibility?
        let type                 : MailFolderType?
        let messagesTotal        : Int?
        let messagesUnread       : Int?
        let threadsTotal         : Int?
        let threadsUnread        : Int?
        let color                : Color?
        
        init(
            id                   : ID,
            name                 : String? = nil,
            messageListVisibility: MessageListVisibility? = nil,
            labelListVisibility  : LabelListVisibility? = nil,
            type                 : MailFolderType? = nil,
            messagesTotal        : Int? = nil,
            messagesUnread       : Int? = nil,
            threadsTotal         : Int? = nil,
            threadsUnread        : Int? = nil,
            color                : Color? = nil
        ) {
            self.id                    = id
            self.name                  = name
            self.messageListVisibility = messageListVisibility
            self.labelListVisibility   = labelListVisibility
            self.type                  = type
            self.messagesTotal         = messagesTotal
            self.messagesUnread        = messagesUnread
            self.threadsTotal          = threadsTotal
            self.threadsUnread         = threadsUnread
            self.color                 = color
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
        
        enum MailFolderType : String, Codable {
            case system
            case user
        }
        
        struct Color : Codable {
            let textColor: String?
            let backgroundColor: String?
        }
    }
}
