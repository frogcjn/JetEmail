//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/12/24.
//

public protocol ClientProtocol<SessionType> {
    associatedtype SessionType
    func signIn() async throws -> SessionType
    var sessions: [SessionType] { get async throws }
}


// Account Enum

extension PlatformEnum : ClientProtocol where
    Microsoft : ClientProtocol,
    Google    : ClientProtocol
{
    public typealias SesisonType = PlatformEnum<Microsoft.SessionType, Google.SessionType>
    public func signIn() async throws -> SesisonType  {
        switch self {
        case .microsoft(let client): try await .microsoft(client.signIn())
        case    .google(let client): try await    .google(client.signIn())
        }
    }
    
    public var sessions: [SesisonType] { get async throws {
        switch self {
        case .microsoft(let client): try await client.sessions.map(SessionType.microsoft)
        case    .google(let client): try await client.sessions.map(SessionType.google   )
        }
    } }
}
