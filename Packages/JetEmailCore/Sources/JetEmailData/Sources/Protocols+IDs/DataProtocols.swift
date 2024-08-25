//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/9/24.
//

import struct Foundation.Date
import struct Foundation.Data

protocol ResourceProtocol                   : GeneralIdentifiable & IdentifiableValueType, Sendable where ID : ResourceIDProtocol        , GeneralID == ID.GeneralID {}
protocol ResourceSpecificProtocol           : GeneralIdentifiable & IdentifiableValueType, Sendable where ID : ResourceSpecificIDProtocol, GeneralID == ID.GeneralID {}

public protocol AccountProtocol                    : GeneralIdentifiable & IdentifiableValueType, Sendable where GeneralID == AccountID {
    var username: String { get }
}

public protocol SessionProtocol {
    associatedtype     ClientType
    associatedtype    AccountType
    
    // sessions
    var  client:  ClientType { get }
    var account: AccountType { get }
}

public protocol MailFolderProtocol                 : GeneralIdentifiable & IdentifiableValueType, Sendable where GeneralID == MailFolderID, ID : Sendable {
    var       name: String?               { get }
    var systemName: MailFolderSystemName? { get }
}
public protocol MessageProtocol                    : GeneralIdentifiable & IdentifiableValueType, Sendable where GeneralID == MessageID, ID : Sendable {
    
    // MARK: Resource - Information Fields

    var      subject: String?          { get }
    
    // MARK: Resource - Originator Fields
    
    var         from: String?          { get }
    var       sender: String?          { get }
    var      replyTo: String?          { get }
    
    // MARK: Resource - Destination Address Fields

    var           to: String?          { get }
    var           cc: String?          { get }
    var          bcc: String?          { get }
    // var  deliveredTo: String?      { get }

    // MARK: Resource - The origination date field

    var         date: Date?            { get }
    /*var  createdDate: Date?        { get }
    var modifiedDate: Date?        { get }
    var receivedDate: Date?        { get }
    var     sentDate: Date?        { get }*/
    
    // MARK: Resource - Headers
    var      headers: [MessageHeader]? { get }
    
    // MARK: Resource - Body & Raw
    
    var  bodyPreview: String?          { get }
    var         body: MessageBody?     { get }
    var          raw: Data?            { get }
    // var   uniqueBody: Body?
}
 
// MARK: - Platform Specific

public protocol PlatformSpecificProtocol : GeneralIdentifiable & IdentifiableValueType, Sendable where ID : PlatformSpecificIDProtocol, GeneralID == ID.GeneralID {}
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
