//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/12/24.
//

extension PlatformEnum: ResourceIDProtocol, ResourceSpecificIDProtocol, AccountIDProtocol where 
    Microsoft : PlatformSpecificAccountIDProtocol,
       Google : PlatformSpecificAccountIDProtocol
{
    public var platform: Platform { id.platform }
    public var innerID: String    { id.innerID  }
}
