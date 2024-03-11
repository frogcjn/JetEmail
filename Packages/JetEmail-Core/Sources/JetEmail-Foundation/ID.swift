//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/9/24.
//


public enum Platform : RawRepresentable, CodableValueType {
    case microsoft
    case google
    case other(String)
    
    public init(rawValue: String) {
        self = switch rawValue {
        case "microsoft": .microsoft
           case "google": .google
                 default: .other(rawValue)
        }
    }
    public var rawValue: RawValue {
        switch self {
        case .microsoft: "microsoft"
        case .google   : "google"
        case .other(let rawValue): rawValue
        }
    }
}

public enum PlatformCase<Microsoft : CodableValueType, Google : CodableValueType> : CodableValueType {
    case microsoft(Microsoft)
    case google(Google)
}

public enum ResourceType: String, CodableValueType {
    case account
    case mailFolder
    case message
}

/*public extension ResourceIDProtocol {
    var resourceID: String { "\(ResourceType.resourceType)/\(platform)/\(accountID.innerID)/\(innerID)" }  // combined all information to be the unique ID on the platform
}*/


// MARK: - ID Protocols

public protocol IDProtocol : CodableValueType {}

// MARK: - Resource ID Protocols

public protocol ResourceIDProtocol<AccountIDType, ResourceType> : IDProtocol {
    associatedtype  ResourceType : FixResourceType
    associatedtype  AccountIDType: ResourceIDProtocol
    
    var   platform: Platform      { get }
    var  accountID: AccountIDType { get }
    var    innerID: String        { get }
    // var resourceID: String        { get }
}

public struct ResourceID<AccountIDType : ResourceIDProtocol, ResourceType : FixResourceType> : ResourceIDProtocol {
    public let   platform: Platform
    public let  accountID: AccountIDType
    public let    innerID: String
    public let resourceID: String
    
    init(platform: Platform, accountID: AccountIDType, innerID: String, resourceID: String) {
        self.platform   = platform
        self.accountID  = accountID
        self.innerID    = innerID
        self.resourceID = resourceID
    }
}



// MARK: - Resource Specific

public protocol FixResourceType {
    static var resourceType: ResourceType { get }
}

public enum    AccountType : FixResourceType {
    public static var resourceType : ResourceType { .account }
}
public enum MailFolderType : FixResourceType {
    public static var resourceType : ResourceType { .mailFolder }
}
public enum    MessageType : FixResourceType {
    public static var resourceType : ResourceType { .message }
}

public protocol AccountIDProtocol : ResourceIDProtocol where ResourceType == AccountType, AccountIDType == Self {
}

// MARK: - Resource Specific - Account

extension AccountIDProtocol {
    public var accountID: Self { self }
}

public struct AccountID : AccountIDProtocol {

    public let  platform: Platform
    public let   innerID: String
    
    public init(platform: Platform, innerID: String) {
        self.platform = platform
        self.innerID  = innerID
    }
}

public extension AccountID {
    var microsoft: MicrosoftAccountID? {
        guard case .microsoft = platform else { return nil }
        return .init(innerID: innerID)
    }
    
    var google: GoogleAccountID? {
        guard case .google = platform else { return nil }
        return .init(innerID: innerID)
    }
    
    var platformCase: PlatformCase<MicrosoftAccountID, GoogleAccountID>? {
        switch platform {
        case .microsoft: .microsoft(.init(innerID: innerID))
        case    .google:    .google(.init(innerID: innerID))
        case     .other: nil
        }
    }
}

// MARK: - Resource Specific - MailFolder

public protocol MailFolderIDProtocol<AccountIDType> : ResourceIDProtocol where ResourceType == MailFolderType {}

public struct MailFolderID : MailFolderIDProtocol {
    public let  platform: Platform
    public let accountID: AccountID
    public let   innerID: String
    
    public init(platform: Platform, accountID: AccountID, innerID: String) {
        self.platform  = platform
        self.accountID = accountID
        self.innerID   = innerID
    }
    
    public init(platform: Platform, innerAccountID: String, innerID: String) {
        self.platform  = platform
        self.accountID = .init(platform: platform, innerID: innerAccountID)
        self.innerID   = innerID
    }
}

public extension MailFolderID {
    var microsoft: MicrosoftMailFolderID? {
        guard let accountID = accountID.microsoft else { return nil }
        guard case .microsoft = platform else { return nil }
        return .init(accountID: accountID, innerID: innerID)
    }
    
    var google: GoogleMailFolderID? {
        guard let accountID = accountID.google else { return nil }
        guard case .google = platform else { return nil }
        return .init(accountID: accountID, innerID: innerID)
    }
}

// MARK: - Resource Specific - Message

public protocol MessageIDProtocol<AccountIDType> : ResourceIDProtocol where ResourceType == MessageType {}

public struct MessageID : MessageIDProtocol {
    public let  platform: Platform
    public let accountID: AccountID
    public let   innerID: String
    
    public init(platform: Platform, accountID: AccountID, innerID: String) {
        self.accountID = accountID
        self.platform  = platform
        self.innerID   = innerID
    }
    
    public init(platform: Platform, innerAccountID: String, innerID: String) {
        self.platform  = platform
        self.accountID = .init(platform: platform, innerID: innerAccountID)
        self.innerID   = innerID
    }
}


public extension MessageID {
    var microsoft: MicrosoftMessageID? {
        guard let accountID = accountID.microsoft else { return nil }
        guard case .microsoft = platform else { return nil }
        return .init(accountID: accountID, innerID: innerID)
    }
    
    var google: GoogleMessageID? {
        guard let accountID = accountID.google else { return nil }
        guard case .google = platform else { return nil }
        return .init(accountID: accountID, innerID: innerID)
    }
}

