//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/19/24.
//

@MainActor
public protocol AccountSessionAPI {
    associatedtype SessionType
    
    var  storedSession: SessionType? { get }
    var refreshSession: SessionType? { get async throws }
    func removeSession() -> SessionType?
}

@MainActor
extension PlatformEnum : AccountSessionAPI where
Microsoft : AccountSessionAPI,
   Google : AccountSessionAPI
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
