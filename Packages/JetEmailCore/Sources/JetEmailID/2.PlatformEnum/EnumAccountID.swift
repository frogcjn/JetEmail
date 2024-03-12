//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/12/24.
//


public protocol GetAccountProtocol : GeneralIdentifiable, Sendable where GeneralID : AccountIDProtocol {
    var username: String { get }
}

// Account Enum

extension PlatformEnum : GetAccountProtocol where
    Microsoft :GetAccountProtocol,
    Google : GetAccountProtocol, 
    GeneralID : AccountIDProtocol
{
    public var username: String {
        switch self {
        case .microsoft(let platform): platform.username
        case    .google(let platform): platform.username
        }
    }
}

// Account ID Enum

extension PlatformEnum: ResourceIDProtocol, ResourceSpecificIDProtocol, AccountIDProtocol where
    Microsoft : PlatformSpecificAccountIDProtocol,
    Google : PlatformSpecificAccountIDProtocol,
    GeneralID : AccountIDProtocol
{
    public var platform: Platform { generalID.platform }
    public var innerID: String    { generalID.innerID  }
}
