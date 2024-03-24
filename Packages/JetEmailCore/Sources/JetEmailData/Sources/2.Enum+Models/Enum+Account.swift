//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/12/24.
//

extension PlatformEnum: AccountProtocol where
    Microsoft : AccountProtocol,
       Google : AccountProtocol,
    Microsoft.GeneralID == AccountID,
       Google.GeneralID == AccountID
{
    public var username: String {
        switch self {
        case .microsoft(let account): account.username
        case    .google(let account): account.username
        }
    }
}

extension PlatformEnum : ResourceSpecificIDProtocol, ResourceIDProtocol, AccountIDProtocol where
Microsoft : PlatformSpecificAccountIDProtocol,
   Google : PlatformSpecificAccountIDProtocol,
Microsoft.GeneralID == Self,
   Google.GeneralID == Self
{
    public typealias AccountIDType = Self
    
    public var platform: Platform {
        switch self {
        case .microsoft(let id): id.platform
        case    .google(let id): id.platform
        }
    }
    
    public var innerID: String {
        switch self {
        case .microsoft(let id): id.innerID
        case    .google(let id): id.innerID
        }
    }
    
    /*public init(platform: Platform, innerID: String) {
        self = switch platform {
        case .microsoft: .microsoft(.init(innerID: innerID))
        case    .google:    .google(.init(innerID: innerID))
        }
    }*/
}


