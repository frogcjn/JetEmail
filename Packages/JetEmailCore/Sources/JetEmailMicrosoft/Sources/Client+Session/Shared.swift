//
//  Shared.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/22/24.
//

import JetEmailData

extension MicrosoftClient {
    @MainActor
    static var _shared: MicrosoftClient?
    
    @MainActor
    public static var shared: MicrosoftClient { get async throws {
        if let _shared { return _shared }
        let client = try await MicrosoftClient()
        _shared = client
        return client
    } }
}

extension SessionStore {
    static let shared = SessionStore()
}

extension MicrosoftAccountID.AttributesStore {
    static var shared = AttributesStore()
}
