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
        case .microsoft(let platform): platform.username
        case    .google(let platform): platform.username
        }
    }
}
