//
//  MailFolder.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/23/24.
//

import JetEmailData

public struct GoogleMailFolder : GoogleProtocol, PlatformSpecificMailFolderProtocol, GetMailFolderProtocol {
    public typealias GeneralID = MailFolderID
    public let                  id: GoogleMailFolderID
    public let               inner: GoogleMailFolderInner
    public let                path: String?
    public let       processedName: String? // adjust for google mailfolder path-name algrithm
    
    public var                name: String? { processedName }
    public let          systemInfo: MailFolderSystemInfo?

    public init(id: GoogleMailFolderID, inner: GoogleMailFolderInner, systemInfo: MailFolderSystemInfo?, processedName: String? = nil) {
        self.id            = id
        self.inner         = inner
        self.path          = inner.name
        self.systemInfo    = systemInfo
        self.processedName = processedName ?? inner.name?.components(separatedBy: "/").last
    }
}

// https://learn.microsoft.com/en-us/graph/api/resources/mailfolder
public struct GoogleMailFolderInner : CodableValueType, Sendable {
    public let id                   : String
    public let name                 : String?
    public let messageListVisibility: MessageListVisibility?
    public let labelListVisibility  : LabelListVisibility?
    public let type                 : MailFolderType?
    public let messagesTotal        : Int?
    public let messagesUnread       : Int?
    public let threadsTotal         : Int?
    public let threadsUnread        : Int?
    public let color                : Color?
    
    public init(
        id                   : String,
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
    
    public enum MessageListVisibility : String, CodableValueType, Sendable {
        case show
        case hide
    }
    
    public enum LabelListVisibility : String, CodableValueType, Sendable {
        case labelShow
        case labelShowIfUnread
        case labelHide
    }
    
    public enum MailFolderType : String, CodableValueType, Sendable {
        case system
        case user
    }
    
    public struct Color : CodableValueType, Sendable {
        let textColor: String?
        let backgroundColor: String?
        
        public init(textColor: String?, backgroundColor: String?) {
            self.textColor = textColor
            self.backgroundColor = backgroundColor
        }
    }
}

