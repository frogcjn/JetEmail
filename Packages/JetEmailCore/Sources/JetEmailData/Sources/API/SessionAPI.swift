//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/12/24.
//

// MARK: Client - Session API

public protocol ClientSessionAPI {
    associatedtype ClientSessionType

    @MainActor
    var sessions : [ClientSessionType] { get async throws }
    
    @MainActor
    func signIn() async throws -> ClientSessionType
}


public protocol SessionAPIProtocol {
    @MainActor
    var refresh: Self { get async throws }
    
    @MainActor
    func signOut() async throws -> Self
}

@MainActor
public protocol AccountIDSessionAPI {
    associatedtype AccountIDSessionType
    
    var  storedSession: AccountIDSessionType? { get }
    var refreshSession: AccountIDSessionType  { get async throws }
    func removeSession() -> AccountIDSessionType?
}
