//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/9/24.
//

public protocol ResourceProtocol                   : GeneralIdentifiable, Sendable where ID : ResourceIDProtocol        , ID.GeneralID: ResourceIDProtocol         {}
public protocol ResourceSpecificProtocol           : GeneralIdentifiable, Sendable where ID : ResourceSpecificIDProtocol, ID.GeneralID: ResourceSpecificIDProtocol {}

public protocol AccountProtocol                    : GeneralIdentifiable, Sendable where ID : AccountIDProtocol         , ID.GeneralID: AccountIDProtocol          {
    var username: String { get }
}

public protocol MailFolderProtocol                 : GeneralIdentifiable, Sendable where ID : MailFolderIDProtocol      , ID.GeneralID: MailFolderIDProtocol       {}
public protocol MessageProtocol                    : GeneralIdentifiable, Sendable where ID : MessageIDProtocol         , ID.GeneralID: MessageIDProtocol          {}
 
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
