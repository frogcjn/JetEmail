//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/12/24.
//

public protocol ClientProtocol<SessionType> {
    associatedtype SessionType
    func signIn() async throws -> SessionType
}


// Account Enum

extension PlatformEnum : ClientProtocol where
    Microsoft : ClientProtocol,
    Google    : ClientProtocol
{
    public func signIn() async throws -> PlatformEnum<Microsoft.SessionType, Google.SessionType> {
        switch self {
        case .microsoft(let client): try await .microsoft(client.signIn())
        case    .google(let client): try await    .google(client.signIn())
        }
    }
}
