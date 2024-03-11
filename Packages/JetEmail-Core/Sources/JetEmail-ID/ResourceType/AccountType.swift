//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

import JetEmail_Foundation

// MARK: - Resource Specific - Account

public protocol AccountIDProtocol : ResourceIDProtocol where ResourceType == AccountType, AccountIDType == Self {}
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
