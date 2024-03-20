//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/19/24.
//

import JetEmailID
import JetEmailGoogle
import JetEmailMicrosoft
import Observation

@MainActor
@Observable
public class Clients : Sendable {
    init() {}
    
    public var microsoft: MicrosoftClient { get async throws {
        try await MicrosoftClient.shared
    } }
    public var google: GoogleClient { GoogleClient.shared }
    
    public func client(platform: Platform) async throws -> Client {
        switch platform {
        case .microsoft: try await .microsoft(microsoft)
        case .google   :              .google(   google)
        default        : fatalError() // TODO: Throw Error
        }
    }
    
    public var sessions: [Session] { get async throws {
        try await client(platform: .microsoft).sessions + client(platform: .google).sessions
    } }
}
