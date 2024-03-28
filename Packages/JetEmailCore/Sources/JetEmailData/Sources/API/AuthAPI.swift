//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/12/24.
//

// MARK: Client - Session API

public protocol ClientAuthProtocol {
    associatedtype ClientSessionType

    @MainActor
    var sessions : [ClientSessionType] { get async throws }
    
    @MainActor
    func signIn() async throws -> ClientSessionType
}


public protocol SessionAuthProtocol {
    @MainActor
    var refresh: Self { get async throws }
    
    @MainActor
    func signOut() async throws -> Self
}

@MainActor
public protocol AccountIDAuthProtocol {
    associatedtype AccountIDSessionType
    
    var  cachedSession: AccountIDSessionType? { get }
    var refreshSession: AccountIDSessionType  { get async throws }
    func removeSession() -> AccountIDSessionType?
}
