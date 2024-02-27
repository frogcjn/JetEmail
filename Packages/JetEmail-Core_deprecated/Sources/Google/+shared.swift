//
//  Shared.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/22/24.
//

public extension Google.Client {
    static var shared = Google.Client()
}


public extension Google.Keychain {
    static let shared = Google.Keychain()
}
