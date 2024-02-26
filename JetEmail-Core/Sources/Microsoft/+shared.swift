//
//  Shared.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/22/24.
//

import JetEmail_Foundation

public extension Microsoft.Client {
    static var _shared: Microsoft.Client?
    static var shared: Microsoft.Client { get async throws {
            if let _shared { return _shared }
            let client = try await Task { @BackgroundActor in
                BackgroundActor.assertIsolated()
                return try Microsoft.Client()
            }.value
            _shared = client
            return client
        }
    }
}
