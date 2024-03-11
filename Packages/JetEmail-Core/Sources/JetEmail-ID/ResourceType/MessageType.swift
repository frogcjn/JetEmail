//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

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
