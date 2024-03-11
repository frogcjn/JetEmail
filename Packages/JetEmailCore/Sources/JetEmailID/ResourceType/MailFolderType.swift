//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

// MARK: - Resource Specific - MailFolder

public protocol MailFolderIDProtocol<AccountIDType> : ResourceIDProtocol where ResourceType == MailFolderType {}

public struct MailFolderID : MailFolderIDProtocol {
    public let  platform: Platform
    public let accountID: AccountID
    public let   innerID: String
    
    public init(platform: Platform, accountID: AccountID, innerID: String) {
        self.platform  = platform
        self.accountID = accountID
        self.innerID   = innerID
    }
    
    public init(platform: Platform, innerAccountID: String, innerID: String) {
        self.platform  = platform
        self.accountID = .init(platform: platform, innerID: innerAccountID)
        self.innerID   = innerID
    }
}

public extension MailFolderID {
    var microsoft: MicrosoftMailFolderID? {
        guard let accountID = accountID.microsoft else { return nil }
        guard case .microsoft = platform else { return nil }
        return .init(accountID: accountID, innerID: innerID)
    }
    
    var google: GoogleMailFolderID? {
        guard let accountID = accountID.google else { return nil }
        guard case .google = platform else { return nil }
        return .init(accountID: accountID, innerID: innerID)
    }
}

