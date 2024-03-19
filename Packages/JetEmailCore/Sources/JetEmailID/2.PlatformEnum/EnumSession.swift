//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/12/24.
//


public protocol SessionProtocol<AccountType> {
    associatedtype AccountType: AccountProtocol
    var account: AccountType { get }
}

extension PlatformEnum: SessionProtocol where
    Microsoft : SessionProtocol,
       Google : SessionProtocol,
    Microsoft.AccountType.GeneralID == AccountID,
       Google.AccountType.GeneralID == AccountID
{
    public typealias AccountType = PlatformEnum<Microsoft.AccountType, Google.AccountType>
    
    public var account: AccountType {
        switch self {
        case .microsoft(let platform): .microsoft(platform.account)
        case    .google(let platform):    .google(platform.account)
        }
    }
}
