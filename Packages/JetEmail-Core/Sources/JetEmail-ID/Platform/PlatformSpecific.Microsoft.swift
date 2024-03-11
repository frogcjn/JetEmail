//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

// MARK: - Platform Specific - Microsoft

public protocol MicrosoftIDProtocol : PlatformSpecific {}
public extension MicrosoftIDProtocol {
    static var platform: Platform { .microsoft }
}

// MARK: - Platform Specific - Microsoft Account

public protocol MicrosoftAccountIDProtocol : AccountIDProtocol & MicrosoftIDProtocol {}
public struct MicrosoftAccountID : MicrosoftAccountIDProtocol {
    public let innerID: String
    public init(innerID: String) {
        self.innerID  = innerID
    }
}

// MARK: - Platform Specific - Microsoft Mail Folder

public protocol MicrosoftMailFolderIDProtocol<AccountIDType> : MailFolderIDProtocol & MicrosoftIDProtocol where AccountIDType : MicrosoftAccountIDProtocol {}
public struct MicrosoftMailFolderID : MicrosoftMailFolderIDProtocol {
    public let accountID: MicrosoftAccountID
    public let innerID: String
    public init(accountID: MicrosoftAccountID, innerID: String) {
        self.accountID = accountID
        self.innerID  = innerID
    }
}

// MARK: - Platform Specific - Microsoft Message

public protocol MicrosoftMessageIDProtocol<AccountIDType> : MessageIDProtocol & MicrosoftIDProtocol where AccountIDType : MicrosoftAccountIDProtocol {}
public struct MicrosoftMessageID : MicrosoftMessageIDProtocol {
    public let accountID: MicrosoftAccountID
    public let innerID: String
    public init(accountID: MicrosoftAccountID, innerID: String) {
        self.accountID = accountID
        self.innerID  = innerID
    }
}
