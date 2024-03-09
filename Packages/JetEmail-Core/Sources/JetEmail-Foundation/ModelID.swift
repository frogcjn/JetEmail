//
//  StringID.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

public protocol IDProtocol<Owner> : CodableValueType, PartialRawRepresentable<String> {
    associatedtype Owner
}

public struct ModelID<Owner> : IDProtocol, Decodable {
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
    
    public var rawValue: String { innerID }
}

public struct AccountModelID<AccountType, Owner> : IDProtocol {
        
    public let accountID: ModelID<AccountType>
    public let   innerID: ModelID<Owner>
    
    public init(accountID: ModelID<AccountType>, _ innerID: ModelID<Owner>) {
        self.accountID = accountID
        self  .innerID = innerID
    }
    
    public var rawValue: String { "\(accountID)/\(innerID)" }
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
