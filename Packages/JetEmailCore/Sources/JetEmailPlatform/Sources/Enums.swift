//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

import JetEmailData
import JetEmailGoogle
import JetEmailMicrosoft

public typealias             Client = PlatformEnum<MicrosoftClient    , GoogleClient    >
public typealias            Session = PlatformEnum<MicrosoftSession   , GoogleSession   >
public typealias    AccountResource = PlatformEnum<MicrosoftAccount   , GoogleAccount   >
public typealias MailFolderResource = PlatformEnum<MicrosoftMailFolder, GoogleMailFolder>
public typealias    MessageResource = PlatformEnum<MicrosoftMessage   , GoogleMessage   >


// AccountToSessionProtocol -> AccountID, Account

@MainActor
extension AccountID : AccountIDAuthProtocol {
    public var cachedSession: Session? {
        try? platformCase.cachedSession
    }
    
    public func removeSession() -> Session? {
        try? platformCase.removeSession()
    }
    
    public var refreshSession : Session { get async throws {
        try await platformCase.refreshSession
    } }
}

@MainActor
extension Account : AccountIDAuthProtocol {
    public var cachedSession: Session? {
        resourceID.cachedSession
    }
    
    public func removeSession() -> Session? {
        resourceID.removeSession()
    }
    
    public var refreshSession : Session { get async throws {
        try await resourceID.refreshSession
    } }
}
