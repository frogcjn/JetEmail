//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/9/24.
//

/*
 ResourceIDProtocol                             -> ResourceID
    ResourceSpecificIDProtocol
        AccountIDProtocol                           -> AccountID (struct)
        MailFolderIDProtocol                        -> MailFolderID (struct)
        MessageIDProtocol                           -> MessageID (struct)
    
    PlatformSpecificIDProtocol  (PlatformSpecificCase)
        MicrosoftIDProtocol
        GoogleIDProtocol
        
        & AccountIDProtocol: PlatformSpecificAccountProtocol
            
        PlatformSpecificResourceIDProtocol & MailFolderIDProtocol: PlatformSpecificMailFolderIDProtocol
        PlatformSpecificResourceIDProtocol &    MessageIDProtocol: PlatformSpecificMessageIDProtocol
        
        GoogleIDProtocol & PlatformSpecificAccountProtocol -> GoogleAccountID (struct)
 */


// MARK: - Resource ID

public protocol ResourceIDProtocol : CodableValueType, Sendable {
    associatedtype  AccountIDType: AccountIDProtocol
    
    var resourceType: ResourceType  { get }
    var     platform: Platform      { get }
    var    accountID: AccountIDType { get }
    var      innerID: String        { get }
    // var resourceID: String       { get }
}

// MARK: - Resource Type Speicific

public protocol ResourceSpecificIDProtocol : ResourceIDProtocol {
    static var resourceType: ResourceType { get }
}
public extension ResourceSpecificIDProtocol {
    var resourceType : ResourceType { Self.resourceType }
}

public protocol AccountIDProtocol : ResourceSpecificIDProtocol where AccountIDType == Self {}
extension AccountIDProtocol {
    public static var resourceType: ResourceType { .account }
    public var accountID: Self { self }
}

public protocol MailFolderIDProtocol : ResourceSpecificIDProtocol {}
extension MailFolderIDProtocol {
    public static var resourceType: ResourceType { .mailFolder }
}

public protocol MessageIDProtocol : ResourceSpecificIDProtocol {}
extension MessageIDProtocol {
    public static var resourceType: ResourceType { .message }
}


// MARK: - Platform Speicific

public protocol PlatformSpecificIDProtocol : ResourceIDProtocol, GeneralIdentifiable where GeneralID == InnerGeneralID {
    static var platform: Platform { get }
    
    associatedtype InnerGeneralID : ResourceIDProtocol
    var general: InnerGeneralID { get }
}


public extension PlatformSpecificIDProtocol {
    var platform : Platform { Self.platform }
    var generalID : InnerGeneralID { general }
}

public protocol MicrosoftIDProtocol : PlatformSpecificIDProtocol {}
public extension MicrosoftIDProtocol {
    static var platform: Platform { .microsoft }
}

public protocol GoogleIDProtocol : PlatformSpecificIDProtocol {}
public extension GoogleIDProtocol {
    static var platform: Platform { .google }
}


// MARK: - Platform Speicific + Resource Type Speicific (Account)

public protocol PlatformSpecificAccountIDProtocol : PlatformSpecificIDProtocol, AccountIDProtocol {
    init(innerID: String)
}

extension PlatformSpecificAccountIDProtocol {
    public var general: AccountID {
        .init(platform: platform, innerID: innerID)
    }
}

// MARK: - Platform Speicific + Resource Type Speicific (Resource)

public protocol PlatformSpecificResourceIDProtocol : PlatformSpecificIDProtocol {
    init(accountID: AccountIDType, innerID: String)
}

public protocol PlatformSpecificMailFolderIDProtocol : PlatformSpecificResourceIDProtocol, MailFolderIDProtocol where AccountIDType : PlatformSpecificAccountIDProtocol {}
public extension PlatformSpecificMailFolderIDProtocol {
    var general: MailFolderID {
        .init(accountID: accountID.general, innerID: innerID)
    }
}

public protocol PlatformSpecificMessageIDProtocol : PlatformSpecificResourceIDProtocol, MessageIDProtocol where AccountIDType : PlatformSpecificAccountIDProtocol {}
public extension PlatformSpecificMessageIDProtocol {
    var general: MessageID {
        .init(accountID: accountID.general, innerID: innerID)
    }
}
