//
//  Shared.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/22/24.
//

/*public extension Google.Client {
    @MainActor
    static let shared = Google.Client()
}

public extension Google.Keychain {
    @MainActor
    static let shared = Google.Keychain()
}*/


public extension Client {
    @MainActor
    static let shared = Google.Client()
}

public extension SessionStore {
    static let shared = SessionStore()
}

public extension Keychain {
    @MainActor
    static let shared = Google.Keychain()
}
