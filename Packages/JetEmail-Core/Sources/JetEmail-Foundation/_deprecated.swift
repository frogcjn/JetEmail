//
//  StringID.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//


/*
public protocol AccountResource : ResourceIDProtocol {
}
extension AccountResource {
    var   type : ResourceType { .account }
    var account: String       { element  }
}

public protocol MailFolderResource : ResourceIDProtocol {
}

extension MailFolderResource {
    var   type : ResourceType { .mailFolder }
}

public protocol MessageResponse : ResourceIDProtocol {
}

extension MessageResponse {
    var   type : ResourceType { .message }
}

public protocol MicrosoftResource : ResourceIDProtocol {
}

extension MicrosoftResource {
    var platform: Platform { .microsoft }
}

public protocol GoogleResource : ResourceIDProtocol {
    
}

extension GoogleResource {
    var platform: Platform { .google }
}*/




/*
public struct StringID<Owner> : IDProtocol, Decodable {
    public let innerID: String
    public init(_ innerID: String) {
        self.innerID = innerID
    }
    
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.innerID = try container.decode(String.self)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.innerID)
    }
    
    public var rawID: String { innerID }
}

public struct AccountModelID<AccountType, Owner> : IDProtocol {
        
    public let accountID: StringID<AccountType>
    public let   innerID: StringID<Owner>
    
    public init(accountID: StringID<AccountType>, _ innerID: StringID<Owner>) {
        self.accountID = accountID
        self  .innerID = innerID
    }
    
    public var rawID: String { "\(accountID)/\(innerID)" }
}
/*
public protocol PlatformAccountModelIDProtocol<OwnerType> : IDProtocol /*where*PlatformType : CodableValueType, AccountID : CodableValueType, InnerID : CodableValueType*/  {
    associatedtype PlatformType : CodableValueType
    associatedtype AccountID    : CodableValueType
    associatedtype InnerID      : CodableValueType
    var  platform: PlatformType { get }
    var accountID: AccountID { get }
    var   innerID: InnerID { get }
    init(platform: PlatformType, accountID: AccountID, _ innerID: InnerID)/* {
        self.platform = platform
        self.accountID = accountID
        self.innerID = innerID
    }*/
}*/



/*
public struct ModelID<OwnerType> : IDProtocol {
    public let innerID: String
    public init(_ innerID: String) {
        self.innerID = innerID
    }
    
    public var rawValue: String { innerID }
}
*/
*/

//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/7/24.
//
// import SwiftUI

// MARK: - Partial



/*public extension PartialRawRepresentable where Self : Equatable, RawValue : Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}*/
/*
public extension PartialRawRepresentable where Self : Encodable, RawValue : Encodable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}*/

/*public extension PartialRawRepresentable where Self : Hashable, RawValue : Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}*/


/*
// MARK: - Fully

public protocol FullyRawRepresentable<RawValue> : PartialRawRepresentable {
    init(rawValue: RawValue)
}

public extension FullyRawRepresentable where Self : Decodable, RawValue : Decodable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(RawValue.self)
        self.init(rawValue: rawValue)
    }
}*/

// MARK: - StringID Protocol

/*public protocol StringIDProtocol<OwnerType> : PartialRawRepresentable, Decodable where RawValue == String {
    associatedtype OwnerType
}*/


