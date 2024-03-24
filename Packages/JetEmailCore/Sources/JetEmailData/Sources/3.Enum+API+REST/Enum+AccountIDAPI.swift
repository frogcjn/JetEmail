//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/19/24.
//

@MainActor
public protocol AccountToSessionProtocol {
    associatedtype AccountIDSessionType : Sendable
    
    var  storedSession: AccountIDSessionType? { get }
    var refreshSession: AccountIDSessionType { get async throws }
    func removeSession() -> AccountIDSessionType?
}

@MainActor
extension PlatformEnum : AccountToSessionProtocol where
Microsoft : AccountToSessionProtocol,
   Google : AccountToSessionProtocol
{
    public typealias AccountIDSessionType = PlatformEnum<Microsoft.AccountIDSessionType, Google.AccountIDSessionType>
    
    public var storedSession: AccountIDSessionType? {
        switch self {
        case .microsoft(let id): id.storedSession.map(AccountIDSessionType.microsoft)
        case    .google(let id): id.storedSession.map(AccountIDSessionType.google)
        }
    }
    
    public var refreshSession: AccountIDSessionType { get async throws {
        switch self {
        case .microsoft(let id): try await .microsoft(id.refreshSession)
        case    .google(let id): try await    .google(id.refreshSession)
        }
    } }
    
    public func removeSession() -> AccountIDSessionType? {
        switch self {
        case .microsoft(let id): id.removeSession().map(AccountIDSessionType.microsoft)
        case    .google(let id): id.removeSession().map(AccountIDSessionType.google)
        }
    }
}
