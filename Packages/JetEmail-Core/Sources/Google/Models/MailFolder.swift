//
//  MailFolder.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

import JetEmail_Foundation

// MARK: - MailFolder
// https://learn.microsoft.com/en-us/graph/api/resources/mailfolder

public struct MailFolder : IdentifiableValueType {
    public let id                   : ID
    public var path                 : String?
    public var name                 : String?
    public let messageListVisibility: MessageListVisibility?
    public let labelListVisibility  : LabelListVisibility?
    public let type                 : MailFolderType?
    public let messagesTotal        : Int?
    public let messagesUnread       : Int?
    public let threadsTotal         : Int?
    public let threadsUnread        : Int?
    public let color                : Color?
    
    public init(
        id                   : ID,
        path                 : String? = nil,
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
        self.path                  = path
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
    
    public enum MessageListVisibility : String, CodableValueType {
        case show
        case hide
    }
    
    public enum LabelListVisibility : String, CodableValueType {
        case labelShow
        case labelShowIfUnread
        case labelHide
    }
    
    public enum MailFolderType : String, CodableValueType {
        case system
        case user
    }
    
    public struct Color : CodableValueType {
        let textColor: String?
        let backgroundColor: String?
    }
}

