//
//  Shared.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/22/24.
//

import JetEmail_Foundation

public extension Client {
    @MainActor
    static var _shared: Client?
    
    @MainActor
    static var shared: Client { get async throws {
        if let _shared { return _shared }
        let client = try await Client()
        _shared = client
        return client
    } }
}

public extension SessionStore {
    static let shared = SessionStore()
}

