//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/9/24.
//

import struct Foundation.Date
import struct Foundation.Data

public protocol ResourceProtocol                   : GeneralIdentifiable, Sendable where ID : ResourceIDProtocol        , GeneralID: ResourceIDProtocol, GeneralID == ID.GeneralID         {}
public protocol ResourceSpecificProtocol           : GeneralIdentifiable, Sendable where ID : ResourceSpecificIDProtocol, GeneralID: ResourceSpecificIDProtocol {}

public protocol AccountProtocol                    : GeneralIdentifiable, Sendable where ID : AccountIDProtocol         , GeneralID == AccountID         {
    var username: String { get }
}

public protocol MailFolderProtocol                 : GeneralIdentifiable, Sendable where ID : MailFolderIDProtocol      , GeneralID == MailFolderID      {
    var name: String? { get }
    var systemInfo: MailFolderSystemInfo? { get }
}
public protocol MessageProtocol                    : GeneralIdentifiable, Sendable where ID : MessageIDProtocol         , GeneralID == MessageID       {
    
    var      subject: String?      { get }
    
    // MARK: Resource - Originator Fields
    
    var         from: String?      { get }
    var       sender: String?      { get }
    var      replyTo: String?      { get }
    
    // MARK: Resource - Destination Address Fields

    var           to: String?      { get }
    var           cc: String?      { get }
    var          bcc: String?      { get }
    var  deliveredTo: String?      { get }

    // MARK: Resource - Date

    var         date: Date?        { get }
    var  createdDate: Date?        { get }
    var modifiedDate: Date?        { get }
    var receivedDate: Date?        { get }
    var     sentDate: Date?        { get }
    
    // MARK: Resource - Body & Raw
    
    var  bodyPreview: String?      { get }
    var         body: MessageBody? { get }
    var          raw: Data?        { get }
    // var   uniqueBody: Body?
}
 
// MARK: - Platform Specific

public protocol PlatformSpecificProtocol           : GeneralIdentifiable, Sendable where ID : PlatformSpecificIDProtocol, ID.GeneralID: ResourceIDProtocol, GeneralID == ID.GeneralID {}
public extension PlatformSpecificProtocol {
    var generalID : GeneralID { id.generalID }
}

public protocol MicrosoftProtocol                  : PlatformSpecificProtocol                      where ID : MicrosoftIDProtocol                  {}
public protocol GoogleProtocol                     : PlatformSpecificProtocol                      where ID : GoogleIDProtocol                     {}
public protocol PlatformSpecificAccountProtocol    : PlatformSpecificProtocol & AccountProtocol    where ID : PlatformSpecificAccountIDProtocol    {}
public protocol PlatformSpecificMailFolderProtocol : PlatformSpecificProtocol & MailFolderProtocol where ID : PlatformSpecificMailFolderIDProtocol {}
public protocol PlatformSpecificMessageProtocol    : PlatformSpecificProtocol & MessageProtocol    where ID : PlatformSpecificMessageIDProtocol    {}

/*
 ResourceIDProtocol                                 -> ResourceProtocol
    ResourceSpecificIDProtocol                      ->     ResourceSpecificProtocol
        AccountIDProtocol                           ->         AccountProtocol
        MailFolderIDProtocol                        ->         MailProtocol
        MessageIDProtocol                           ->         MessageProtocol
    
    PlatformSpecificIDProtocol                      -> PlatformSpecificProtocol
        MicrosoftIDProtocol                         ->     MicrosoftProtocol
        GoogleIDProtocol                            ->     GoogleProtocol
        
        & AccountIDProtocol: PlatformSpecificAccountIDProtocol -> PlatformSpecificAccountProtocol
            
        PlatformSpecificResourceIDProtocol & MailFolderIDProtocol: PlatformSpecificMailFolderIDProtocol
        PlatformSpecificResourceIDProtocol &    MessageIDProtocol: PlatformSpecificMessageIDProtocol
        
        GoogleIDProtocol & PlatformSpecificAccountProtocol -> GoogleAccountID (struct)
 */
