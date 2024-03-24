//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/12/24.
//

public protocol ClientProtocol {
    associatedtype SessionType : Sendable

    @MainActor
    var sessions : [SessionType] { get async throws }
    
    @MainActor
    func        signIn (                                    ) async throws -> SessionType
    
    /*@MainActor
    func        signOut(session  : SessionType              ) async throws -> SessionType*/
    
    /*@MainActor
    func  removeSession(accountID: SessionType.AccountIDType)       throws -> SessionType?

    @MainActor
    func  storedSession(accountID: SessionType.AccountIDType)       throws -> SessionType?
    
    @MainActor
    func refreshSession(accountID: SessionType.AccountIDType) async throws -> SessionType*/
}


// Account Enum

extension PlatformEnum : ClientProtocol where
    Microsoft : ClientProtocol,
    Google    : ClientProtocol
{
    public typealias SessionType = PlatformEnum<Microsoft.SessionType, Google.SessionType>
    
    
    public var sessions: [SessionType] { get async throws {
        switch self {
        case .microsoft(let client): try await client.sessions.map(SessionType.microsoft)
        case    .google(let client): try await client.sessions.map(SessionType.google   )
        }
    } }
    
    public func signIn() async throws -> SessionType  {
        switch self {
        case .microsoft(let client): try await .microsoft(client.signIn())
        case    .google(let client): try await    .google(client.signIn())
       
        }
    }
    
    /*@MainActor
    public func storedSession(accountID: SessionType.AccountIDType) throws -> SessionType? {
        switch self {
        case .microsoft(let client):
            guard let accountID = accountID.microsoft else { throw SessionError.idNotForThePlatform }
            return try client.storedSession(accountID: accountID).map(SessionType.microsoft)
        case    .google(let client):
            guard let accountID = accountID.google else { throw SessionError.idNotForThePlatform }
            return try client.storedSession(accountID: accountID).map(SessionType.google)
        }
    }
    
    public func refreshSession(accountID: SessionType.AccountIDType) async throws -> SessionType {
        switch self {
        case .microsoft(let client):
            guard let accountID = accountID.microsoft else { throw SessionError.idNotForThePlatform }
            return try await .microsoft(client.refreshSession(accountID: accountID))
        case    .google(let client):
            guard let accountID = accountID.google else { throw SessionError.idNotForThePlatform }
            return try await    .google(client.refreshSession(accountID: accountID))
        }
    }
    
    public func removeSession(accountID: SessionType.AccountIDType) throws -> SessionType? {
        switch self {
        case .microsoft(let client):
            guard let accountID = accountID.microsoft else { throw SessionError.idNotForThePlatform }
            return try client.removeSession(accountID: accountID).map(SessionType.microsoft)
        case    .google(let client):
            guard let accountID = accountID.google else { throw SessionError.idNotForThePlatform }
            return try client.removeSession(accountID: accountID).map(SessionType.google)
        }
    }*/
}

