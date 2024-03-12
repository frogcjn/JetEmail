//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/9/24.
//

public protocol ResourceProtocol                   : IdentifiableValueType, Sendable where ID : ResourceIDProtocol {}
public protocol ResourceSpecificProtocol           : IdentifiableValueType, Sendable where ID : ResourceSpecificIDProtocol{}
public protocol AccountProtocol                    : IdentifiableValueType, Sendable where ID : AccountIDProtocol {}
public protocol MailFolderProtocol                 : IdentifiableValueType, Sendable where ID : MailFolderIDProtocol {}
public protocol MessageProtocol                    : IdentifiableValueType, Sendable where ID : MessageIDProtocol {}
 
// MARK: - Platform Specific

public protocol PlatformSpecificProtocol           : IdentifiableValueType, Sendable , PlatformSpecificCase where ID : PlatformSpecificIDProtocol, PlatformCaseGeneralID == ID.PlatformCaseGeneralID {}
public extension PlatformSpecificProtocol {
    var platformCaseGeneralID : PlatformCaseGeneralID { id.platformCaseGeneralID }
}

public protocol MicrosoftProtocol                  : PlatformSpecificProtocol                      where ID : MicrosoftIDProtocol {}
public protocol GoogleProtocol                     : PlatformSpecificProtocol                      where ID : GoogleIDProtocol {}
public protocol PlatformSpecificAccountProtocol    : PlatformSpecificProtocol & AccountProtocol    where ID : PlatformSpecificAccountIDProtocol {}
public protocol PlatformSpecificMailFolderProtocol : PlatformSpecificProtocol & MailFolderProtocol where ID : PlatformSpecificMailFolderIDProtocol {}
public protocol PlatformSpecificMessageProtocol    : PlatformSpecificProtocol & MessageProtocol    where ID : PlatformSpecificMessageIDProtocol {}

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