// MARK: - Platform Specific
public protocol PlatformSpecific : ResourceIDProtocol {}

extension PlatformSpecific {
    public var general: AccountID {
        .init(platform: platform, innerID: innerID)
    }
}

extension MailFolderIDProtocol where Self : PlatformSpecific, AccountIDType : PlatformSpecific {
    public var general: MailFolderID {
        .init(platform: platform, accountID: accountID.general, innerID: innerID)
    }
}

extension MessageIDProtocol where Self : PlatformSpecific, AccountIDType : PlatformSpecific {
    public var general: MessageID {
        .init(platform: platform, accountID: accountID.general, innerID: innerID)
    }
}

// MARK: - Platform Specific - Microsoft

public protocol MicrosoftIDProtocol : PlatformSpecific {}

public extension MicrosoftIDProtocol {
    var platform: Platform { .microsoft }
}

public protocol MicrosoftAccountIDProtocol : AccountIDProtocol & MicrosoftIDProtocol {}

public struct MicrosoftAccountID : MicrosoftAccountIDProtocol {
    public let innerID: String
    public init(innerID: String) {
        self.innerID  = innerID
    }
}

public protocol MicrosoftMailFolderIDProtocol<AccountIDType> : MailFolderIDProtocol & MicrosoftIDProtocol where AccountIDType : MicrosoftAccountIDProtocol {}

public struct MicrosoftMailFolderID : MicrosoftMailFolderIDProtocol {
    public let accountID: MicrosoftAccountID
    public let innerID: String
    public init(accountID: MicrosoftAccountID, innerID: String) {
        self.accountID = accountID
        self.innerID  = innerID
    }
}

public protocol MicrosoftMessageIDProtocol<AccountIDType> : MessageIDProtocol & MicrosoftIDProtocol where AccountIDType : MicrosoftAccountIDProtocol {}

public struct MicrosoftMessageID : MicrosoftMessageIDProtocol {
    public let accountID: MicrosoftAccountID
    public let innerID: String
    public init(accountID: MicrosoftAccountID, innerID: String) {
        self.accountID = accountID
        self.innerID  = innerID
    }
}

// MARK: - Platform Specific - Google

public protocol GoogleIDProtocol : PlatformSpecific {}
public extension GoogleIDProtocol {
    var platform: Platform { .google }
}

public protocol GoogleAccountIDProtocol : AccountIDProtocol & GoogleIDProtocol {}

public struct GoogleAccountID : GoogleAccountIDProtocol {
    public let innerID: String
    public init(innerID: String) {
        self.innerID  = innerID
    }
}



public protocol GoogleMailFolderIDProtocol<AccountIDType> : MailFolderIDProtocol & GoogleIDProtocol where AccountIDType : GoogleAccountIDProtocol {}


public struct GoogleMailFolderID : GoogleMailFolderIDProtocol {
    public let accountID: GoogleAccountID
    public let innerID: String
    public init(accountID: GoogleAccountID, innerID: String) {
        self.accountID = accountID
        self.innerID  = innerID
    }
}

public protocol GoogleMessageIDProtocol<AccountIDType> : MessageIDProtocol & GoogleIDProtocol where AccountIDType : GoogleAccountIDProtocol {}
public struct GoogleMessageID : GoogleMessageIDProtocol {
    public let accountID: GoogleAccountID
    public let innerID: String
    public init(accountID: GoogleAccountID, innerID: String) {
        self.accountID = accountID
        self.innerID  = innerID
    }
}


/*

public struct GoogleMailFolderID<Owner> : ResourceIDProtocol, GoogleType {

    public typealias ResourceType = MailFolderType

    public var accountID: String
    public var   innerID: String
    
    public init<Account>(accountID: GoogleAccountID<Account>, innerID: String) {
        self.accountID = accountID
        self.innerID = innerID
    }
}

public struct GoogleMessageID<Owner> : ResourceIDProtocol, GoogleType {

    public typealias ResourceType = MessageType

    public var accountID: String
    public var   innerID: String
    
    public init(accountID: GoogleAccountID, innerID: String) {
        self.accountID = accountID
        self.innerID   = innerID
    }
}





public struct MicrosoftMailFolderID<Owner> : ResourceIDProtocol, MicrosoftType {

    public typealias ResourceType = MailFolderType

    public var accountID: MicrosoftAccountID
    public var   innerID: String
    
    public init(accountID: MicrosoftAccountID, innerID: String) {
        self.accountID = accountID
        self.innerID = innerID
    }
}

public struct MicrosoftMessageID<Owner> : ResourceIDProtocol, MicrosoftType {

    public typealias ResourceType = MessageType

    public var accountID: MicrosoftAccountID
    public var   innerID: String
    
    public init(accountID: MicrosoftAccountID, innerID: String) {
        self.accountID = accountID
        self.innerID      = innerID
    }
}
*/
import SwiftUI

public extension String.StringInterpolation {
    mutating func appendInterpolation<ID: ResourceIDProtocol>(_ id: ID) {
        appendInterpolation(id.innerID)
    }
}

public extension LocalizedStringKey.StringInterpolation {
    mutating func appendInterpolation<ID: ResourceIDProtocol>(_ id: ID)  {
        appendInterpolation(id.innerID)
    }
}

// MARK: - Normal

public extension String.StringInterpolation {
    mutating func appendInterpolation<ID: RawRepresentable<String>>(_ id: ID) {
        appendInterpolation(id.rawValue)
    }
}

public extension LocalizedStringKey.StringInterpolation {
    mutating func appendInterpolation<ID: RawRepresentable<String>>(_ id: ID)  {
        appendInterpolation(id.rawValue)
    }
}
