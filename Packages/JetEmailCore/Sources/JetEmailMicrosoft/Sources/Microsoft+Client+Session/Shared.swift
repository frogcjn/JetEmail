//
//  Shared.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/22/24.
//

import JetEmailData

public extension MicrosoftClient {
    @MainActor
    fileprivate static var _shared: MicrosoftClient?
    
    @MainActor
    static var shared: MicrosoftClient { get async throws {
        if let _shared { return _shared }
        let client = try await Task.detached { try MicrosoftClient() }.value
        _shared = client
        return client
    } }
}

/*@globalActor
public actor MicrosoftClientActor {
    public static var shared = MicrosoftClientActor()
}*/

extension SessionStore {
    static let shared = SessionStore()
}

extension MicrosoftAccountID.AttributesStore {
    static var shared = AttributesStore()
}
