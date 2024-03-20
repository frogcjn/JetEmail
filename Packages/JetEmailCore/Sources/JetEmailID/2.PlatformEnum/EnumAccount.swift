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

@MainActor
extension PlatformEnum : AccountIDSessionAPI where
Microsoft : AccountIDSessionAPI,
Google : AccountIDSessionAPI
{
    public typealias SessionType = PlatformEnum<Microsoft.SessionType, Google.SessionType>
    
    public var storedSession: SessionType? {
        switch self {
        case .microsoft(let id): id.storedSession.map(SessionType.microsoft)
        case    .google(let id): id.storedSession.map(SessionType.google)
        }
    }
    
    public var refreshSession: SessionType? { get async throws {
        switch self {
        case .microsoft(let id): try await id.refreshSession.map(SessionType.microsoft)
        case    .google(let id): try await id.refreshSession.map(SessionType.google)
        }
    } }
    
    public func removeSession() -> SessionType? {
        switch self {
        case .microsoft(let id): id.removeSession().map(SessionType.microsoft)
        case    .google(let id): id.removeSession().map(SessionType.google)
        }
    }
}
