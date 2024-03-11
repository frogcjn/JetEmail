//
//  Shared.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/22/24.
//

public extension GoogleClient {
    static let shared = GoogleClient()
}

extension SessionStore {
    static let shared = SessionStore()
}

extension Keychain {
    static let shared = Keychain()
}
