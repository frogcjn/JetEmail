//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/19/24.
//

import Observation

import JetEmailData
import JetEmailGoogle
import JetEmailMicrosoft

@MainActor
@Observable
public class Clients : Sendable {
    public static let shared = Clients()
    init() {}
    
    public var microsoft: Client { .microsoft(MicrosoftClient.shared) }
    public var    google: Client {    .google(   GoogleClient.shared) }
    
    public func client(platform: Platform) throws -> Client {
        switch platform {
        case .microsoft:  microsoft
        case .google   :  google
        default        : throw PlatformEnumError.noPlatform(platform)
        }
    }
    
    public var clients: [Client] {
        [microsoft, google]
    }
    
    public var sessions: [Session] { get async throws {
        try await microsoft.sessions + google.sessions
    } }
    
    public func signIn(platform: Platform) async throws -> Session {
        try await client(platform: platform).signIn()
    }
}
