//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/9/24.
//

import JetEmailFoundation

/*public extension ResourceIDProtocol {
    var resourceID: String { "\(ResourceType.resourceType)/\(platform)/\(accountID.innerID)/\(innerID)" }  // combined all information to be the unique ID on the platform
}*/


// MARK: - ID Protocols

// protocol IDProtocol : CodableValueType {}

// MARK: - Resource ID Protocols

public protocol ResourceIDProtocol<AccountIDType, ResourceType> : CodableValueType /*: IDProtocol*/ {
    associatedtype  ResourceType : ResourceSpecific
    associatedtype  AccountIDType: AccountIDProtocol
    
    var   platform: Platform      { get }
    var  accountID: AccountIDType { get }
    var    innerID: String        { get }
    // var resourceID: String        { get }
}

public struct ResourceID<AccountIDType : AccountIDProtocol, ResourceType : ResourceSpecific> : ResourceIDProtocol {
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

