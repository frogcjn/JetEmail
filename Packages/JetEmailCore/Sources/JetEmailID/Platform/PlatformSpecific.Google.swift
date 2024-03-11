//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

// MARK: - Platform Specific - Google

public protocol GoogleIDProtocol : PlatformSpecific {}
public extension GoogleIDProtocol {
    static var platform: Platform { .google }
}

// MARK: - Platform Specific - Google Account

public protocol GoogleAccountIDProtocol : AccountIDProtocol & GoogleIDProtocol {}
public struct GoogleAccountID : GoogleAccountIDProtocol {
    public let innerID: String
    public init(innerID: String) {
        self.innerID  = innerID
    }
}

// MARK: - Platform Specific - Google MailFolder

public protocol GoogleMailFolderIDProtocol<AccountIDType> : MailFolderIDProtocol & GoogleIDProtocol where AccountIDType : GoogleAccountIDProtocol {}
public struct GoogleMailFolderID : GoogleMailFolderIDProtocol {
    public let accountID: GoogleAccountID
    public let innerID: String
    public init(accountID: GoogleAccountID, innerID: String) {
        self.accountID = accountID
        self.innerID  = innerID
    }
}

// MARK: - Platform Specific - Google Message

public protocol GoogleMessageIDProtocol<AccountIDType> : MessageIDProtocol & GoogleIDProtocol where AccountIDType : GoogleAccountIDProtocol {}
public struct GoogleMessageID : GoogleMessageIDProtocol {
    public let accountID: GoogleAccountID
    public let innerID: String
    public init(accountID: GoogleAccountID, innerID: String) {
        self.accountID = accountID
        self.innerID  = innerID
    }
}
