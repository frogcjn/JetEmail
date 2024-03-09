//
//  Shared.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/22/24.
//

extension Client {
    @MainActor
    static var _shared: Client?
    
    @MainActor
    public static var shared: Client { get async throws {
        if let _shared { return _shared }
        let client = try await Client()
        _shared = client
        return client
    } }
}

extension SessionStore {
    static let shared = SessionStore()
}
