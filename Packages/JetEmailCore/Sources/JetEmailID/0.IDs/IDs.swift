//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//


public struct ResourceID<AccountIDType : AccountIDProtocol> : ResourceIDProtocol {
    public var id: Self { self }
    
    // public var id: ResourceID<AccountIDType> { self }
    
    public let resourceType: ResourceType
    public let     platform: Platform
    public let    accountID: AccountIDType
    public let      innerID: String
    
    init(resourceType: ResourceType, platform: Platform, accountID: AccountIDType, innerID: String) {
        self.resourceType = resourceType
        self.platform     = platform
        self.accountID    = accountID
        self.innerID      = innerID
    }
}

// MARK: - Resource Specific

public struct AccountID : AccountIDProtocol {
    public var id: Self { self }

    public let  platform: Platform
    public let   innerID: String
    
    public init(platform: Platform, innerID: String) {
        self.platform = platform
        self.innerID  = innerID
    }
}

public struct MailFolderID : MailFolderIDProtocol {
    public var id: Self { self }

    public var  platform: Platform { accountID.platform }
    public let accountID: AccountID
    public let   innerID: String
    
    public init(accountID: AccountID, innerID: String) {
        self.accountID = accountID
        self.innerID   = innerID
    }
    
    public init(platform: Platform, innerAccountID: String, innerID: String) {
        self.accountID = .init(platform: platform, innerID: innerAccountID)
        self.innerID   = innerID
    }
}

public struct MessageID : MessageIDProtocol {
    public var id: Self { self }

    public var  platform: Platform { accountID.platform }
    public let accountID: AccountID
    public let   innerID: String
    
    public init(accountID: AccountID, innerID: String) {
        self.accountID = accountID
        self.innerID   = innerID
    }
    
    public init(platform: Platform, innerAccountID: String, innerID: String) {
        self.accountID = .init(platform: platform, innerID: innerAccountID)
        self.innerID   = innerID
    }
}


// MARK: - Platform Specific: Google

public struct GoogleAccountID : GoogleIDProtocol & PlatformSpecificAccountIDProtocol {
    public let innerID: String
    public init(innerID: String) {
        self.innerID  = innerID
    }
}

public struct GoogleMailFolderID : GoogleIDProtocol & PlatformSpecificMailFolderIDProtocol {
    public let accountID: GoogleAccountID
    public let innerID: String
    public init(accountID: GoogleAccountID, innerID: String) {
        self.accountID = accountID
        self.innerID  = innerID
    }
}

public struct GoogleMessageID : GoogleIDProtocol & PlatformSpecificMessageIDProtocol {
    public let accountID: GoogleAccountID
    public let innerID: String
    public init(accountID: GoogleAccountID, innerID: String) {
        self.accountID = accountID
        self.innerID  = innerID
    }
}

// MARK: - Platform Specific: Microsoft

public struct MicrosoftAccountID : MicrosoftIDProtocol & PlatformSpecificAccountIDProtocol {
    public let innerID: String
    public init(innerID: String) {
        self.innerID  = innerID
    }
}


public struct MicrosoftMailFolderID : MicrosoftIDProtocol & PlatformSpecificMailFolderIDProtocol {
    public let accountID: MicrosoftAccountID
    public let innerID: String
    public init(accountID: MicrosoftAccountID, innerID: String) {
        self.accountID = accountID
        self.innerID  = innerID
    }
}


public struct MicrosoftMessageID : MicrosoftIDProtocol & PlatformSpecificMessageIDProtocol {
    public let accountID: MicrosoftAccountID
    public let innerID: String
    public init(accountID: MicrosoftAccountID, innerID: String) {
        self.accountID = accountID
        self.innerID  = innerID
    }
}
