//
//  GoogleAPI+.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/17/24.
//

// MARK: - GoogleAPI.Context: Client-Accounts API

extension GoogleAPI.Client {
    func addAccount() async throws -> GoogleAPI.Account {
        try await _addAccount()
    }
}

