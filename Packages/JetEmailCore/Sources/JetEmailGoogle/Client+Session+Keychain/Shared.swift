//
//  Shared.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/22/24.
//

extension GoogleClient {
    public static let shared = GoogleClient()
}

extension SessionStore {
    static let shared = SessionStore()
}

extension Keychain {
    static let shared = Keychain()
}
